# 02 — Type Hints

> **Cel:** Kompletny poradnik typowania w Pythonie — od podstaw do zaawansowanych wzorców.
> **Scope:** Uniwersalny — pasuje do każdego projektu Python ≥3.10.

---

## Spis treści

1. [Po co typować](#1-po-co-typować)
2. [Podstawy](#2-podstawy)
3. [Modern Python ≥3.10](#3-modern-python-310)
4. [Kolekcje i typy złożone](#4-kolekcje-i-typy-złożone)
5. [Zaawansowane typy](#5-zaawansowane-typy)
6. [TYPE_CHECKING block](#6-type_checking-block)
7. [Escape hatches](#7-escape-hatches)
8. [mypy strict mode](#8-mypy-strict-mode)
9. [Kiedy typować, kiedy nie](#9-kiedy-typować-kiedy-nie)


## 📋 Quick Reference (ściąga)

```python
from __future__ import annotations                       # KAŻDY moduł, linia 1

from typing import (
    TYPE_CHECKING, Final, Generic, Literal, NamedTuple, NotRequired,
    ParamSpec, Self, TypeAlias, TypedDict, TypeGuard, TypeVar, cast, overload,
)

if TYPE_CHECKING:
    from collections.abc import Callable, Iterator, Sequence
    from pathlib import Path

# ── Zmienne ───────────────────────────────────────────
name: str = "Mateusz"
count: int = 42
items: list[str] = []                                    # pusta → podaj typ
user: User | None = None                                 # None start → podaj typ
MAX_RETRIES: Final[int] = 5                              # stała

# ── Funkcje ───────────────────────────────────────────
def process(data: np.ndarray, scale: float = 1.0) -> Result:
    ...

def setup() -> None:                                     # nic nie zwraca
    ...

def find(id: int) -> User | None:                        # może None
    ...

# ── Callable ──────────────────────────────────────────
callback: Callable[[float], None]                        # (float) -> None
handler: Callable[[str, int], bool]                      # (str, int) -> bool
factory: Callable[[], User]                              # () -> User

# ── TypeVar + ParamSpec ───────────────────────────────
T = TypeVar("T")
P = ParamSpec("P")
def deco(fn: Callable[P, T]) -> Callable[P, T]: ...     # zachowaj sygnaturę

# ── Generic ───────────────────────────────────────────
class Stack(Generic[T]):
    def push(self, item: T) -> None: ...
    def pop(self) -> T: ...

# ── Protocol ──────────────────────────────────────────
class Engine(Protocol):
    def process(self, image: np.ndarray) -> Result: ...

# ── Final / Literal ───────────────────────────────────
MAX: Final[int] = 5                                      # stała (NIGDY w TYPE_CHECKING)
mode: Literal["fast", "accurate"] = "fast"               # ograniczone wartości

# ── TypeAlias ─────────────────────────────────────────
BBox: TypeAlias = tuple[int, int, int, int]

# ── TypedDict ─────────────────────────────────────────
class Config(TypedDict):
    name: str
    debug: NotRequired[bool]

# ── NamedTuple ────────────────────────────────────────
class Point(NamedTuple):
    x: float
    y: float

# ── Self (3.11+) ─────────────────────────────────────
class Builder:
    def set_name(self, n: str) -> Self: ...               # fluent API

# ── TypeGuard ─────────────────────────────────────────
def is_str_list(obj: object) -> TypeGuard[list[str]]: ... # custom narrowing

# ── @overload ─────────────────────────────────────────
@overload
def load(path: str) -> str: ...
@overload
def load(path: Path) -> bytes: ...
def load(path: str | Path) -> str | bytes: ...

# ── Escape hatches ────────────────────────────────────
user = cast(User, registry.get("user"))                  # cast — zero runtime
data.method()  # type: ignore[attr-defined]              # ZAWSZE z kodem błędu
```

---

## 1. Po co typować

Type hints to adnotacje typów, które **nie zmieniają zachowania kodu** w runtime.
Python je ignoruje podczas wykonywania. Są dla **narzędzi i ludzi**.

### Co dają

| Korzyść | Jak to działa |
|---------|--------------|
| **Autocomplete** | IDE wie co zwraca funkcja → podpowiada metody i atrybuty |
| **Błędy PRZED uruchomieniem** | `mypy` wykrywa `calculate("abc", 5)` bez odpalania kodu |
| **Dokumentacja** | Czytasz sygnaturę i wiesz: co podać, co dostaniesz |
| **Refactoring** | Zmienisz typ → IDE pokaże WSZYSTKIE miejsca do poprawki |
| **Code review** | Reviewer widzi kontrakt — nie musi zgadywać |

### Przykład: z vs bez

```python
# ❌ Bez type hints — nie wiesz co tu wpada i co wraca
def process(data, config, callback):
    ...

# ✅ Z type hints — kontrakt jest jawny
def process(
    data: np.ndarray,
    config: ProcessConfig,
    callback: Callable[[float], None] | None = None,
) -> ProcessResult:
    ...
```

Bez type hints musisz czytać implementację żeby zrozumieć interfejs.
Z type hints — sygnatura jest dokumentacją.

> 💡 **Tip:** Type hints to jedyna forma dokumentacji, której poprawność weryfikuje narzędzie (`mypy`). Docstringi mogą kłamać — typy nie.

---

## 2. Podstawy

### Zmienne

```python
name: str = "Mateusz"
count: int = 42
ratio: float = 0.85
active: bool = True
```

W praktyce **nie typujesz trywialnych zmiennych** — mypy sam wyinferuje typ z przypisania.
Typujesz gdy:
- Typ nie jest oczywisty z kontekstu
- Zmienna zaczyna jako `None` i potem dostaje wartość
- Chcesz zawęzić typ (np. `list[str]` zamiast generycznego `list`)

```python
# ✅ Typuj — typ nie jest oczywisty
result: SearchResult = engine.search(query)
items: list[str] = []  # pusta lista — mypy nie wie co będzie w środku

# ❌ Nie typuj — oczywiste z kontekstu
name: str = "Mateusz"     # mypy sam wie że to str
count: int = len(items)    # mypy sam wie że len() → int
```

### Parametry funkcji

**ZAWSZE** typuj parametry. Zero wyjątków.

```python
def resize_image(image: np.ndarray, width: int, height: int) -> np.ndarray:
    ...
```

### Return type

**ZAWSZE** typuj return. Nawet jak nic nie zwracasz.

```python
def process() -> None:        # nic nie zwraca
    ...

def get_name() -> str:        # zwraca str
    return "Mateusz"

def find_user(id: int) -> User | None:  # może zwrócić None
    ...
```

> 💡 **Tip:** `-> None` to nie to samo co brak returna. `-> None` to **jawna deklaracja**: "ta funkcja nic nie zwraca". Brak adnotacji to "nie wiem/nie chcę mówić".

### Atrybuty klas

Typuj w `__init__` lub jako class-level annotations:

```python
class TaskQueue:
    # Class-level annotation (bez wartości = only type hint)
    config: QueueConfig

    def __init__(self, config: QueueConfig) -> None:
        self.config = config
        self._tasks: list[Task] = []           # typowane w __init__
        self._handlers: dict[str, Handler] = {}
```

---

## 3. Modern Python ≥3.10

### `from __future__ import annotations`

**KAŻDY moduł.** Linia numer 1 (przed wszystkimi importami).

```python
from __future__ import annotations  # ← ZAWSZE

import os
from pathlib import Path
```

Co to robi:
- **Wszystkie adnotacje stają się stringami** — nie są ewaluowane w runtime
- Pozwala na forward references (użycie klasy zanim jest zdefiniowana)
- Pozwala przenieść ciężkie importy do `TYPE_CHECKING` block
- Pozwala na `X | Y` składnię nawet na Pythonie 3.9

### Lowercase generics

Od Pythona 3.9+ (a z `from __future__ import annotations` — od 3.7+):

```python
# ✅ Modern — lowercase, wbudowane typy
items: list[str] = []
config: dict[str, int] = {}
point: tuple[float, float] = (1.0, 2.0)
unique: set[int] = {1, 2, 3}
frozen: frozenset[str] = frozenset({"a", "b"})

# ❌ Legacy — NIE UŻYWAJ
from typing import List, Dict, Tuple, Set
items: List[str] = []
```

### Union syntax: `X | Y`

```python
# ✅ Modern — pipe operator
def find(id: int) -> User | None:
    ...

def parse(value: str | int | float) -> str:
    ...

# ❌ Legacy — NIE UŻYWAJ
from typing import Optional, Union
def find(id: int) -> Optional[User]: ...
def parse(value: Union[str, int, float]) -> str: ...
```

> 💡 **Tip:** `Optional[X]` to dosłownie `X | None`. Nic więcej. `X | Y` jest czytelniejsze i nie importujesz z `typing`.

---

## 4. Kolekcje i typy złożone

### Kolekcje — co kiedy

| Typ | Użyj gdy | Przykład |
|-----|----------|---------|
| `list[X]` | Zmienna długość, homogeniczne | `scores: list[int]` |
| `tuple[X, Y, Z]` | Stała długość, różne typy | `point: tuple[float, float]` |
| `tuple[X, ...]` | Stała-semantycznie-ale-zmienna-długość | `ids: tuple[int, ...]` |
| `dict[K, V]` | Klucz-wartość, dynamiczny | `config: dict[str, Any]` |
| `set[X]` | Unikalne elementy | `tags: set[str]` |
| `frozenset[X]` | Unikalne, immutable (np. stałe) | `SUPPORTED: frozenset[str]` |
| `Sequence[X]` | Read-only, akceptujesz list/tuple/etc | `def f(items: Sequence[int])` |
| `Mapping[K, V]` | Read-only dict | `def f(config: Mapping[str, str])` |
| `Iterable[X]` | Cokolwiek iterowalne | `def f(data: Iterable[str])` |

> 💡 **Tip:** W parametrach funkcji preferuj **abstrakcyjne typy** (`Sequence`, `Mapping`, `Iterable`) — są bardziej elastyczne. W returnach i atrybutach używaj **konkretnych** (`list`, `dict`).

### Callable

`Callable` opisuje funkcję lub obiekt wywoływalny:

```python
from collections.abc import Callable

# Pełna sygnatura: Callable[[param_types], return_type]
handler: Callable[[str, int], bool]           # (str, int) -> bool
callback: Callable[[float], None]             # (float) -> None
factory: Callable[[], User]                   # () -> User

# Gdy sygnatura jest zbyt złożona lub dynamiczna:
decorator: Callable[..., object]              # dowolne argumenty
```

```python
# ❌ Red flag — co to przyjmuje? co zwraca?
callback: Callable

# ✅ ZAWSZE z sygnaturą
callback: Callable[[int], str]
```

### Iterator i Generator

```python
from collections.abc import Iterator, Generator

# Iterator — coś co yielduje wartości
def count_up(n: int) -> Iterator[int]:
    for i in range(n):
        yield i

# Generator — pełna specyfikacja: Generator[YieldType, SendType, ReturnType]
def accumulator() -> Generator[float, float, str]:
    total = 0.0
    while True:
        value = yield total
        if value is None:
            return f"Final: {total}"
        total += value
```

W praktyce: `Iterator[X]` wystarczy w 99% przypadków. `Generator` potrzebujesz gdy używasz `.send()` lub `.throw()`.

> 💡 **Tip:** Od Pythona 3.13 `Generator` pozwala na krótką formę `Generator[int]` (samo YieldType). Na 3.10–3.12 musisz podać wszystkie trzy: `Generator[int, None, None]`.

### TypedDict — słowniki ze znanymi kluczami

Gdy potrzebujesz `dict` ze **stałym zbiorem kluczy i typów** (np. JSON response, config):

```python
from typing import TypedDict, NotRequired

class UserConfig(TypedDict):
    name: str
    email: str
    is_admin: bool
    bio: NotRequired[str]      # klucz opcjonalny (Python 3.11+)

# Użycie:
config: UserConfig = {"name": "Mateusz", "email": "m@x.com", "is_admin": False}
config["name"]      # ✅ mypy wie: str
config["missing"]   # ❌ mypy error — klucz nie istnieje
```

**Kiedy TypedDict vs dataclass:**

| TypedDict | dataclass |
|-----------|-----------|
| Zewnętrzne dane (JSON, API response) | Wewnętrzne obiekty domeny |
| Potrzebujesz `dict` interfejsu (`config["key"]`) | Potrzebujesz `.attribute` |
| Serializable out of the box (`json.dumps`) | Wymaga konwersji (`asdict()`) |

### NamedTuple — immutable tuple z nazwami

```python
from typing import NamedTuple

class Point(NamedTuple):
    x: float
    y: float

p = Point(1.0, 2.0)
p.x                  # dostęp po nazwie
x, y = p              # unpacking jak tuple
```

**Kiedy NamedTuple vs dataclass:**

| NamedTuple | dataclass |
|------------|-----------|
| Immutable, lekkie | Mutowalne (opcjonalnie frozen) |
| Hashable by default | Wymaga `frozen=True` + `eq=True` |
| Działa jako tuple (unpacking, indexing) | Nie jest tuple |
| 2-5 pól, proste DTO | Więcej logiki, metody, validation |

---

## 5. Zaawansowane typy

### TypeVar — zmienne typów

`TypeVar` mówi: "ten typ jest nieznany, ale musi być **spójny**":

```python
from typing import TypeVar

T = TypeVar("T")

def first(items: list[T]) -> T:
    return items[0]

# Użycie:
first([1, 2, 3])     # T = int → zwraca int
first(["a", "b"])     # T = str → zwraca str
```

`T` zostaje powiązane przy wywołaniu. Mypy wie, że `first([1, 2, 3])` zwraca `int`, nie `Any`.

#### Bounded TypeVar

```python
# T musi być str lub subklasą str
T = TypeVar("T", bound=str)

# T musi być jednym z wymienionych typów
T = TypeVar("T", int, float)

# TypeVar dla dekoratorów (najczęściej):
F = TypeVar("F", bound=Callable[..., Any])
```

### ParamSpec — typowanie dekoratorów

`TypeVar` zachowuje **typ zwracany**. `ParamSpec` zachowuje **sygnaturę parametrów**:

```python
from typing import ParamSpec, TypeVar

P = ParamSpec("P")
T = TypeVar("T")

def timer(func: Callable[P, T]) -> Callable[P, T]:
    """Dekorator zachowujący pełną sygnaturę."""
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> T:
        start = time.monotonic()
        result = func(*args, **kwargs)
        logger.debug("Took {:.1f}ms", (time.monotonic() - start) * 1000)
        return result
    return wrapper

@timer
def process(image: np.ndarray, scale: float = 1.0) -> Result:
    ...

# mypy wie: process(image, scale=2.0) → Result
# bez ParamSpec mypy straciłby info o parametrach
```

**Bez `ParamSpec`** dekorator "zjada" typy parametrów — IDE traci autocomplete a mypy nie wychwytuje złych argumentów. Używaj `ParamSpec` w **każdym** dekoratorze.

### Generic — generyczne klasy

```python
from typing import Generic, TypeVar

T = TypeVar("T")

class Stack(Generic[T]):
    """Generyczny stos."""

    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()

# Użycie: mypy wie co jest w stosie
stack = Stack[int]()
stack.push(42)
value: int = stack.pop()  # mypy wie → int
```

### Protocol — structural typing (duck typing z typami)

`Protocol` definiuje interfejs bez dziedziczenia. Jeśli obiekt ma wymagane metody — pasuje:

```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class EngineProtocol(Protocol):
    """Każdy engine musi mieć te metody."""

    def load(self) -> None: ...
    def process(self, image: np.ndarray) -> Result: ...
    def unload(self) -> None: ...

# Klasa NIE dziedziczy po Protocol — ale pasuje bo ma te metody
class MyEngine:
    def load(self) -> None: ...
    def process(self, image: np.ndarray) -> Result: ...
    def unload(self) -> None: ...

def run_engine(engine: EngineProtocol) -> Result:
    engine.load()
    return engine.process(image)

run_engine(MyEngine())  # ✅ OK — ma wymagane metody
```

**Kiedy Protocol zamiast ABC:**

| Cecha | ABC | Protocol |
|-------|-----|----------|
| Wymaga dziedziczenia | ✅ `class X(ABC)` | ❌ duck typing |
| Kontrola w runtime | `isinstance` działa | Wymaga `@runtime_checkable` |
| Zewnętrzne klasy | Nie zmienisz cudzego kodu | ✅ Pasują jeśli mają metody |
| Mypy support | ✅ Pełny | ✅ Pełny |

> 💡 **Tip:** W nowych projektach preferuj `Protocol` nad ABC. Duck typing jest naturalny dla Pythona — Protocol go formalizuje.

### Final — stałe

```python
from typing import Final

MAX_RETRIES: Final[int] = 5
DEFAULT_TIMEOUT: Final[float] = 30.0
SUPPORTED_FORMATS: Final[frozenset[str]] = frozenset({".jpg", ".png", ".webp"})
```

`Final` mówi mypy: **ta wartość nie może być zmieniona** po przypisaniu. Próba `MAX_RETRIES = 10` → błąd mypy.

### Literal — ograniczone wartości

```python
from typing import Literal

def set_mode(mode: Literal["fast", "accurate", "balanced"]) -> None:
    ...

# Użycie:
set_mode("fast")       # ✅ OK
set_mode("turbo")      # ❌ mypy error — "turbo" nie jest dozwolone

# Jako atrybut — ogranicza dozwolone wartości
status: Literal["running", "completed", "failed"]
```

**Kiedy `Literal` zamiast `Enum`:**

| Literal | Enum |
|---------|------|
| Proste, 2-5 wartości | Więcej logiki, metody, iteracja |
| Używane w typach JSON/API | Potrzebujesz `.name`, `.value` |
| Zero boilerplate | Wymaga klasy |

### TypeAlias — nazwane aliasy typów

```python
from typing import TypeAlias

# Nadaj nazwę złożonemu typowi
BBox: TypeAlias = tuple[int, int, int, int]
ImageArray: TypeAlias = "np.ndarray"
Handler: TypeAlias = Callable[[Task], dict[str, object]]

# Użyj zamiast powtarzania
def detect(image: ImageArray) -> list[BBox]:
    ...
```

> Python 3.12+ ma składnię `type BBox = tuple[int, int, int, int]` — ale z `TypeAlias` działa od 3.10.

### @overload — różne sygnatury, różne returny

```python
from typing import overload

@overload
def parse(value: str) -> list[str]: ...
@overload
def parse(value: bytes) -> list[bytes]: ...

def parse(value: str | bytes) -> list[str] | list[bytes]:
    if isinstance(value, str):
        return value.split(",")
    return value.split(b",")
```

`@overload` NIE definiuje implementacji — to **deklaracje** dla mypy. Implementacja jest ostatnia, bez dekoratora.

**Kiedy `@overload`:**
- Return type zależy od typu argumentu
- Bez overload musisz zwrócić union → użytkownik musi sam zawężać typ

### Never — funkcja nigdy nie wraca

```python
from typing import Never

def abort(message: str) -> Never:
    """Zawsze rzuca wyjątek, nigdy nie zwraca."""
    raise SystemExit(message)
```

`Never` mówi mypy: ta ścieżka kodu jest nieosiągalna po wywołaniu. Używany w exhaustive pattern matching:

```python
from typing import assert_never

def handle(mode: Literal["fast", "accurate"]) -> str:
    match mode:
        case "fast":
            return "szybko"
        case "accurate":
            return "dokładnie"
        case _ as unreachable:
            assert_never(unreachable)  # mypy error jeśli dodasz nowy Literal
```

### Self — typ zwracany "ja sam" (Python 3.11+)

```python
from typing import Self

class Builder:
    def set_name(self, name: str) -> Self:
        self._name = name
        return self

    def set_age(self, age: int) -> Self:
        self._age = age
        return self

# Fluent API: mypy wie że chain zwraca Builder (lub subklasę)
user = Builder().set_name("Mateusz").set_age(22)
```

Bez `Self` musisz użyć `TypeVar` bound do klasy — `Self` to skrót.

### TypeGuard — custom type narrowing

`TypeGuard` pozwala napisać własny `isinstance` — funkcję, która **zawęża typ**:

```python
from typing import TypeGuard

def is_string_list(obj: object) -> TypeGuard[list[str]]:
    """Sprawdza czy obj to lista stringów."""
    return isinstance(obj, list) and all(isinstance(x, str) for x in obj)

data: object = get_data()
if is_string_list(data):
    # mypy wie: data to list[str] wewnątrz tego if
    print(data[0].upper())
```

Przydatny gdy `isinstance` nie wystarczy (np. sprawdzasz zawartość kolekcji, warunki na atrybutach).

---

## 6. TYPE_CHECKING block

### Problem

Niektóre importy:
- Są ciężkie (np. `numpy`, `torch`) — spowalniają import modułu
- Tworzą cykliczne zależności
- Są potrzebne TYLKO do type hints — nie w runtime

### Rozwiązanie

```python
from __future__ import annotations  # ← WYMAGANE — zamienia adnotacje na stringi

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    import numpy as np
    from pathlib import Path
    from collections.abc import Callable, Iterator
    from myapp.services.storage.types import StorageResult
```

Blok `if TYPE_CHECKING:` jest **zawsze False** w runtime. Kod w nim **nigdy się nie wykonuje**.
Mypy/Pylance go czytają. Python go ignoruje.

### Kiedy przenosić do TYPE_CHECKING

| Przenoś | Nie przenoś |
|---------|-------------|
| Heavy deps (`numpy`, `torch`, `PIL`) gdy nie używasz w runtime | Typy używane w runtime (`isinstance`, dataclass fields) |
| `collections.abc` (`Callable`, `Iterator`, `Sequence`) | `Final`, `Literal` — importuj normalnie (runtime values) |
| Importy tworzące cykliczne zależności | Pydantic model fields (ewaluowane w runtime) |
| Importy z cudzych pakietów (mogą nie być zainstalowane) | Dekoratory i bazowe klasy (`@dataclass`, `Protocol` z `isinstance`) |
| Typy first-party używane TYLKO w adnotacjach | `Path` jeśli tworzysz ścieżki w runtime |

> 💡 **Tip:** `Final` i `Literal` NIGDY nie przenoś do `TYPE_CHECKING`. Są dostępne z `typing` i mogą być ewaluowane w runtime (np. `Final` przypisanie, `Literal` w Pydantic). Bezpiecznie jest je trzymać w normalnych importach.

### Wzorzec

```python
from __future__ import annotations

import time                                    # runtime — używane w kodzie
from dataclasses import dataclass, field       # runtime — dekorator
from enum import IntEnum                       # runtime — bazowa klasa
from typing import TYPE_CHECKING, Final        # Final = runtime, TYPE_CHECKING = guard

from loguru import logger                      # runtime — logger

if TYPE_CHECKING:
    from collections.abc import Callable, Iterator   # only annotations
    from pathlib import Path                         # only annotations
```

> 💡 **Tip:** ruff z regułą `TCH` automatycznie wykrywa importy, które powinny być w `TYPE_CHECKING` block. Użyj `TCH003` (stdlib) i `TCH001`/`TCH002` (third-party/first-party).

---

## 7. Escape hatches

Czasem system typów jest zbyt restrykcyjny. Masz 3 wyjścia awaryjne:

### `Any` — wyłączenie typowania

```python
from typing import Any

# ❌ UNIKAJ — wyłącza sprawdzanie typów
data: Any = get_something()
data.whatever()  # mypy nie protestuje

# ✅ WYJĄTEK Kiedy OK:
# 1. Zewnętrzna biblioteka bez typów
result: Any = untyped_library.do_thing()
# 2. Dynamiczne struktury (JSON z nieznanym schematem)
raw: dict[str, Any] = json.loads(response.text)
```

`Any` to wirusowy typ — rozprzestrzenia się. `Any` + `int` = `Any`. Minimalizuj użycie.

### `cast()` — "wiem lepiej niż mypy"

```python
from typing import cast

# Mówisz mypy: zaufaj mi, to jest User
user = cast(User, service_registry.get("user"))

# mypy akceptuje to bez sprawdzania. Jeśli się mylisz → runtime error.
```

**`cast()` nie robi nic w runtime.** Zero konwersji. To TYLKO adnotacja dla mypy.

### `type: ignore` — uciszenie błędu

```python
# ZAWSZE z kodem błędu — nie uciszaj wszystkiego na oślep
result = untyped_func()  # type: ignore[no-untyped-call]
model.load(path)         # type: ignore[arg-type]
```

| Kod | Znaczenie | Kiedy OK |
|-----|-----------|----------|
| `[no-untyped-call]` | Wywołujesz nietypowaną funkcję | Zewnętrzna lib bez stubs |
| `[arg-type]` | Zły typ argumentu | Wiesz że działa, mypy nie rozumie |
| `[assignment]` | Zły typ w przypisaniu | Dynamiczny return z lib |
| `[import-not-found]` | Import nieznaleziony | Opcjonalna dependency |
| `[attr-defined]` | Atrybut nie istnieje wg mypy | Dynamiczny atrybut (plugin) |
| `[return-value]` | Zły return type | Overengineered generics |
| `[union-attr]` | Atrybut nie istnieje na wszystkich wariantach unii | Wiesz który wariant |
| `[misc]` | Różne | Ostatnia deska ratunku |
| `[no-untyped-def]` | Funkcja bez type hints | Legacy/thirdparty wrapper |

> 💡 **Tip:** Nigdy `# type: ignore` bez kodu błędu w nawiasach. Uciszysz WSZYSTKIE błędy na linii — w tym te które chcesz widzieć.

### Hierarchia wyboru

1. **Napraw typ** — popraw adnotację, napraw kod
2. **`cast()`** — wiesz co to jest, mypy nie wie
3. **`type: ignore[specific-code]`** — nie da się naprawić (external lib, dynamic)
4. **`Any`** — last resort, zero informacji typowej

---

## 8. mypy strict mode

### Co wymusza

mypy z `strict = true` (w `pyproject.toml`) włącza:

| Flaga | Co robi |
|-------|---------|
| `--disallow-untyped-defs` | Każda funkcja MUSI mieć type hints |
| `--disallow-any-generics` | `list` → musi być `list[X]`, nie gołe `list` |
| `--warn-return-any` | Return `Any` → warning |
| `--disallow-untyped-calls` | Nie wolno wywoływać nietypowanych funkcji |
| `--no-implicit-optional` | `def f(x: int = None)` → error (musi być `int \| None`) |
| `--strict-equality` | `1 == "1"` → error (porównujesz różne typy) |
| `--warn-unused-ignores` | Niepotrzebne `# type: ignore` → warning |

### Typowe błędy i fixy

#### 1. Missing return type

```python
# ❌ mypy error: Function is missing a return type annotation
def setup():
    ...

# ✅ Fix
def setup() -> None:
    ...
```

#### 2. Incompatible types in assignment

```python
# ❌ error: Incompatible types in assignment (got "None", expected "str")
name: str = None

# ✅ Fix — jawnie zadeklaruj że może być None
name: str | None = None
```

#### 3. Missing type parameters for generic type

```python
# ❌ error: Missing type parameters for generic type "list"
items: list = []

# ✅ Fix — podaj typ elementów
items: list[str] = []
```

#### 4. Return type "None" of "__init__" incompatible

```python
# ❌ error (zazwyczaj z pluginem pydantic/dataclass)
class Broken:
    def __init__(self):  # brak -> None
        ...

# ✅ Fix
class Fixed:
    def __init__(self) -> None:
        ...
```

#### 5. Argument has incompatible type because of mutable default

```python
# ❌ error: mutable default argument
def process(items: list[str] = []) -> None:
    ...

# ✅ Fix: None guard
def process(items: list[str] | None = None) -> None:
    items = items or []
```

### Konfiguracja w `pyproject.toml`

```toml
[tool.mypy]
python_version = "3.10"
strict = true
warn_return_any = true
warn_unused_ignores = true
plugins = ["pydantic.mypy"]           # jeśli używasz Pydantic

[[tool.mypy.overrides]]
module = ["some_untyped_library.*"]   # ucisz dla konkretnej lib
ignore_missing_imports = true
disallow_untyped_defs = false
```

---

## 9. Kiedy typować, kiedy nie

### ✅ ZAWSZE typuj

| Element | Dlaczego |
|---------|----------|
| Parametry funkcji | Kontrakt — co akceptujesz |
| Return type | Kontrakt — co oddajesz |
| Atrybuty klas (w `__init__` lub class-level) | IDE autocomplete, mypy |
| Puste kolekcje (`items: list[str] = []`) | mypy nie wyinferuje typu elementów |
| Zmienne startujące jako `None` | mypy musi wiedzieć co będzie potem |
| Public API (`__all__` exports) | Użytkownicy Twojego kodu polegają na typach |

### ❌ NIE typuj (redundantne)

| Element | Dlaczego |
|---------|----------|
| Oczywiste przypisania (`x = 42`) | mypy sam wyinferuje `int` |
| Return z `len()`, `str()`, `int()` | mypy zna returny builtinów |
| Zmienne lokalne z jednoznacznym typem | Szum wizualny, zero wartości dodanej |
| Stałe z literałami (`NAME = "Mateusz"`) | Typ oczywisty — chyba że chcesz `Final` |

### 🟡 Szara strefa

| Sytuacja | Rekomendacja |
|----------|-------------|
| Prywatna helper <5 linii | Typuj parametry i return, pomiń zmienne lokalne |
| Test functions | Parametry = zależnie od fixture; return = `-> None` |
| Comprehensions | Nie typuj zmiennej iteracyjnej: `[x for x in items]` |
| Lambda | Nie typujesz inline. Jeśli potrzebujesz typów → `def` |

---
## Źródła

- [Python typing docs](https://docs.python.org/3/library/typing.html)
- [mypy docs](https://mypy.readthedocs.io/en/stable/)
- [PEP 484 — Type Hints](https://peps.python.org/pep-0484/)
- [PEP 604 — X | Y union syntax](https://peps.python.org/pep-0604/)
- [PEP 612 — ParamSpec](https://peps.python.org/pep-0612/)
- [PEP 544 — Protocols](https://peps.python.org/pep-0544/)
- [PEP 591 — Final](https://peps.python.org/pep-0591/)
- [PEP 586 — Literal](https://peps.python.org/pep-0586/)
- [PEP 613 — TypeAlias](https://peps.python.org/pep-0613/)
