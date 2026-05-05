# 10 — Config & Data Management

> **Cel:** Zarządzanie konfiguracją aplikacji — BaseSettings, env vars, pliki config, walidacja, serializacja, immutability.
> **Scope:** Uniwersalny — Python ≥3.10, pydantic ≥2.0, pydantic-settings ≥2.0.
> **NIE duplikuje:** basic dataclass vs pydantic (→05 §7), type hints (→02), error handling (→08), design patterns (→09).

---

## Spis treści

1. [BaseSettings — konfiguracja aplikacji](#1-basesettings--konfiguracja-aplikacji)
2. [Environment variables & secrets](#2-environment-variables--secrets)
3. [Nested & hierarchical config](#3-nested--hierarchical-config)
4. [Walidacja — field_validator & model_validator](#4-walidacja--field_validator--model_validator)
5. [Serializacja & deserializacja](#5-serializacja--deserializacja)
6. [Config files — TOML & YAML](#6-config-files--toml--yaml)
7. [Config hierarchy & precedence](#7-config-hierarchy--precedence)
8. [Frozen config & immutability](#8-frozen-config--immutability)
9. [Antypatterny](#9-antypatterny)
10. [Egzekucja ruff](#10-egzekucja-ruff)


## 📋 Quick Reference (ściąga)

| # | Reguła |
|---|--------|
| 1 | **BaseSettings** = app config z env vars. **BaseModel** = DTO / API models |
| 2 | **`.env` w `.gitignore`** — ZAWSZE. Commituj `.env.example` z placeholderami |
| 3 | **`SecretStr`** dla API keys, passwords — nigdy nie loguj `.get_secret_value()` |
| 4 | **`env_prefix`** — namespace isolation per service (`DB_`, `REDIS_`, `API_`) |
| 5 | **`env_nested_delimiter="__"`** — nested config z env vars |
| 6 | **`frozen=True`** na global settings — immutable po załadowaniu |
| 7 | **Constructor injection** — pass config do services, NIE global import |
| 8 | **`model_post_init`** — side effects po load (mkdir, setup) |
| 9 | **`yaml.safe_load()`** — NIGDY `yaml.load()` (RCE!) |
| 10 | **Precedence:** defaults < `.env` < `os.environ` < CLI |
| 11 | **Pydantic v2 API:** `.model_dump()`, `.model_validate()`, NIE `.dict()`, `.parse_obj()` |

---

## 1. BaseSettings — konfiguracja aplikacji

### 1.1 Kiedy BaseSettings vs BaseModel

| Użyj | `BaseSettings` | `BaseModel` |
|------|---------------|-------------|
| **Kiedy** | App-level config, env vars, `.env` | Per-request DTO, API model, domain object |
| **Env vars** | ✅ Automatyczny odczyt z `os.environ` | ❌ Brak |
| **`.env` file** | ✅ Wbudowane | ❌ Brak |
| **Walidacja** | ✅ Pełna | ✅ Pełna |
| **Frozen** | Opcjonalnie | Opcjonalnie |
| **Przykład** | `DatabaseSettings`, `AppConfig` | `CreateUserRequest`, `OrderItem` |

### 1.2 Podstawowy wzorzec

> **ConfigDict vs SettingsConfigDict:**
> | Użyj | Dla | Kiedy |
> |------|-----|-------|
> | `ConfigDict` (BaseModel) | Walidacja per-instance, serializacja | Domeny, DTOs, API models |
> | `SettingsConfigDict` (BaseSettings) | Env vars, `.env` file, app-level config | Global config, application settings |

```python
from __future__ import annotations

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class AppSettings(BaseSettings):
    """Główna konfiguracja aplikacji — ładowana z env vars i .env."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    # Wymagane — brak default → MUSI być w env
    database_url: str
    secret_key: str

    # Opcjonalne z defaultami
    debug: bool = False
    port: int = Field(default=8000, ge=1, le=65535)
    workers: int = Field(default=4, ge=1, le=32)
    log_level: str = Field(default="INFO", pattern=r"^(DEBUG|INFO|WARNING|ERROR|CRITICAL)$")
```

### 1.3 `SettingsConfigDict` — kluczowe opcje

| Opcja | Default | Opis |
|-------|---------|------|
| `env_file` | `None` | Ścieżka do `.env` file |
| `env_file_encoding` | `"utf-8"` | Encoding |
| `env_prefix` | `""` | Prefix dla env vars (np. `"APP_"`) |
| `env_nested_delimiter` | `None` | Delimiter dla nested models (np. `"__"`) |
| `case_sensitive` | `False` | Case-sensitivity dla env var names |
| `extra` | `"ignore"` | Co z nieznanymi polami: `"ignore"`, `"forbid"`, `"allow"` |
| `secrets_dir` | `None` | Katalog z secret files (Docker secrets) |

### 1.4 `model_post_init` — side effects po załadowaniu

```python
from pathlib import Path


class StorageSettings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="STORAGE_")

    data_dir: Path = Path("data")
    cache_dir: Path = Path(".cache")

    def model_post_init(self, __context: object) -> None:
        """Tworzenie katalogów po załadowaniu config."""
        self.data_dir.mkdir(parents=True, exist_ok=True)
        self.cache_dir.mkdir(parents=True, exist_ok=True)
```

---

## 2. Environment variables & secrets

### 2.1 Zasady 12-factor

> 🔒 **HARD RULE:** Config w env vars, NIE w kodzie. Secrets NIGDY w repozytorium.

| ✅ | ❌ |
|---|---|
| `DATABASE_URL` w `.env` | `db_url = "postgres://user:pass@localhost"` w kodzie |
| `.env` w `.gitignore` | `.env` committed do repo |
| `SECRET_KEY` z env var | `secret = "hardcoded-key-123"` |
| `settings.database_url` (z BaseSettings) | `os.environ["DATABASE_URL"]` direct access |

### 2.2 `.env` file format

```ini
# Komentarze z #
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb
SECRET_KEY="super-secret-key-here"
DEBUG=true
PORT=8000

# Nested (z env_nested_delimiter="__")
REDIS__HOST=localhost
REDIS__PORT=6379
```

### 2.3 `env_prefix` — namespace isolation

```python
class DatabaseSettings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="DB_")

    host: str = "localhost"
    port: int = 5432
    name: str = "mydb"
    # Env vars: DB_HOST, DB_PORT, DB_NAME


class RedisSettings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="REDIS_")

    host: str = "localhost"
    port: int = 6379
    # Env vars: REDIS_HOST, REDIS_PORT
```

### 2.4 Secrets — co NIGDY nie logować

```python
from pydantic import SecretStr


class ApiSettings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="API_")

    api_key: SecretStr  # .get_secret_value() do odczytu
    base_url: str = "https://api.example.com"


# ✅ Bezpieczne logowanie
settings = ApiSettings()
logger.info("API url: {url}", url=settings.base_url)
# logger.info wypisze: api_key=SecretStr('**********')

# ✅ Użycie sekretu
headers = {"Authorization": f"Bearer {settings.api_key.get_secret_value()}"}

# ❌ NIGDY nie loguj secret value
logger.info("Key: {key}", key=settings.api_key.get_secret_value())  # SECURITY RISK!
```

---

## 3. Nested & hierarchical config

### 3.1 Wzorzec — composition via `Field(default_factory=...)`

```python
from __future__ import annotations

from pydantic import BaseModel, Field
from pydantic_settings import BaseSettings, SettingsConfigDict


# Sub-config — BaseModel (nie BaseSettings, bo nie czyta env samodzielnie)
class DatabaseConfig(BaseModel):
    host: str = "localhost"
    port: int = 5432
    name: str = "mydb"
    pool_size: int = Field(default=10, ge=1, le=100)


class CacheConfig(BaseModel):
    backend: str = "redis"
    ttl_seconds: int = Field(default=300, ge=0)
    max_size: int = Field(default=1000, ge=0)


# Root config — BaseSettings z nested models
class AppSettings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_nested_delimiter="__",
    )

    app_name: str = "myapp"
    debug: bool = False
    database: DatabaseConfig = Field(default_factory=DatabaseConfig)
    cache: CacheConfig = Field(default_factory=CacheConfig)

    # ⚠️ default_factory ewaluowany PER INSTANCJI — NIE używaj mutable defaults
    # na level nested klas. Np. host: list = [] → Field(default_factory=list)
```

```ini
# .env — nested z delimiter __
DATABASE__HOST=production-db.example.com
DATABASE__PORT=5433
DATABASE__POOL_SIZE=20
CACHE__TTL_SECONDS=600
```

### 3.2 Service-specific config injection

```python
# ✅ Config per service — inject via constructor
class EmailService:
    def __init__(self, config: EmailConfig) -> None:
        self._config = config

    async def send(self, to: str, subject: str, body: str) -> None:
        async with self._create_client() as client:
            await client.send(
                to=to,
                subject=subject,
                body=body,
                from_addr=self._config.from_address,
            )


# ✅ Bootstrap — wire config → services
def create_services(settings: AppSettings) -> AppServices:
    return AppServices(
        email=EmailService(config=settings.email),
        storage=StorageService(config=settings.storage),
    )
```

```python
# ❌ Global singleton — tight coupling, hard to test
settings = AppSettings()  # Module-level!

class EmailService:
    def send(self) -> None:
        from_addr = settings.email.from_address  # Implicit dependency!
```

---

## 4. Walidacja — field_validator & model_validator

### 4.1 `@field_validator` — walidacja per-field

```python
from pydantic import BaseModel, Field, field_validator


class ServerConfig(BaseModel):
    host: str = "0.0.0.0"
    port: int = Field(default=8000, ge=1, le=65535)
    allowed_origins: list[str] = Field(default_factory=list)

    @field_validator("host")
    @classmethod
    def validate_host(cls, v: str) -> str:
        if not v or v.isspace():
            msg = "Host cannot be empty"
            raise ValueError(msg)
        return v.strip()

    @field_validator("allowed_origins", mode="before")
    @classmethod
    def parse_origins(cls, v: str | list[str]) -> list[str]:
        """Akceptuj string CSV lub listę."""
        if isinstance(v, str):
            return [o.strip() for o in v.split(",") if o.strip()]
        return v
```

### 4.2 `@model_validator` — cross-field walidacja

```python
from pydantic import model_validator


class DatabaseConfig(BaseModel):
    host: str
    port: int
    read_replicas: list[str] = Field(default_factory=list)
    pool_size: int = Field(default=10, ge=1)

    @model_validator(mode="after")
    def validate_pool_size(self) -> DatabaseConfig:
        """Pool size musi być >= liczba replik + 1 (primary)."""
        min_pool = len(self.read_replicas) + 1
        if self.pool_size < min_pool:
            msg = f"pool_size ({self.pool_size}) must be >= {min_pool} (replicas + primary)"
            raise ValueError(msg)
        return self
```

### 4.3 Tabela: kiedy który validator

| Sytuacja | Użyj | Przykład |
|----------|------|---------|
| Format jednego pola | `@field_validator` | Email format, URL parse |
| Transformacja na wejściu | `@field_validator(mode="before")` | CSV string → list |
| Sanitization | `@field_validator` + return normalized | `.strip()`, `.lower()` |
| Cross-field dependency | `@model_validator(mode="after")` | pool_size ≥ replicas |
| Cały model pre-processing | `@model_validator(mode="before")` | Rename keys, flatten |
| Side effects po load | `model_post_init` | Tworzenie katalogów |

---

## 5. Serializacja & deserializacja

### 5.1 Tabela metod

| Kierunek | Metoda | Input / Output |
|----------|--------|----------------|
| Model → dict | `.model_dump()` | `dict` |
| Model → JSON string | `.model_dump_json()` | `str` |
| Model → JSON Schema | `.model_json_schema()` | `dict` (JSON Schema) |
| dict → Model | `.model_validate(data)` | Model instance |
| JSON string → Model | `.model_validate_json(json_str)` | Model instance |
| arbitrary → Model | `.model_validate_python(obj)` | Model instance |

### 5.2 Snippety

```python
from pydantic import BaseModel


class UserProfile(BaseModel):
    name: str
    email: str
    tags: list[str] = []


# ✅ Serializacja
user = UserProfile(name="Alice", email="alice@example.com", tags=["admin"])
data = user.model_dump()                    # {'name': 'Alice', 'email': 'alice@example.com', 'tags': ['admin']}
json_str = user.model_dump_json(indent=2)   # Pretty JSON string

# ✅ Serializacja z filtrowaniem
data = user.model_dump(exclude={"email"})              # Bez email
data = user.model_dump(include={"name", "tags"})       # Tylko name + tags
data = user.model_dump(exclude_defaults=True)           # Tylko non-default values
data = user.model_dump(exclude_none=True)               # Bez None values

# ✅ Deserializacja
user = UserProfile.model_validate({"name": "Bob", "email": "bob@example.com"})
user = UserProfile.model_validate_json('{"name": "Bob", "email": "bob@example.com"}')
```

```python
# ❌ Legacy API (pydantic v1)
user.dict()       # → .model_dump()
user.json()       # → .model_dump_json()
User.parse_obj()  # → .model_validate()
User.parse_raw()  # → .model_validate_json()
```

---

## 6. Config files — TOML & YAML

### 6.1 TOML — stdlib (Python ≥3.11) lub `tomli` (backport)

```python
from __future__ import annotations

import sys
from pathlib import Path

if sys.version_info >= (3, 11):
    import tomllib
else:
    import tomli as tomllib  # backport for 3.10


def load_config(path: Path) -> AppSettings:
    """Załaduj config z TOML, nadpisz env vars."""
    raw = tomllib.loads(path.read_text(encoding="utf-8"))
    return AppSettings(**raw)
```

```toml
# config.toml
app_name = "myapp"
debug = false

[database]
host = "localhost"
port = 5432
pool_size = 10

[cache]
backend = "redis"
ttl_seconds = 300
```

### 6.2 YAML — z `pyyaml` lub `ruamel.yaml`

```python
import yaml
from pathlib import Path


def load_yaml_config(path: Path) -> AppSettings:
    """Załaduj config z YAML."""
    raw = yaml.safe_load(path.read_text(encoding="utf-8"))  # ZAWSZE safe_load!
    return AppSettings.model_validate(raw)
```

> 🔒 **SECURITY CRITICAL:**
> - **`yaml.safe_load()`** — bezpieczny, zwraca zwykłe obiekty Python (dict, list, str)
> - **`yaml.load()`** — RCE vulnerability! Pozwala na arbitrary code execution
> - **NIGDY** nie używaj `yaml.load()` z nieufanym inputem

### 6.3 Tabela: kiedy który format

| Format | Kiedy | Zalety | Wady |
|--------|-------|--------|------|
| `.env` | Env vars, secrets, deployment | Proste, 12-factor, Docker-native | Brak nesting, brak typów |
| TOML | App config, pyproject.toml | Typowany, stdlib (3.11+), czytelny | Read-only w stdlib |
| YAML | Złożone configs, K8s | Deep nesting, anchors/aliases | Security risk (`yaml.load`), deps |
| JSON | API exchange, schemas | Universal, schema validation | Brak komentarzy, verbose |

---

## 7. Config hierarchy & precedence

### 7.1 4-tier precedence

```
Najwyższy priorytet
   ↑
   │  4. CLI arguments / runtime overrides
   │  3. Environment variables (os.environ)
   │  2. .env file
   │  1. Code defaults (Field(default=...))
   ↓
Najniższy priorytet
```

> **Pydantic-settings** automatycznie respektuje tę kolejność: env var > .env file > default.

### 7.2 Wzorzec — multi-source config

```python
from __future__ import annotations

from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict


class AppSettings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
    )

    debug: bool = False
    port: int = 8000


def load_settings(config_path: Path | None = None) -> AppSettings:
    """Załaduj settings: defaults < TOML < .env < env vars."""
    if config_path and config_path.exists():
        raw = tomllib.loads(config_path.read_text(encoding="utf-8"))
        return AppSettings(**raw)  # TOML values, nadpisane przez env vars
    return AppSettings()  # Tylko defaults + .env + env vars
```

---

## 8. Frozen config & immutability

### 8.1 Kiedy frozen

| Sytuacja | Frozen | Dlaczego |
|----------|--------|----------|
| Global app settings | ✅ TAK | Config nie powinien zmieniać się w runtime |
| Per-request context | ❌ NIE | Może wymagać updateów |
| Test fixtures | ⚠️ Depends | Freeze production, mutuj w testach |

### 8.2 Snippety

```python
from pydantic import ConfigDict
from pydantic_settings import BaseSettings, SettingsConfigDict


# ✅ Frozen settings — immutable po załadowaniu
class AppSettings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        frozen=True,  # TypeError przy próbie mutation
    )

    database_url: str
    debug: bool = False


settings = AppSettings()
settings.debug = True  # ❌ TypeError: "AppSettings" is frozen
```

```python
# ✅ Override w testach — model_copy()
def test_debug_mode():
    base = AppSettings(database_url="sqlite:///test.db")
    debug_settings = base.model_copy(update={"debug": True})
    assert debug_settings.debug is True
```

### 8.3 `.env.example` — dokumentuj wymagane zmienne

```ini
# .env.example — commituj do repo (NIGDY nie commituj .env!)
# Skopiuj: cp .env.example .env

# === REQUIRED ===
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
SECRET_KEY=change-me-to-random-string

# === OPTIONAL (mają defaults w kodzie) ===
DEBUG=false
PORT=8000
WORKERS=4
LOG_LEVEL=INFO

# === SERVICES ===
# API_KEY=your-api-key-here
# REDIS_HOST=localhost
# REDIS_PORT=6379
```

> **Reguła:** `.env` → `.gitignore`. `.env.example` → git (z placeholderami, BEZ prawdziwych secrets).

---

## 9. Antypatterny

| # | Antypattern ❌ | Fix ✅ | Dlaczego |
|---|---------------|-------|----------|
| 1 | `os.environ["KEY"]` direct | `BaseSettings` z `env_prefix` | Centralizacja, walidacja, typing |
| 2 | `os.getenv("KEY", "default")` everywhere | `BaseSettings` z `Field(default=...)` | Defaults w jednym miejscu |
| 3 | Hardcoded secrets w kodzie | `.env` + `SecretStr` | Security |
| 4 | `.env` w git | `.gitignore` + `.env.example` | Security |
| 5 | `yaml.load()` bez safe | `yaml.safe_load()` | RCE vulnerability |
| 6 | Global mutable settings | `frozen=True` + injection | Predictability, testing |
| 7 | Raw dict jako config | `BaseModel` / `BaseSettings` | Typing, validation, IDE support |
| 8 | Config per-module import | Constructor injection | Testability, coupling |
| 9 | `.dict()` / `.json()` (v1) | `.model_dump()` / `.model_dump_json()` | Pydantic v2 API |
| 10 | `parse_obj()` (v1) | `.model_validate()` | Pydantic v2 API |

---

## 10. Egzekucja ruff

### 10.1 Reguły powiązane z config/data

| Ruff | Nazwa | Co łapie |
|------|-------|----------|
| `RUF009` | mutable-dataclass-default | `items: list = []` → `field(default_factory=list)` |
| `RUF012` | mutable-class-variable | Mutable class-level variables bez `ClassVar` |
| `B006` | mutable-argument-default | `def f(x=[])` → `def f(x=None)` |
| `S105` | hardcoded-password-string | `password = "secret"` w kodzie |
| `S106` | hardcoded-password-argument | `connect(password="secret")` |
| `S107` | hardcoded-password-default | `def f(password="default")` |
| `UP` | pyupgrade | `ConfigDict` > inner `class Config` (pydantic v2) |

### 10.2 per-file-ignores — wyjątki dla config

```toml
[tool.ruff.lint.per-file-ignores]
"tests/**" = ["S105", "S106"]  # Hardcoded test passwords OK
"**/fixtures/**" = ["S105"]    # Test fixtures z dummy secrets
```

---
## Źródła

> - [Pydantic Settings docs](https://docs.pydantic.dev/latest/concepts/pydantic_settings/) — BaseSettings, env vars, .env
> - [Pydantic Validators](https://docs.pydantic.dev/latest/concepts/validators/) — field_validator, model_validator
> - [Pydantic Serialization](https://docs.pydantic.dev/latest/concepts/serialization/) — model_dump, model_dump_json
> - [12-Factor App — Config](https://12factor.net/config) — env vars best practices
> - [PEP 680](https://peps.python.org/pep-0680/) — tomllib (stdlib TOML parser)
> - [YAML Security](https://pyyaml.org/wiki/PyYAMLDocumentation) — safe_load vs load
> - `05-code-patterns.md` §7 — dataclass vs pydantic (basic comparison)
> - `08-error-handling.md` — ValidationError handling patterns
