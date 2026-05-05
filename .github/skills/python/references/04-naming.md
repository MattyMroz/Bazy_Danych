# 04 — Naming Conventions

> **Cel:** Jednoznaczne reguły nazewnictwa dla każdego elementu kodu Python.
> **Scope:** Uniwersalny — Python ≥3.10, PEP 8, ruff enforcement.

---

## Spis treści

1. [Tabela konwencji](#1-tabela-konwencji)
2. [snake_case — zmienne, funkcje, moduły](#2-snake_case--zmienne-funkcje-moduły)
3. [PascalCase — klasy i typy](#3-pascalcase--klasy-i-typy)
4. [SCREAMING_SNAKE — stałe](#4-screaming_snake--stałe)
5. [Prefiks `_` — prywatne API](#5-prefiks-_--prywatne-api)
6. [Akronimy i skróty](#6-akronimy-i-skróty)
7. [Magic numbers → named constants](#7-magic-numbers--named-constants)
8. [Nazwy w kontekście typów](#8-nazwy-w-kontekście-typów)
9. [Parametry i argumenty](#9-parametry-i-argumenty)
10. [Nazwy plików i pakietów](#10-nazwy-plików-i-pakietów)
11. [Anti-patterns](#11-anti-patterns)
12. [ruff enforcement](#12-ruff-enforcement)


## 📋 Quick Reference (ściąga)

| Element | Konwencja | Przykład |
|---------|-----------|---------|
| Zmienne, funkcje, moduły | `snake_case` | `page_count`, `find_records` |
| Klasy, TypeVar, TypeAlias | `PascalCase` | `UserService`, `T` |
| Stałe | `SCREAMING_SNAKE` + `Final` | `MAX_DIM: Final[int] = 4096` |
| Prywatne | `_prefix` | `_load_model()` |
| Akronimy w PascalCase | First letter only | `OcrEngine`, `TtsService` |
| Bool params | keyword-only (`*`) | `def f(*, strict: bool)` |
| Magic numbers | Named constant | `MAX_DIM` zamiast `4096` |
| Pliki | `snake_case.py` | `panel_detector.py` |
| Testy | `test_*.py` | `test_detection.py` |
| Predykaty | `is_`/`has_`/`can_` | `is_valid()`, `has_gpu()` |

---

## 1. Tabela konwencji

| Element | Konwencja | Przykład |
|---------|-----------|---------|
| Zmienne | `snake_case` | `page_count`, `is_valid` |
| Funkcje / metody | `snake_case` | `load_config()`, `get_user()` |
| Klasy | `PascalCase` | `UserService`, `TaskQueue` |
| Stałe (module-level) | `SCREAMING_SNAKE` | `MAX_IMAGE_SIZE`, `DEFAULT_TIMEOUT` |
| Moduły / pliki `.py` | `snake_case` | `panel_detector.py`, `config.py` |
| Pakiety / foldery | `snake_case` (krótkie, bez `_` jeśli się da) | `services/`, `utils/` |
| TypeVar | `PascalCase` (krótkie, 1-3 znaki) | `T`, `_R`, `_KT`, `_VT` |
| TypeAlias | `PascalCase` | `TaskHandler`, `JsonDict` |
| NamedTuple | `PascalCase` | `TimingInfo`, `Point2D` |
| Protocol | `PascalCase` + `-able`/`-ible` jeśli pasuje | `Processable`, `Serializable` |
| Enum | `PascalCase` klasa, `SCREAMING_SNAKE` members | `Color.RED`, `Status.IN_PROGRESS` |
| Prywatne | prefix `_` | `_load_model()`, `_cache` |
| Name-mangling | prefix `__` (rzadko) | `__internal` → `_ClassName__internal` |
| Dunder / magic | `__name__` | `__init__`, `__repr__`, `__enter__` |

---

## 2. snake_case — zmienne, funkcje, moduły

### Zmienne

```python
# ✅ Opisowe, snake_case
user_count = 42
is_active = True
detection_result = detect(image)
raw_pixels: np.ndarray = load_image(path)

# ❌ Krótkie/niejasne
uc = 42
x = detect(image)
res = detect(image)  # co to za "res"?
```

### Funkcje

```python
# ✅ Czasownik + rzeczownik — mówi CO robi
def find_records(data: np.ndarray) -> list[BBox]: ...
def load_config(path: Path) -> Config: ...
def is_valid_image(path: Path) -> bool: ...  # predykaty: is_/has_/can_/should_

# ❌ Niejasne / za ogólne
def process(data): ...   # CO processuje? JAK?
def do_stuff(): ...      # ???
def handle(x): ...       # handle czego?
```

### Reguły nazw funkcji

| Pattern | Kiedy | Przykład |
|---------|-------|---------|
| `verb_noun` | Domyślny | `find_records`, `load_config` |
| `is_`/`has_`/`can_` | Predykat → `bool` | `is_valid`, `has_gpu`, `can_retry` |
| `get_` | Accessor (może rzucić) | `get_user(id)` |
| `find_` | Szukanie (może zwrócić `None`) | `find_user(name) -> User \| None` |
| `create_`/`build_` | Fabryka | `create_session()`, `build_pipeline()` |
| `to_` | Konwersja | `to_json()`, `to_dict()` |
| `from_` | Classmethod constructor | `Config.from_file(path)` |

---

## 3. PascalCase — klasy i typy

```python
# ✅ PascalCase — każde słowo z dużej
class UserService: ...
class TaskQueue: ...
class ImageProcessor: ...

# ❌ snake_case / mieszane
class user_service: ...
class taskQueue: ...
```

### Nazwy klas — kiedy jaki suffix

| Suffix | Kiedy | Przykład |
|--------|-------|---------|
| `Service` | Logika biznesowa | `PaymentService` |
| `Config` | Konfiguracja | `AppConfig` |
| `Result` | Wynik operacji | `SearchResult` |
| `Error` / `Exception` | Wyjątek | `ModelNotFoundError` |
| `Manager` | Zarządca zasobów | `ModelManager` |
| `Factory` | Tworzenie obiektów | `PipelineFactory` |
| `Handler` | Obsługa zdarzeń/requestów | `WebhookHandler` |
| `Mixin` | Mixin class | `LoggingMixin` |
| brak | Encja / model domenowy | `User`, `Image`, `Panel` |

---

## 4. SCREAMING_SNAKE — stałe

```python
from typing import Final

# ✅ Module-level, SCREAMING_SNAKE, kwalifikowane typem Final
MAX_IMAGE_SIZE: Final[int] = 4096
DEFAULT_TIMEOUT: Final[float] = 30.0
SUPPORTED_FORMATS: Final[frozenset[str]] = frozenset({".png", ".jpg", ".webp"})

# ❌ Stała bez Final
MAX_SIZE = 4096  # nic nie mówi czy to stała czy zmienna

# ❌ Stała w snake_case
max_image_size = 4096  # wygląda jak zmienna
```

### Co jest stałą

| Stała ✅ | Nie stała ❌ |
|---------|------------|
| Wartości konfiguracyjne | Zmienne akumulujące coś w pętli |
| Limity, timeouty | Wyniki obliczeń zmieniające się w runtime |
| Zbiory dozwolonych wartości | Mutable collections modyfikowane po starcie |
| Wartości domyślne | — |

> 💡 `Final` + `SCREAMING_SNAKE` = sygnał dla czytelnika I type checkera. mypy wyłapie próby nadpisania.

---

## 5. Prefiks `_` — prywatne API

```python
# ✅ Prefix _ = wewnętrzne, nie eksportuj
class UserService:
    _model: torch.nn.Module              # prywatny atrybut
    _cache: dict[str, Any]               # prywatny atrybut

    def detect(self, image: np.ndarray) -> list[BBox]:  # publiczne
        return self._run_inference(image)

    def _run_inference(self, image: np.ndarray) -> list[BBox]:  # prywatne
        ...

# ✅ Prywatne moduły
_constants.py    # helper wewnętrzny, nie w __all__
_compat.py       # warstwa kompatybilności
```

### `_` vs `__`

| Prefix | Znaczenie | Kiedy |
|--------|-----------|-------|
| `_name` | Konwencja "prywatne" | **Domyślny** sposób oznaczania wewnętrznych API |
| `__name` | Name mangling (`_ClassName__name`) | **Rzadko** — gdy podklasy mogą nadpisać atrybut |
| `name_` | Unikanie konfliktu z keyword | `type_`, `class_`, `id_` |

> 💡 `_` w Pythonie to **konwencja**, nie enforcement. Narzędzia (ruff, mypy, IDE) respektują konwencję i ostrzegają przy próbie użycia prywatnego API z zewnątrz.

---

## 6. Akronimy i skróty

### ⛔ HARD RULE: Akronimy w PascalCase — capitalize first only

```python
# ✅ Pierwsza litera duża, reszta mała
class OcrEngine: ...
class TtsService: ...
class HttpClient: ...
class JsonParser: ...

# ❌ Cały akronim dużymi
class OCREngine: ...   # "OCR" wygląda jak 3 osobne słowa
class TTSService: ...  # "TTS" — gdzie kończy się akronim?
class HTTPClient: ...  # Java-style, nie Python
```

**Dlaczego:** `OCREngine` → ciężko parsować granicę słowną. `OcrEngine` → od razu widać: `Ocr` + `Engine`.

### Reguła: Akronimy >3 liter — capitalize FIRST only

```python
# ✅ HTTPS (4+ liter) → capitalize first
class HttpsClient: ...
class HttpServer: ...
class JsonParser: ...
class UrlBuilder: ...

# ❌ Cały akronim dużymi — trudno parsować granicę
class HTTPSClient: ...  # gdzie kończy się HTTPS a starts Client?
class JSONParser: ...
```

### Popularne akronimy

| Skrót | PascalCase | snake_case |
|-------|-----------|------------|
| OCR | `Ocr` | `ocr` |
| TTS | `Tts` | `tts` |
| HTTP | `Http` | `http` |
| JSON | `Json` | `json` |
| API | `Api` | `api` |
| URL | `Url` | `url` |
| GPU | `Gpu` | `gpu` |
| AI | `Ai` | `ai` |

---

## 7. Magic numbers → named constants

### ⛔ HARD RULE: Żadnych magic numbers

```python
# ❌ Magic numbers — co to znaczy?
if image.width > 4096:
    image = resize(image, 4096)
timeout = 30.0

# ✅ Named constants — intencja jasna
MAX_DIM: Final[int] = 4096
DEFAULT_TIMEOUT: Final[float] = 30.0

if image.width > MAX_DIM:
    image = resize(image, MAX_DIM)
timeout = DEFAULT_TIMEOUT
```

### Wyjątki — te liczby SĄ OK inline

| Wartość | Dlaczego OK |
|---------|-------------|
| `0`, `1`, `-1` | Indeksy, inicjalizacja, inkrementacja — semantic meaning jasna |
| `2` (dzielenie na pół) | Oczywiste z kontekstu, idiom Pythona |
| `100` (procenty) | `progress / total * 100` — matematyka |
| `""`, `[]`, `{}` | Puste kolekcje |
| `None` | Brak wartości — semantyka wbudowana |

Wszystko inne → extract do `Final` constant.

### Practice: Co jest magic number?

```python
# ❌ MAGIC — skąd 0.85?
if confidence > 0.85:
    accept()

# ✅ CONST — domain-specific threshold
CONFIDENCE_THRESHOLD: Final[float] = 0.85
if confidence > CONFIDENCE_THRESHOLD:
    accept()

# ✅ OK INLINE — idiom Pythona
first, *rest, last = items  # 1 i -1 są semantyczne
x = x * 2  # doubling — jasne
```

---

## 8. Nazwy w kontekście typów

```python
from typing import TypeVar, ParamSpec, TypeAlias, Protocol

# TypeVar — krótkie, PascalCase, prefix _ jeśli prywatny
T = TypeVar("T")
_R = TypeVar("_R")                          # prywatny
_KT = TypeVar("_KT")                        # key type
_VT = TypeVar("_VT")                        # value type

# ParamSpec
_P = ParamSpec("_P")

# TypeAlias
TaskHandler: TypeAlias = Callable[[Task], Awaitable[TaskResult]]
JsonDict: TypeAlias = dict[str, Any]

# Protocol — "-able" suffix gdy opisuje capability
class Processable(Protocol):
    def process(self) -> None: ...

class Serializable(Protocol):
    def to_dict(self) -> dict[str, Any]: ...

# Enum — PascalCase klasa, SCREAMING members
class TaskStatus(str, Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
```

> 💡 TypeVar `T` jest ok globalnie. Specificzne TypeVars (`_R`, `_KT`) z `_` — bo prywatne w module.

---

## 9. Parametry i argumenty

### Boolean parameters — ZAWSZE keyword-only (Boolean Trap)

**⛔ Boolean Trap:** Positional boolean argument → niejasne znaczenie przy wywołaniu.

```python
# ❌ TRAP — co False i True oznaczają?
load_model(path, False, True)  # Wymaga czytania dokumentacji

# ✅ SAFE — keyword-only → jawne znaczenie
def load_model(path: Path, *, strict: bool = True, gpu: bool = False) -> Model: ...
load_model(path, strict=False, gpu=True)  # JASNE
```

**Alternatywa — Enum zamiast bool** (gdy >2 warianty):

```python
class LoadMode(str, Enum):
    STRICT = "strict"
    LENIENT = "lenient"

def load_model(path: Path, mode: LoadMode = LoadMode.STRICT) -> Model: ...
load_model(path, mode=LoadMode.LENIENT)  # Jeszcze bardziej explicit
```

### `self` / `cls`

```python
class Service:
    def method(self) -> None: ...          # ✅ self — instance methods
    @classmethod
    def create(cls) -> Self: ...           # ✅ cls — classmethods
    @staticmethod
    def validate(data: dict) -> bool: ...  # ✅ brak self/cls — staticmethod
```

### `*args` / `**kwargs` — z typem jeśli możliwesz

```python
# ✅ Typed
def log(*messages: str, level: str = "INFO") -> None: ...
def create(**fields: Any) -> Model: ...

# ✅ Gdy delegujesz — ParamSpec lepszy niż *args/**kwargs
```

---

## 10. Nazwy plików i pakietów

### Pliki `.py`

```
# ✅ snake_case, krótkie, opisowe
panel_detector.py
config.py
test_detection.py
_helpers.py          # prywatny helper

# ❌
panelDetector.py     # camelCase
Panel-Detector.py    # kebab-case
utils2.py            # numerka zamiast nazwy
helpers_v3_final.py  # co...
```

### Pakiety (foldery)

```
# ✅ snake_case, krótkie nazwy
services/
utils/
models/
api/
config/

# ❌
ServiceLayer/        # PascalCase
my-utils/            # kebab-case (nie działa jako import)
```

### Test files

```
# ✅ Prefix test_ (pytest discovery)
test_detection.py
test_config.py

# ❌
detection_test.py    # pytest domyślnie szuka test_*
tests.py             # zbyt ogólne
```

---

## 11. Anti-patterns

| ❌ Anti-pattern | ✅ Zamiast tego | Dlaczego |
|----------------|----------------|----------|
| `data`, `info`, `stuff`, `thing` | Opisowa nazwa: `user_profile`, `panel_bbox` | Zero informacji |
| `temp`, `tmp`, `x`, `val` | Pełna nazwa: `raw_image`, `retry_count` | Niezrozumiałe dla kogoś innego |
| `list1`, `list2` | `source_images`, `target_images` | Numerki nic nie mówią |
| `myFunction`, `MyVariable` | `my_function`, `my_variable` | Python = snake_case |
| `doProcess` | `process_image` | Java naming w Python |
| `Manager` / `Handler` bez kontekstu | Precyzyjnie: `ConnectionPool`, `EventDispatcher` | "Manager" to najczęstszy God Object |
| `utils.py` >300 linii | Rozbij na `string_utils.py`, `image_utils.py` | Mega-utils = śmietnik |
| Skróty niejasne: `proc`, `cfg`, `mgr` | Pełne: `process`, `config`, `manager` | Nie oszczędzasz nic, tracisz czytelność |

---

## 12. ruff enforcement

| Rule | Co wymusza | Auto-fix? |
|------|-----------|-----------|
| `N801` | Klasa nie w PascalCase | ⚠️ Manual |
| `N802` | Funkcja nie w snake_case | ⚠️ Manual |
| `N803` | Argument nie w snake_case | ⚠️ Manual |
| `N806` | Zmienna w funkcji nie w snake_case | ⚠️ Manual |
| `N811` | Stała importowana pod non-SCREAMING alias | ⚠️ Manual |
| `N815` | mixedCase zmienna w class body | ⚠️ Manual |
| `N816` | mixedCase zmienna na module level | ⚠️ Manual |

```toml
# pyproject.toml
[tool.ruff.lint]
select = [
    "N",    # pep8-naming
]
```

> 💡 ruff `N` rules NIE auto-fixują — naming wymaga ludzkiej decyzji. Ale łapią wszystko co narusza konwencje.

---
## Źródła

- [PEP 8 — Naming Conventions](https://peps.python.org/pep-0008/#naming-conventions)
- [PEP 8 — Descriptive: Naming Styles](https://peps.python.org/pep-0008/#descriptive-naming-styles)
- [Google Python Style Guide — Naming](https://google.github.io/styleguide/pyguide.html#316-naming)
- [ruff pep8-naming (N)](https://docs.astral.sh/ruff/rules/#pep8-naming-n)
