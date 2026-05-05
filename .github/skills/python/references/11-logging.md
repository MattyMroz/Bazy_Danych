# 11 — Logging

> **Cel:** Standardy logowania — loguru, levels, structured logging, exception logging, konfiguracja, security.
> **Scope:** Uniwersalny — Python ≥3.10, loguru jako primary logger, ruff rules.
> **NIE duplikuje:** error handling (→08), config (→10), design patterns (→09).

---

## Spis treści

1. [Log levels & semantyka](#1-log-levels--semantyka)
2. [Formatowanie — lazy `{}` placeholders](#2-formatowanie--lazy--placeholders)
3. [Exception logging](#3-exception-logging)
4. [Structured logging & context](#4-structured-logging--context)
5. [Konfiguracja loguru](#5-konfiguracja-loguru)
6. [Security — co NIE logować](#6-security--co-nie-logować)
7. [Antypatterny](#7-antypatterny)
8. [Egzekucja ruff](#8-egzekucja-ruff)


## 📋 Quick Reference (ściąga)

| # | Reguła |
|---|--------|
| 1 | **loguru `{}`** — `logger.info("x: {val}", val=x)`, NIE f-string, NIE `%s` |
| 2 | **`logger.exception()`** w `except` — auto-traceback, NIE `logger.error()` |
| 3 | **`logger.opt(exception=exc)`** — exception logging poza `except` block |
| 4 | **`logger.bind()`** — context injection (request_id, service name) |
| 5 | **`enqueue=True`** w produkcji — thread-safe, non-blocking I/O |
| 6 | **`serialize=True`** — JSON output dla machine-readable logów |
| 7 | **NIGDY nie loguj sekretów** — passwords, API keys, tokens, PII |
| 8 | **Jeden log per event** — z pełnym kontekstem, nie wiele `logger.info()` |
| 9 | **`logger.remove()` + `logger.add()`** — konfiguruj RAZ w entrypoint |
| 10 | **InterceptHandler** — bridge stdlib logging → loguru |
| 11 | **Level semantyka:** DEBUG=dev, INFO=milestones, WARNING=recoverable, ERROR=failed |

---

## 1. Log levels & semantyka

### 1.1 Tabela poziomów

| Level | Kiedy | Przykład | Produkcja |
|-------|-------|---------|-----------|
| `TRACE` | Ultra-szczegółowe debugging | Wartości zmiennych w pętli | ❌ Wyłączony |
| `DEBUG` | Informacje deweloperskie | Czas wykonania, parametry wywołań | ❌ Wyłączony |
| `INFO` | Znaczące zdarzenia biznesowe | Start/stop serwera, task completed | ✅ Włączony |
| `SUCCESS` | Zakończenie operacji sukcesem | Pipeline completed, migration done | ✅ Włączony |
| `WARNING` | Potencjalny problem, ale działa | Deprecation, retry, fallback użyty | ✅ Włączony |
| `ERROR` | Operacja się nie powiodła | Request failed, file not found | ✅ Włączony |
| `CRITICAL` | System nie może kontynuować | DB connection lost, OOM | ✅ Włączony |

### 1.2 Zasady wyboru poziomu

> 🔒 **HARD RULE:** Jeśli nie wiesz jaki level — użyj `INFO`. Zbyt cicho > zbyt głośno.

```python
from loguru import logger

# ✅ Poprawne użycie levelów
logger.debug("Loaded {count} items from cache", count=len(items))
logger.info("Server started on port {port}", port=port)
logger.success("Migration completed: {tables} tables updated", tables=count)
logger.warning("Rate limit approaching: {current}/{limit}", current=current, limit=limit)
logger.error("Failed to send email to {recipient}", recipient=email)
logger.critical("Database connection pool exhausted")
```

```python
# ❌ Złe użycie levelów
logger.info("x = 42")                    # Za dużo detail → DEBUG
logger.debug("Server started")            # Za ważne na DEBUG → INFO
logger.error("Retrying in 5 seconds")     # Retry = recoverable → WARNING
logger.warning("Cannot connect to DB")     # Critical failure → ERROR/CRITICAL
```

### 1.3 Reguła: jeden log per event

```python
# ✅ Jeden log z kontekstem
logger.info(
    "Request processed: {method} {path} → {status} ({duration:.1f}ms)",
    method=method,
    path=path,
    status=status,
    duration=duration_ms,
)

# ❌ Wiele logów na to samo zdarzenie
logger.info("Processing request...")
logger.info("Method: {}", method)
logger.info("Path: {}", path)
logger.info("Done!")
```

---

## 2. Formatowanie — lazy `{}` placeholders

### 2.1 Reguła główna

> 🔒 **HARD RULE:** Loguru używa `{}` placeholders z **named kwargs**. NIE f-string, NIE `%s`.

| ✅ Poprawne | ❌ Błędne | Dlaczego |
|------------|----------|----------|
| `logger.info("x: {val}", val=x)` | `logger.info(f"x: {x}")` | f-string ewaluowany ZAWSZE |
| `logger.info("x: {}", x)` | `logger.info("x: %s", x)` | `%s` to stdlib, nie loguru |
| `logger.info("x: {val!r}", val=x)` | `logger.info("x: " + str(x))` | Konkatenacja = eager |

### 2.2 Dlaczego lazy

```python
# ✅ Lazy — {val} NIE jest ewaluowane gdy level < configured
logger.debug("Heavy computation result: {result}", result=expensive_function())
# ⚠️ UWAGA: w loguru argumenty SĄ ewaluowane (bo to kwargs),
# ale string formatting jest pomijane. Dla prawdziwie lazy compute:

logger.opt(lazy=True).debug("Heavy: {result}", result=lambda: expensive_function())

# ❌ Eager — f-string ewaluowany ZAWSZE, nawet gdy DEBUG wyłączony
logger.debug(f"Heavy: {expensive_function()}")  # expensive_function() wywołane ZAWSZE!
```

### 2.3 Format spec w loguru

```python
# ✅ Formatowanie w placeholderach
logger.info("Size: {size:.1f} MB", size=size_mb)
logger.info("Progress: {pct:.1%}", pct=done / total)
logger.info("Step {step:>3d}/{total:>3d}", step=step, total=total)
logger.info("Object: {obj!r}", obj=obj)          # repr()
logger.info("Type: {obj!s}", obj=obj)             # str()
```

---

## 3. Exception logging

### 3.1 Tabela decyzyjna

| Sytuacja | Użyj | Traceback? |
|----------|------|-----------|
| W `except` — chcesz pełny traceback | `logger.exception("msg")` | ✅ Automatyczny |
| W `except` — masz exc variable | `logger.opt(exception=exc).error("msg")` | ✅ Z exc |
| Poza `except` — masz wyjątek | `logger.opt(exception=exc).error("msg")` | ✅ Z exc |
| Log bez traceback | `logger.error("msg")` | ❌ Brak |

### 3.2 Snippety

```python
# ✅ W except — pełny traceback automatycznie
try:
    process_data(payload)
except ValueError:
    logger.exception("Failed to process payload")
    # Loguru automatycznie dołącza traceback!

# ✅ W except — z exc variable
try:
    connect(url)
except ConnectionError as exc:
    logger.opt(exception=exc).error("Connection failed: {url}", url=url)

# ✅ Poza except — exception z innego kontekstu
def handle_error(exc: Exception) -> None:
    logger.opt(exception=exc).error("Deferred error handling")
```

```python
# ❌ TRY401: Redundantne stringowanie wyjątku
try:
    process()
except ValueError as exc:
    logger.exception(f"Error: {exc}")  # exc jest JUŻ w traceback!
    # → logger.exception("Processing failed")

# ❌ TRY400: logger.error zamiast logger.exception w except
try:
    process()
except ValueError:
    logger.error("Failed")  # Traceback STRACONY!
    # → logger.exception("Failed")

# ❌ Stringowanie traceback ręcznie
import traceback
logger.error("Error:\n" + traceback.format_exc())  # loguru robi to za ciebie!
```

### 3.3 `logger.opt(exception=...)` vs `logger.exception()`

| Metoda | Kontekst | Level | Traceback |
|--------|----------|-------|-----------|
| `logger.exception("msg")` | Wewnątrz `except` | ERROR | Auto z `sys.exc_info()` |
| `logger.opt(exception=exc).error("msg")` | Gdziekolwiek | Dowolny | Z podanego `exc` |
| `logger.opt(exception=True).warning("msg")` | Wewnątrz `except` | Dowolny | Auto z `sys.exc_info()` |

---

## 4. Structured logging & context

### 4.1 `logger.bind()` — context injection

> **Scope & Lifecycle:** `bind()` zwraca **nowy logger object** z attached context. Kontekst jest **immutable** i **powiązany z konkretnym obiektem logger** — nie wpływa na globalne `logger` instance.

```python
from loguru import logger

# ✅ Bind context na czas operacji
request_logger = logger.bind(request_id="abc-123", user_id=42)
request_logger.info("Processing started")
request_logger.info("Step 1 complete")
request_logger.info("Processing finished")
# Każdy log zawiera request_id i user_id jako extra fields

# ✅ Bind per module/service
service_logger = logger.bind(service="payment")
service_logger.info("Charge initiated: {amount}", amount=amount)
```

### 4.2 `logger.contextualize()` — temporary context

```python
from loguru import logger

# ✅ Context manager — automatycznie czyści po wyjściu
with logger.contextualize(task_id="task-456"):
    logger.info("Task started")
    process_task()
    logger.info("Task finished")
# Po wyjściu z `with` — task_id znika z logów
```

### 4.2b `bind()` vs `contextualize()` — porównanie

| Aspekt | `bind()` | `contextualize()` |
|--------|---------|-------------------|
| **Zwraca** | Nowy logger object | Context manager (None) |
| **Scope** | Trwa na `bound_logger` object | Trwa w bloku `with` |
| **Cleanup** | Manualna (nowy object) | Automatyczna na exit z `with` |
| **Kiedy użyć** | Per-service, per-request handler | Temporary scoped context (async tasks) |

### 4.3 Structured output (JSON)

```python
# ✅ JSON logs dla produkcji (machine-readable)
logger.add(
    "logs/app.log.jsonl",
    format="{message}",
    serialize=True,  # Automatyczny JSON output
    rotation="100 MB",
    retention="30 days",
    compression="gz",
)
```

Wynik:
```json
{"text": "Server started on port 8000", "record": {"level": {"name": "INFO"}, "time": "2024-01-15T10:30:00", "extra": {"port": 8000}}}
```

---

## 5. Konfiguracja loguru

### 5.1 Wzorzec: multi-sink setup

```python
from __future__ import annotations

import sys
from enum import StrEnum
from pathlib import Path

from loguru import logger


class LogMode(StrEnum):
    DEV = "dev"
    PROD = "prod"
    SILENT = "silent"


def setup_logging(mode: LogMode, log_dir: Path = Path("logs")) -> None:
    """Konfiguruj loguru — wywołaj RAZ na starcie aplikacji."""
    logger.remove()  # Usuń default handler (stderr)
    log_dir.mkdir(parents=True, exist_ok=True)

    match mode:
        case LogMode.DEV:
            # Console — kolorowy, czytelny
            logger.add(
                sys.stderr,
                level="DEBUG",
                format="<green>{time:HH:mm:ss}</green> | <level>{level:<8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan> - <level>{message}</level>",
                colorize=True,
            )
            # File — rotowany, pełny detail
            logger.add(
                log_dir / "dev.log",
                level="DEBUG",
                rotation="10 MB",
                retention="7 days",
                encoding="utf-8",
            )

        case LogMode.PROD:
            # JSON logs — machine-readable
            logger.add(
                log_dir / "app.log.jsonl",
                level="INFO",
                serialize=True,
                rotation="100 MB",
                retention="30 days",
                compression="gz",
                enqueue=True,  # Thread-safe queue; może blokować przy overflow
            )
            # Error log — osobny sink
            logger.add(
                log_dir / "errors.log.jsonl",
                level="ERROR",
                serialize=True,
                rotation="50 MB",
                retention="90 days",
                compression="gz",
                enqueue=True,
            )

        case LogMode.SILENT:
            pass  # Brak logowania (testy)
```

### 5.2 `logger.add()` — kluczowe opcje

| Opcja | Opis | Przykład |
|-------|------|---------|
| `level` | Min level do logowania | `"INFO"`, `"DEBUG"` |
| `format` | Format stringa | `"{time} {level} {message}"` |
| `rotation` | Kiedy rotować plik | `"100 MB"`, `"1 day"`, `"00:00"` |
| `retention` | Jak długo trzymać stare | `"30 days"`, `"10 files"` |
| `compression` | Kompresja starych | `"gz"`, `"zip"` |
| `serialize` | JSON output | `True` / `False` |
| `enqueue` | Thread-safe queue | `True` (produkcja!) |
| `colorize` | Kolorowy output | `True` (konsola) |
| `encoding` | Encoding pliku | `"utf-8"` |
| `filter` | Filtr logów | `lambda r: r["extra"].get("service") == "api"` |

### 5.3 InterceptHandler — bridge stdlib → loguru

```python
import logging
from loguru import logger


class InterceptHandler(logging.Handler):
    """Przekieruj stdlib logging → loguru."""

    def emit(self, record: logging.LogRecord) -> None:
        # Get loguru level
        try:
            level = logger.level(record.levelname).name
        except ValueError:
            level = record.levelno

        # Find caller
        frame, depth = logging.currentframe(), 2
        while frame and frame.f_code.co_filename == logging.__file__:
            frame = frame.f_back
            depth += 1

        logger.opt(depth=depth, exception=record.exc_info).log(level, record.getMessage())


# ✅ Użycie — w setup_logging()
logging.basicConfig(handlers=[InterceptHandler()], level=0, force=True)
```

> **Kiedy:** Gdy używasz bibliotek korzystających ze stdlib `logging` (uvicorn, httpx, sqlalchemy).

---

## 6. Security — co NIE logować

### 6.1 Tabela

| ✅ Loguj | ❌ NIGDY nie loguj |
|---------|-------------------|
| Request path / method | Passwords / API keys |
| User ID (numeric) | Email addresses (pełne) |
| Status codes | Credit card numbers |
| Timing / performance | Session tokens |
| Error messages (ogólne) | PII (imiona, adresy) |
| Config keys (bez wartości) | `.get_secret_value()` |
| HTTP method (GET, POST) | Authorization headers |

> ⚠️ **HTTP Security:** NIGDY nie loguj Header `Authorization`, `X-API-Key` — zawsze zawierają tokeny/klucze.

### 6.2 Snippety

```python
from pydantic import SecretStr

# ✅ Loguj metadata, nie dane
logger.info("User {user_id} logged in from {ip}", user_id=user.id, ip=request.ip)
logger.info("API call: {method} {path}", method=method, path=path)
logger.info("Config loaded: {keys}", keys=list(config.model_fields.keys()))

# ✅ Maskuj wrażliwe dane
def mask_email(email: str) -> str:
    local, domain = email.split("@")
    return f"{local[:2]}***@{domain}"

logger.info("Email sent to {email}", email=mask_email(recipient))
```

```python
# ❌ SECURITY RISK — logowanie secrets
logger.info("API key: {key}", key=settings.api_key.get_secret_value())
logger.debug("Password: {pw}", pw=password)
logger.info("Token: {token}", token=session_token)
logger.error("Auth failed for {email}", email=user_email)  # PII!
```

---

## 7. Antypatterny

| # | Antypattern ❌ | Fix ✅ | Ruff |
|---|---------------|-------|------|
| 1 | `print("debug:", x)` | `logger.debug("x: {val}", val=x)` | `T201` |
| 2 | `logger.info(f"x: {x}")` | `logger.info("x: {val}", val=x)` | — |
| 3 | `logger.error("Error")` w except | `logger.exception("Error")` | `TRY400` |
| 4 | `logger.exception(f"{exc}")` | `logger.exception("Description")` | `TRY401` |
| 5 | `traceback.format_exc()` w logu | `logger.exception()` (auto) | — |
| 6 | Logowanie sekretów | `SecretStr` + masking | `S105`/`S106` |
| 7 | `logging.getLogger()` z loguru | `from loguru import logger` | `LOG015` |
| 8 | Wiele logów na jedno zdarzenie | Jeden log z kontekstem | — |
| 9 | Brak `enqueue=True` w produkcji | `logger.add(..., enqueue=True)` | — |
| 10 | `logger.add()` w każdym module | Setup RAZ w entrypoint | — |

---

## 8. Egzekucja ruff

### 8.1 Reguły

| Ruff | Nazwa | Co łapie |
|------|-------|----------|
| `T201` | print-found | `print()` → logger |
| `T203` | pprint-found | `pprint()` → logger z `!r` |
| `G001` | logging-string-format | `logger.info("x: {}".format(x))` (stdlib) |
| `G002` | logging-percent-format | `logger.info("x: %s", x)` (stdlib) |
| `G003` | logging-string-concat | `logger.info("x: " + str(x))` (stdlib) |
| `G004` | logging-f-string | `logger.info(f"x: {x}")` (stdlib) |
| `LOG015` | root-logger-call | `logging.info()` zamiast named logger |
| `TRY400` | error-instead-of-exception | `logger.error()` w except → `logger.exception()` |
| `TRY401` | verbose-log-message | `logger.exception(f"{exc}")` redundantne |

> ⚠️ **UWAGA:** `G001`–`G004` dotyczą **stdlib `logging`**, nie loguru. Loguru natywnie używa `{}` placeholders. Ale jeśli mieszasz stdlib z loguru (via InterceptHandler), te reguły pomagają wyłapać błędy w stdlib callers.

---
## Źródła

> - [loguru docs](https://loguru.readthedocs.io/) — API reference, configuration
> - [loguru GitHub](https://github.com/Delgan/loguru) — examples, recipes
> - [Ruff T20 rules](https://docs.astral.sh/ruff/rules/#flake8-print-t20) — print/pprint ban
> - [Ruff G rules](https://docs.astral.sh/ruff/rules/#flake8-logging-format-g) — logging format
> - [Ruff TRY rules](https://docs.astral.sh/ruff/rules/#tryceratops-try) — exception logging patterns
> - [12-Factor App — Logs](https://12factor.net/logs) — logs as event streams
> - `08-error-handling.md` — exception hierarchy, try-except patterns
> - `10-config-data.md` — SecretStr, config security
