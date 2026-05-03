# 05 — Code Patterns & Pythonic Idioms

> **Cel:** Idiomatyczny Python ≥3.10 — decyzje kiedy użyć jakiego wzorca, nie tylko „rób X". Tabele decyzyjne, ruff rules, ✅/❌ snippety.
> **Scope:** Uniwersalny — Python ≥3.10, `from __future__ import annotations`, ruff 120 chars, loguru, pathlib.
> **NIE duplikuje:** error handling (→08), design patterns (→09), function/class design (→06, 07), type hints (→02).

---

## Spis treści

1. [Pathlib — ZAWSZE](#1-pathlib--zawsze)
2. [f-strings & formatowanie tekstu](#2-f-strings--formatowanie-tekstu)
3. [Comprehensions & generatory](#3-comprehensions--generatory)
4. [Early return & guard clauses](#4-early-return--guard-clauses)
5. [Walrus operator (`:=`)](#5-walrus-operator-)
6. [match/case (Python 3.10+)](#6-matchcase-python-310)
7. [Structured data — dataclass vs pydantic](#7-structured-data--dataclass-vs-pydantic)
8. [Context managers](#8-context-managers)
9. [Unpacking & destructuring](#9-unpacking--destructuring)
10. [Itertools & functools](#10-itertools--functools)
11. [Antypatterny](#11-antypatterny)
12. [Egzekucja ruff](#12-egzekucja-ruff)


## 📋 Quick Reference (ściąga)

| # | Reguła |
|---|--------|
| 1 | **pathlib.Path ZAWSZE** — `os.path` to legacy, ruff `PTH` wymusza |
| 2 | **f-strings** do interpolacji — `%` i `.format()` to legacy (`UP031`/`UP032`) |
| 3 | **loguru `{}`** do logowania — NIE f-string (`G004`), nie `%s` |
| 4 | **Comprehensions** gdy proste (1-2 for) — loop gdy side effects lub ≥3 for |
| 5 | **Generator expressions** dla lazy, jednorazowe iterowanie — `sum(x for x in ...)` |
| 6 | **Early return** + guard clauses — max 2 poziomy zagnieżdżeń |
| 7 | **match/case** przy ≥3 warunki na tej samej zmiennej lub destructuring |
| 8 | **dataclass** = internal DTO (frozen, slots) — **pydantic** = API + walidacja |
| 9 | **Context managers** na KAŻDY zasób (pliki, połączenia, locki) |
| 10 | **Walrus `:=`** — regex match, while read, filter+capture — NIE sprytne onelinery |
| 11 | **Unpacking** `x, y = point` > `point[0]`, `point[1]` |
| 12 | **`@lru_cache`** zamiast ręcznego dict cache |
| 13 | **Mutable defaults = BUG** — `def f(x=None)` + factory, NIGDY `def f(x=[])` |
| 14 | **`isinstance(x, T)`** > `type(x) == T` — respektuj inheritance |

---

## 1. Pathlib — ZAWSZE

### 1.1 Reguła główna

> 🔒 **HARD RULE:** Użyj `pathlib.Path` wszędzie gdzie pracujesz ze ścieżkami. `os.path.*` to legacy.

| Operacja | pathlib ✅ | os.path ❌ | Ruff |
|----------|-----------|-----------|------|
| Łączenie | `base / "sub" / "file.txt"` | `os.path.join(base, "sub", "file.txt")` | `PTH118` |
| Istnienie | `path.exists()` | `os.path.exists(path)` | `PTH110` |
| Odczyt | `path.read_text()` | `open(path).read()` | `PTH123` |
| Zapis | `path.write_text(data)` | `open(path, "w").write(data)` | `PTH123` |
| Katalog | `path.mkdir(parents=True, exist_ok=True)` | `os.makedirs(path, exist_ok=True)` | `PTH103` |
| Rozszerzenie | `path.suffix` | `os.path.splitext(path)[1]` | `PTH122` |
| Nazwa | `path.stem`, `path.name` | `os.path.basename(path)` | `PTH119` |
| Absolutna | `path.resolve()` | `os.path.abspath(path)` | `PTH100` |
| Glob | `path.glob("*.png")` | `glob.glob("dir/*.png")` | `PTH207` |
| Iteracja | `path.iterdir()` | `os.listdir(path)` | `PTH208` |
| Usuwanie | `path.unlink(missing_ok=True)` | `os.remove(path)` | `PTH107` |

### 1.2 Snippety

```python
from __future__ import annotations
from pathlib import Path


# ✅ Pełna ścieżka z pathlib
def load_config(config_dir: Path) -> dict[str, str]:
    config_path = config_dir / "settings.toml"
    if not config_path.exists():
        msg = f"Config not found: {config_path}"
        raise FileNotFoundError(msg)
    return parse_toml(config_path.read_text(encoding="utf-8"))


# ✅ Tworzenie drzewa katalogów
def ensure_output_dir(base: Path, run_id: str) -> Path:
    output_dir = base / "runs" / run_id / "artifacts"
    output_dir.mkdir(parents=True, exist_ok=True)
    return output_dir


# ✅ Glob z filtrem
def find_images(directory: Path) -> list[Path]:
    return sorted(
        p for p in directory.rglob("*") if p.suffix.lower() in {".png", ".jpg", ".webp"}
    )
```

```python
# ❌ PTH118: os.path.join
config = os.path.join(base, "config", "settings.toml")

# ❌ PTH110: os.path.exists
if os.path.exists(config):
    ...

# ❌ String-based path manipulation
output = str(base) + "/output/" + filename  # fragile!
```

### 1.3 Konwersja `str ↔ Path`

| Sytuacja | Wzorzec |
|----------|---------|
| API przyjmuje `str` | `func(str(path))` |
| API zwraca `str` | `Path(returned_string)` |
| Parametr akceptuje oba | `path: Path \| str` → `path = Path(path)` na wejściu |
| Logowanie / display | f-string automatycznie woła `__str__` |

```python
# ✅ Normalizacja na wejściu
def process_file(path: Path | str) -> bytes:
    path = Path(path)  # Normalizuj raz, na wejściu
    return path.read_bytes()
```

> **Ruff:** `PTH` (flake8-use-pathlib) — pełny zestaw rules wymuszający pathlib.
> **Wyjątek:** ML code i external libraries mogą wymagać `str` (np. `torch.load(str(path))`).

---

## 2. f-strings & formatowanie tekstu

### 2.1 Tabela decyzyjna

| Sytuacja | Użyj | Dlaczego |
|----------|------|----------|
| Interpolacja zmiennych | `f"Hello {name}"` | Najczytelniejsze, najszybsze |
| Logging (loguru) | `logger.info("x: {val}", val=val)` | Lazy eval — `{}` NIE f-string! |
| Logging (stdlib) | `logging.info("x: %s", val)` | Lazy eval — `%s` format |
| Template z wieloma wariantami | `str.format()` z named placeholders | Reusable template |
| Bytes / binary | `b"header"` | f-string nie działa z bytes |
| Regex | `r"\d+"` | f-string escaping jest confusing |

### 2.2 Snippety

```python
# ✅ f-string — interpolacja
name = "Alice"
greeting = f"Hello, {name}!"

# ✅ f-string — wyrażenia i formatowanie
size_mb = 1536.789
formatted = f"Size: {size_mb:.1f} MB"          # "Size: 1536.8 MB"
padded = f"Step {step:>3d}/{total:>3d}"         # "Step   1/100"
percentage = f"Progress: {done / total:.1%}"     # "Progress: 73.2%"

# ✅ f-string — conditional expression
label = f"{'enabled' if active else 'disabled'}"

# ✅ Multiline — implicit concatenation (NIE f-string z \n)
message = (
    f"User {user_id} created successfully.\n"
    f"Email: {email}\n"
    f"Role: {role}"
)
```

```python
# ❌ UP031: %-formatting (legacy)
"Hello %s" % name

# ❌ UP032: .format() gdy f-string wystarczy
"Hello {}".format(name)

# ❌ f-string w logging (eager eval + ruff G004)
logger.info(f"Processing {item}")  # Ewaluowane ZAWSZE, nawet gdy level=WARNING

# ❌ Nested f-string (nieczytelne)
f"{f'{value:.2f}':>10}"  # Użyj zmiennej pośredniej
```

### 2.3 Format spec cheatsheet

| Spec | Wynik | Przykład |
|------|-------|---------|
| `:.2f` | 2 decimals | `f"{3.14159:.2f}"` → `"3.14"` |
| `:.1%` | Percentage 1 decimal | `f"{0.732:.1%}"` → `"73.2%"` |
| `:>10` | Right-align 10 chars | `f"{'hi':>10}"` → `"        hi"` |
| `:<10` | Left-align 10 chars | `f"{'hi':<10}"` → `"hi        "` |
| `:^10` | Center 10 chars | `f"{'hi':^10}"` → `"    hi    "` |
| `:,` | Thousands separator | `f"{1234567:,}"` → `"1,234,567"` |
| `:_` | Underscore separator | `f"{1234567:_}"` → `"1_234_567"` |
| `:#x` | Hex with prefix | `f"{255:#x}"` → `"0xff"` |
| `:#b` | Binary with prefix | `f"{10:#b}"` → `"0b1010"` |
| `!r` | repr() | `f"{path!r}"` → `"PosixPath('.')"` |
| `=` | Debug format (Python 3.8+) | `f"{value=}"` → `"value=42"` |

> **Ruff:** `UP031` (printf-string-formatting), `UP032` (format-call), `G004` (logging-f-string).

---

## 3. Comprehensions & generatory

### 3.1 Tabela decyzyjna

| Sytuacja | Użyj | Dlaczego |
|----------|------|----------|
| Transformacja 1:1 | List comprehension | `[f(x) for x in items]` |
| Filtrowanie | List comp z `if` | `[x for x in items if x > 0]` |
| Duży dataset / lazy | Generator expression | `(f(x) for x in items)` — zero pamięci |
| Unikalne wartości | Set comprehension | `{x.lower() for x in words}` |
| Mapping | Dict comprehension | `{k: v for k, v in pairs}` |
| Side effects | `for` loop | Comprehension to **wyrażenie**, nie statement |
| >2 klauzule `for` | `for` loop | Comprehensions >2 `for` są nieczytelne |
| Logika warunkowa | `for` loop | `if/else` w comprehension = hard to read |

### 3.2 Snippety

```python
# ✅ List comprehension — proste
names = [user.name for user in users]
valid = [item for item in items if item.is_valid()]

# ✅ Dict comprehension
config_map = {k: v for k, v in raw_config.items() if v is not None}

# ✅ Set comprehension
unique_extensions = {path.suffix.lower() for path in directory.iterdir()}

# ✅ Generator expression — lazy, memory-efficient
total = sum(item.price for item in cart)
first_match = next((x for x in items if x.active), None)

# ✅ Nested comprehension — MAX 2 for clauses
pairs = [(x, y) for x in range(3) for y in range(3)]
```

```python
# ❌ C400: list() z generatorem — użyj list comp
list(x for x in items)  # → [x for x in items]

# ❌ C401: set() z generatorem — użyj set comp
set(x for x in items)  # → {x for x in items}

# ❌ SIM118: key in dict.keys() — zbędne .keys()
if key in my_dict.keys():  # → if key in my_dict:

# ❌ C416: unnecessary comprehension — zbędna transformacja
[x for x in items]  # → list(items)

# ❌ Za złożone — >2 for clauses, nieczytelne
result = [f(x, y, z) for x in xs for y in ys for z in zs if p(x, y, z)]
# → Rozbij na for loop
```

### 3.3 Generatory — `yield` i `yield from`

```python
from collections.abc import Iterator


# ✅ Generator function — lazy sequence
def read_lines(path: Path) -> Iterator[str]:
    with open(path) as f:
        for line in f:
            yield line.strip()


# ✅ yield from — delegacja do sub-generatora
def walk_tree(node: TreeNode) -> Iterator[TreeNode]:
    yield node
    for child in node.children:
        yield from walk_tree(child)


# ✅ Generator pipeline — composable
def pipeline(items: Iterator[str]) -> Iterator[str]:
    items = (item.strip() for item in items)
    items = (item for item in items if item)
    items = (item.upper() for item in items)
    return items
```

```python
# ❌ Materializacja całego generatora niepotrzebnie
all_lines = list(read_lines(huge_file))  # OOM dla dużych plików!
for line in all_lines:  # → for line in read_lines(huge_file):
    process(line)
```

### 3.4 Kiedy `list()` vs generator

| Potrzebujesz… | Użyj |
|---------------|------|
| `len()`, indeksowanie, wielokrotne iterowanie | `list()` |
| Jednorazowe iterowanie, pipeline | Generator |
| Przekazanie do `sum()`, `any()`, `all()`, `min()`, `max()` | Generator (konsumują lazy) |
| Debugowanie (chcesz zobaczyć zawartość) | `list()` tymczasowo |

> **Ruff:** `C4` (flake8-comprehensions), `SIM118` (in-dict-keys), `PERF401` (manual-list-append → comprehension).

---

## 4. Early return & guard clauses

### 4.1 Reguła

> 🔒 **HARD RULE:** Waliduj na wejściu → return/raise wcześnie → happy path na dole, bez zagnieżdżeń.

### 4.2 Snippety

```python
# ✅ Guard clauses — flat, czytelne
def process_order(order: Order) -> Receipt:
    if not order.items:
        msg = "Order has no items"
        raise ValueError(msg)
    if order.total <= 0:
        msg = "Order total must be positive"
        raise ValueError(msg)
    if order.is_cancelled:
        return Receipt(status="cancelled")

    # Happy path — zero zagnieżdżeń
    payment = charge(order)
    return Receipt(status="paid", payment=payment)
```

```python
# ❌ Nested if/else — piramida zagłady
def process_order(order: Order) -> Receipt:
    if order.items:
        if order.total > 0:
            if not order.is_cancelled:
                payment = charge(order)
                return Receipt(status="paid", payment=payment)
            else:
                return Receipt(status="cancelled")
        else:
            raise ValueError("Order total must be positive")
    else:
        raise ValueError("Order has no items")
```

### 4.3 Tabela decyzyjna

| Sytuacja | Wzorzec | Przykład |
|----------|---------|---------|
| Walidacja parametru | Guard clause + raise | `if not x: raise ValueError(msg)` |
| Warunek braku danych | Guard clause + return | `if not items: return []` |
| Jeden warunek binarne | Ternary | `status = "ok" if valid else "fail"` |
| Wiele warunków, różne returny | Guard clauses (early return) | Każdy case → osobny `if: return` |
| Złożona logika decyzyjna | `match/case` (→ §6) | Structural pattern matching |

### 4.4 Ternary — kiedy TAK, kiedy NIE

```python
# ✅ Prosty ternary — jedna linia, czytelne
label = "active" if user.is_active else "inactive"
default = config.get("timeout") or DEFAULT_TIMEOUT

# ❌ Nested ternary — nieczytelne
x = a if cond1 else b if cond2 else c  # Użyj if/elif/else
```

> **Ruff:** `RET504` (unnecessary-assign → return bezpośrednio), `RET505`/`RET506` (unnecessary-else po return/raise), `SIM102` (collapsible-if), `SIM108` (use-ternary-instead).

---

## 5. Walrus operator (`:=`)

### 5.1 Kiedy używać

| Sytuacja | `:=` ✅ | Bez `:=` |
|----------|--------|----------|
| `if` + użycie wyniku | `if (m := re.match(pat, s)):` | `m = re.match(...); if m:` |
| `while` + read | `while (line := f.readline()):` | `line = f.readline(); while line:` |
| `any()`/`next()` + capture | `if (found := next((x for x ...), None)):` | `found = next(...); if found:` |
| Complex expression | ❌ NIE — czytelność > spryt | Zmienna pośrednia |

### 5.2 Snippety

```python
import re

# ✅ Regex match + capture
if m := re.match(r"(?P<key>\w+)=(?P<val>.+)", line):
    config[m.group("key")] = m.group("val")

# ✅ While z readline
with open(path) as f:
    while line := f.readline():
        process(line.strip())

# ✅ Filter + capture w comprehension
valid_results = [
    clean
    for raw in items
    if (clean := validate(raw)) is not None
]

# ✅ Validation pattern — walrus w if statement
if (config := load_config_or_none()) is not None:
    apply_settings(config)
else:
    use_defaults()

# ✅ Reduce intermediate variable
if (n := len(items)) > MAX_BATCH:
    logger.warning("Batch too large: {n}", n=n)
```

```python
# ❌ Walrus w prostym assignment — niepotrzebne
x := 42  # SyntaxError! := działa TYLKO w wyrażeniach

# ❌ Zbyt sprytne — czytelność ważniejsza
result = [y := f(x), y**2, y**3]  # Użyj zwykłej zmiennej
```

> **PEP:** [PEP 572](https://peps.python.org/pep-0572/) — Assignment Expressions.

---

## 6. match/case (Python 3.10+)

### 6.1 Tabela decyzyjma: match/case vs if/elif

| Sytuacja | Użyj |
|----------|------|
| 1-2 warunki | `if/elif` |
| ≥3 warunki na tej samej zmiennej | `match/case` |
| Destructuring (tuple, dataclass, dict) | `match/case` — jedyne narzędzie |
| Type narrowing | `match/case` z `case str():` |
| Enum dispatch | `match/case` |
| Fallback/default | `case _:` (wildcard) |

### 6.2 Snippety

```python
from __future__ import annotations
from enum import StrEnum


class Status(StrEnum):
    PENDING = "pending"
    ACTIVE = "active"
    ARCHIVED = "archived"


# ✅ Enum dispatch
def handle_status(status: Status) -> str:
    match status:
        case Status.PENDING:
            return "Waiting for approval"
        case Status.ACTIVE:
            return "Currently active"
        case Status.ARCHIVED:
            return "No longer available"
        case _:
            msg = f"Unknown status: {status}"
            raise ValueError(msg)


# ✅ Structural pattern matching — destructuring
def handle_command(command: tuple[str, ...]) -> None:
    match command:
        case ("quit",):
            sys.exit(0)
        case ("move", x, y):
            move_to(int(x), int(y))
        case ("say", *words):
            print(" ".join(words))
        case _:
            logger.warning("Unknown command: {cmd}", cmd=command)


# ✅ Type narrowing
def process_value(value: str | int | list[str]) -> str:
    match value:
        case str():
            return value.upper()
        case int():
            return str(value)
        case list():
            return ", ".join(value)


# ✅ Dict pattern matching (partial)
def parse_event(event: dict[str, object]) -> None:
    match event:
        case {"type": "click", "x": int(x), "y": int(y)}:
            handle_click(x, y)
        case {"type": "keypress", "key": str(key)}:
            handle_key(key)
        case {"type": str(t)}:
            logger.debug("Unhandled event: {t}", t=t)


# ✅ Guard clause w case
def categorize(value: int) -> str:
    match value:
        case x if x < 0:
            return "negative"
        case 0:
            return "zero"
        case x if x <= 100:
            return "small"
        case _:
            return "large"
```

```python
# ❌ if/elif chain na tej samej zmiennej (≥3 warunki)
if status == Status.PENDING:
    ...
elif status == Status.ACTIVE:
    ...
elif status == Status.ARCHIVED:
    ...
else:
    ...
# → Użyj match/case

# ❌ Brak wildcard — match bez case _ może nie obsłużyć nowego wariantu
match status:
    case Status.ACTIVE:
        ...
    # Brak case _: → nowy enum member = cichy bug
```

> **PEP:** [PEP 634](https://peps.python.org/pep-0634/) — Structural Pattern Matching.
> **Ruff:** `UP` (pyupgrade) sugeruje match/case zamiast isinstance chain.

---

## 7. Structured data — dataclass vs pydantic

### 7.1 Tabela decyzyjna

| Kryterium | `@dataclass` | `pydantic.BaseModel` |
|-----------|-------------|---------------------|
| **Zależności** | stdlib (zero deps) | `pydantic` (extra dep) |
| **Walidacja** | ❌ Brak (ręczna w `__post_init__`) | ✅ Wbudowana, deklaratywna |
| **Serializacja** | ❌ Ręczna | ✅ `.model_dump()`, `.model_dump_json()` |
| **Mutability** | Domyślnie mutable, `frozen=True` optional | Domyślnie immutable |
| **Slots** | `slots=True` (3.10+) | Automatycznie |
| **Performance** | Szybsze tworzenie | Wolniejsze (walidacja) |
| **JSON Schema** | ❌ | ✅ `.model_json_schema()` |
| **Default factory** | `field(default_factory=list)` | `Field(default_factory=list)` |
| **Inheritance** | Standard Python | Pydantic-specific rules |

### 7.2 Kiedy co

| Sytuacja | Wybór | Dlaczego |
|----------|-------|----------|
| Prosta wartość bez walidacji | `@dataclass(frozen=True, slots=True)` | Lekkie, zero deps |
| Internal DTO / tuple z nazwami | `@dataclass` | Nie potrzeba `pydantic` |
| API request/response | `pydantic.BaseModel` | Automatyczna walidacja + serialization |
| Config z env vars | `pydantic_settings.BaseSettings` | `.env` support, type coercion |
| Database ORM model | SQLAlchemy + `MappedAsDataclass` | Lub Pydantic z `from_orm` |
| Dane z external API | `pydantic.BaseModel` | Walidacja niepewnych danych |

### 7.3 Snippety

```python
from __future__ import annotations
from dataclasses import dataclass, field


# ✅ Frozen dataclass — internal value object
@dataclass(frozen=True, slots=True)
class Point:
    x: float
    y: float

    def distance_to(self, other: Point) -> float:
        return ((self.x - other.x) ** 2 + (self.y - other.y) ** 2) ** 0.5


# ✅ Mutable dataclass z default factory
@dataclass(slots=True)
class BatchResult:
    processed: int = 0
    errors: list[str] = field(default_factory=list)
    metadata: dict[str, str] = field(default_factory=dict)
```

```python
from pydantic import BaseModel, Field, field_validator


# ✅ Pydantic — API model z walidacją
class CreateUserRequest(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    email: str
    age: int = Field(ge=0, le=150)

    @field_validator("email")
    @classmethod
    def validate_email(cls, v: str) -> str:
        if "@" not in v:
            msg = "Invalid email format"
            raise ValueError(msg)
        return v.lower()
```

```python
# ❌ Raw dict zamiast structured data
user = {"name": "Alice", "email": "alice@example.com", "age": 30}
# Brak autocompletion, brak walidacji, brak type safety
print(user["naem"])  # KeyError — typo! Dataclass/pydantic złapie to w IDE

# ❌ NamedTuple z mutacją (NamedTuple jest immutable)
from typing import NamedTuple

class Point(NamedTuple):
    x: float
    y: float

p = Point(1, 2)
p.x = 3  # AttributeError!  Użyj @dataclass jeśli potrzebujesz mutacji
```

### 7.4 `__post_init__` — walidacja w dataclass

```python
@dataclass(frozen=True, slots=True)
class TimeRange:
    start: float
    end: float

    def __post_init__(self) -> None:
        if self.start >= self.end:
            msg = f"start ({self.start}) must be < end ({self.end})"
            raise ValueError(msg)
```

> **Ruff:** `RUF009` (mutable-dataclass-default — `list` jako default zamiast `field(default_factory=list)`).

---

## 8. Context managers

### 8.1 Tabela decyzyjna

| Sytuacja | Użyj |
|----------|------|
| Pliki, połączenia, locki | `with` statement |
| Custom cleanup (sync) | `@contextmanager` z `try/finally` |
| Custom cleanup (async) | `@asynccontextmanager` |
| Wiele context managerów | Wiele `with` w jednym |
| Dynamiczna liczba | `contextlib.ExitStack()` |
| Suppress exception | `contextlib.suppress(X)` |

### 8.2 Snippety

```python
from __future__ import annotations
from contextlib import contextmanager, asynccontextmanager, suppress
from collections.abc import Iterator, AsyncIterator


# ✅ Custom sync context manager
@contextmanager
def timer(label: str) -> Iterator[None]:
    start = time.perf_counter_ns()
    try:
        yield
    finally:
        elapsed_ms = (time.perf_counter_ns() - start) / 1_000_000
        logger.info("{label}: {elapsed:.1f}ms", label=label, elapsed=elapsed_ms)


# ✅ Custom async context manager
@asynccontextmanager
async def managed_client(base_url: str) -> AsyncIterator[httpx.AsyncClient]:
    async with httpx.AsyncClient(base_url=base_url) as client:
        try:
            yield client
        finally:
            logger.debug("Client for {url} closed", url=base_url)


# ✅ Wiele context managerów — Python 3.10+ syntax
with (
    open(input_path) as src,
    open(output_path, "w") as dst,
):
    dst.write(src.read())


# ✅ ExitStack — dynamiczna liczba zasobów
from contextlib import ExitStack

def process_files(paths: list[Path]) -> list[str]:
    with ExitStack() as stack:
        files = [stack.enter_context(open(p)) for p in paths]
        return [f.read() for f in files]


# ✅ suppress — zamiast try/except/pass
with suppress(FileNotFoundError):
    path.unlink()
```

```python
# ❌ Brak context manager — resource leak
f = open(path)
data = f.read()
# f.close() zapomniany → resource leak!

# ❌ SIM105: try/except/pass zamiast suppress
try:
    os.remove(tmpfile)
except FileNotFoundError:
    pass
```

### 8.3 `__enter__`/`__exit__` — class-based

```python
# ✅ Class-based context manager — gdy potrzebujesz stanu
class DatabaseSession:
    def __init__(self, url: str) -> None:
        self._url = url
        self._conn: Connection | None = None

    def __enter__(self) -> DatabaseSession:
        self._conn = connect(self._url)
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_val: BaseException | None,
        exc_tb: TracebackType | None,
    ) -> bool:
        if self._conn:
            if exc_type:
                self._conn.rollback()
            else:
                self._conn.commit()
            self._conn.close()
        return False  # NIE suppress exception
```

> **Ruff:** `SIM105` (suppressible-exception → `suppress()`), `SIM115` (open-file-with-context-handler).
> **Powiązane:** `08-error-handling.md` — exception hierarchy, propagation, error boundaries, retry patterns.

---

## 9. Unpacking & destructuring

### 9.1 Tabela wzorców

| Wzorzec | Przykład | Użyj gdy |
|---------|---------|----------|
| Tuple unpacking | `x, y = point` | Znana długość |
| Star unpacking | `first, *rest = items` | Head/tail pattern |
| Dict unpacking | `{**defaults, **overrides}` | Merge dicts |
| Swap | `a, b = b, a` | Zamiana wartości |
| Ignore | `_, value = pair` | Niepotrzebny element |
| Nested | `(x, y), z = nested` | Zagnieżdżone tuple |

### 9.2 Snippety

```python
# ✅ Tuple unpacking z type hints
point: tuple[float, float] = get_coordinates()
x, y = point

# ✅ Star unpacking — head/tail
first, *middle, last = sorted_values
header, *data_rows = csv_lines

# ✅ Dict merge (Python 3.9+)
config = {**defaults, **user_config, **cli_overrides}

# ✅ Enumerate + unpacking
for i, (key, value) in enumerate(mapping.items()):
    logger.debug("#{i}: {key}={value}", i=i, key=key, value=value)

# ✅ Ignore z _
for _, value in pairs:
    process(value)

# ✅ Function return unpacking
def get_bounds(data: list[float]) -> tuple[float, float]:
    return min(data), max(data)

lo, hi = get_bounds(measurements)
```

```python
# ❌ Indeksowanie zamiast unpacking
x = point[0]  # nieczytelne
y = point[1]

# ❌ Manual swap
temp = a
a = b
b = temp  # → a, b = b, a
```

> Swap i unpacking to idiomy Pythona — brak dedykowanej ruff rule, ale styl jest wymuszany przez code review.

---

## 10. Itertools & functools

### 10.1 itertools — top-10 najużyteczniejszych

| Funkcja | Co robi | Przykład |
|---------|---------|---------|
| `chain` | Łączy iteratory | `chain(list1, list2)` |
| `chain.from_iterable` | Flatten 1 level | `chain.from_iterable(nested)` |
| `islice` | Slice na iterator | `islice(gen, 10)` — first 10 |
| `groupby` | Grupuj consecutive equal | `groupby(sorted(items), key=...)` |
| `batched` | Chunk na n-elementowe | `batched(items, 3)` ⚠️ 3.12+ (backport: `more-itertools`) |
| `product` | Cartesian product | `product(colors, sizes)` |
| `combinations` | n choose k | `combinations(items, 2)` |
| `zip_longest` | Zip z fill | `zip_longest(a, b, fillvalue=0)` |
| `accumulate` | Running total | `accumulate(values)` |
| `repeat` | Infinite repeater | `repeat(default, n)` |

### 10.2 functools — top patterns

```python
import functools


# ✅ lru_cache — memoize pure function
@functools.lru_cache(maxsize=256)
def fibonacci(n: int) -> int:
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)


# ✅ cached_property — lazy computed attribute
class Config:
    @functools.cached_property
    def parsed_rules(self) -> list[Rule]:
        """Expensive parse — computed once, cached on instance."""
        return parse_rules(self.raw_rules)


# ✅ partial — curry function
from functools import partial

double = partial(multiply, factor=2)
results = [double(x) for x in values]


# ✅ reduce — fold operation
from functools import reduce

def compose(*funcs: Callable[[T], T]) -> Callable[[T], T]:
    return reduce(lambda f, g: lambda x: f(g(x)), funcs)


# ✅ singledispatch — type-based dispatch
@functools.singledispatch
def serialize(value: object) -> str:
    msg = f"Cannot serialize {type(value)}"
    raise TypeError(msg)

@serialize.register
def _(value: str) -> str:
    return value

@serialize.register
def _(value: int) -> str:
    return str(value)

@serialize.register
def _(value: list) -> str:
    return json.dumps(value)
```

```python
# ❌ Manual memoization — use lru_cache
_cache: dict[int, int] = {}
def fib(n: int) -> int:
    if n not in _cache:
        _cache[n] = fib(n-1) + fib(n-2) if n >= 2 else n
    return _cache[n]
```

> **Tip:** `@lru_cache` wymaga hashable argumentów — jeśli nie są, dostaniesz `TypeError` w runtime.

---

## 11. Antypatterny

### 11.1 Top-10 antypatterny kodu

| # | Antypattern | Fix | Ruff |
|---|-------------|-----|------|
| 1 | `os.path.join()` zamiast pathlib | `Path(a) / b` | `PTH118` |
| 2 | `type(x) == int` zamiast `isinstance` | `isinstance(x, int)` | `E721` |
| 3 | Mutable default: `def f(x=[])` | `def f(x: list[int] \| None = None)` | `B006` |
| 4 | Bare `except:` | `except Exception:` | `E722` |
| 5 | `len(x) == 0` zamiast truthiness | `if not x:` | `SIM103` |
| 6 | `dict.keys()` w `in` | `if key in d:` | `SIM118` |
| 7 | Manual list append w loop | List comprehension | `PERF401` |
| 8 | `isinstance(..., (str, int))` chain | `match/case` | — |
| 9 | Nested if/else (>2 levels) | Guard clauses / early return | `SIM102` |
| 10 | `print()` zamiast logger | `logger.info(...)` | `T201` |

### 11.2 Mutable default argument — krytyczne

```python
# ✅ None sentinel + factory
def process(items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    return items

# ✅ Alternatywa — dataclass z field()
@dataclass
class Config:
    items: list[str] = field(default_factory=list)

# ❌ B006: mutable default — SHARED across calls!
def process(items: list[str] = []) -> list[str]:
    items.append("new")  # Modyfikuje DEFAULT → bug
    return items
```

### 11.3 `isinstance` — poprawne użycie

```python
# ✅ isinstance z tuple typów
if isinstance(value, (int, float)):
    return round(value, 2)

# ✅ Type guard (Python 3.10+)
from typing import TypeGuard

def is_string_list(val: list[object]) -> TypeGuard[list[str]]:
    return all(isinstance(x, str) for x in val)

# ❌ E721: type() comparison
if type(x) == int:  # Nie respektuje inheritance!
    ...

# ✅ isinstance z | union (Python 3.10+, PEP 604)
isinstance(x, int | float)  # ← poprawne od 3.10, alternatywa: isinstance(x, (int, float))
```

---

## 12. Egzekucja ruff

### 12.1 Kluczowe reguły dla code patterns

| Kategoria | Ruff prefix | Zakres |
|-----------|-------------|--------|
| pathlib | `PTH` | Wymuszenie `pathlib.Path` zamiast `os.path` |
| comprehensions | `C4` | Zbędne `list()`, `set()`, `dict()` wokół generatorów |
| simplify | `SIM` | Uproszczenia: suppress, ternary, collapsible if |
| pyupgrade | `UP` | Modernizacja: `\|` union, f-string, match |
| return | `RET` | Early return, unnecessary else/assign |
| performance | `PERF` | Manual append → comprehension, try-in-loop |
| bugbear | `B` | Mutable defaults, assert w except |

### 12.2 Tabela: reguła → co egzekwuje

| Ruff | Nazwa | Co łapie |
|------|-------|----------|
| `PTH100`–`PTH208` | flake8-use-pathlib | `os.path.*` → `Path.*` |
| `C400`–`C419` | flake8-comprehensions | Zbędne `list(x for x)`, `dict([(k,v)])` |
| `SIM102` | collapsible-if | Nested `if` → single `if ... and ...` |
| `SIM105` | suppressible-exception | `try/except/pass` → `suppress()` |
| `SIM108` | use-ternary | `if/else` assignment → ternary |
| `SIM118` | in-dict-keys | `key in d.keys()` → `key in d` |
| `UP031` | printf-format | `"x: %s" % val` → f-string |
| `UP032` | format-call | `"x: {}".format(val)` → f-string |
| `RET504` | unnecessary-assign | `x = val; return x` → `return val` |
| `RET505`/`506` | unnecessary-else | `if: return; else:` → `if: return;` |
| `PERF401` | manual-list-append | Loop + append → comprehension |
| `B006` | mutable-argument-default | `def f(x=[])` → `def f(x=None)` |
| `E721` | type-comparison | `type(x) == T` → `isinstance(x, T)` |
| `T201` | print-found | `print()` → logger |
| `RUF009` | mutable-dataclass-default | `items: list = []` → `field(default_factory=list)` |
| `SIM115` | open-file-with-context-handler | `f = open(x)` → `with open(x) as f:` |

### 12.3 per-file-ignores — pragmatyczne wyjątki

```toml
[tool.ruff.lint.per-file-ignores]
"tests/**" = ["S101"]          # assert OK w testach
"scripts/**" = ["T20"]         # print() OK w skryptach CLI
"__init__.py" = ["F401"]       # re-exporty nie są unused imports
"**/migrations/**" = ["E501"]  # auto-generated, długie linie OK
```

### 12.4 NICE-TO-HAVE reguły

| Ruff | Co | Status |
|------|-----|--------|
| `FURB` (refurb) | Dodatkowe uproszczenia i modernizacje | Eksperymentalny |
| `FLY002` | f-string join → `"".join()` | Opcjonalny |

---
## Źródła

> - [PEP 572](https://peps.python.org/pep-0572/) — Assignment Expressions
> - [PEP 634](https://peps.python.org/pep-0634/) — Structural Pattern Matching
> - [Ruff PTH rules](https://docs.astral.sh/ruff/rules/#flake8-use-pathlib-pth) — pathlib enforcement
> - [Ruff C4 rules](https://docs.astral.sh/ruff/rules/#flake8-comprehensions-c4) — comprehension style
> - [Ruff SIM rules](https://docs.astral.sh/ruff/rules/#flake8-simplify-sim) — simplification
> - [Real Python — Match/Case](https://realpython.com/python310-new-features/#structural-pattern-matching) — tutorial
> - [itertools docs](https://docs.python.org/3/library/itertools.html) — standard library reference
> - [functools docs](https://docs.python.org/3/library/functools.html) — standard library reference
> - `06-function-api-design.md` — sygnatura, parametry, composition
> - `08-error-handling.md` — exception hierarchy, boundaries, retry
> - `09-design-patterns.md` — Iterator, Context Manager, Strategy (GoF vs Pythonic)
