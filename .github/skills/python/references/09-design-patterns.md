                                                                            # 09 — Design Patterns w Pythonie

> **Cel:** Kompletna mapa wzorców projektowych z perspektywy Pythona ≥3.10 — Pythonic idiomy zamiast portowania Javy.
> **Scope:** 23 wzorce GoF + 8 wzorców Pythonic/aplikacyjnych. Ranking częstości, tabele decyzyjne, ✅/❌ snippety.
> **Zasada nadrzędna:** W Pythonie funkcje, Protocol i composition zastępują 80% klasycznych wzorców GoF.

---

## Spis treści

1. [Filozofia — wzorce w Pythonie](#1-filozofia--wzorce-w-pythonie)
2. [Ranking częstości użycia](#2-ranking-częstości-użycia)
3. [Wzorce kreacyjne (Creational)](#3-wzorce-kreacyjne-creational)
4. [Wzorce strukturalne (Structural)](#4-wzorce-strukturalne-structural)
5. [Wzorce behawioralne (Behavioral)](#5-wzorce-behawioralne-behavioral)
6. [Wzorce Pythonic / aplikacyjne](#6-wzorce-pythonic--aplikacyjne)
7. [Antypatterny — nadużywanie wzorców](#7-antypatterny--nadużywanie-wzorców)
8. [Egzekucja ruff](#8-egzekucja-ruff)


## 📋 Quick Reference (ściąga)

| # | Reguła |
|---|--------|
| 1 | Python feature > GoF pattern — `yield` > Iterator class, `Callable` > Strategy class, `Protocol` > ABC |
| 2 | Callable zamiast klasy z jedną metodą — Strategy, Command, Factory |
| 3 | `Protocol` zamiast ABC — structural subtyping bez wymuszania inheritance |
| 4 | `@dataclass` + defaults zamiast Builder — keyword args = natywny builder |
| 5 | Module-level instance zamiast Singleton — moduł Python = naturalny singleton |
| 6 | `lru_cache(maxsize=1)` — najczystszy lazy singleton |
| 7 | `__init_subclass__` zamiast metaclass — Pythonic Registry |
| 8 | `functools.singledispatch` zamiast Visitor accept/visit — runtime dispatch |
| 9 | `match/case` + Enum zamiast State classes — proste FSM (≤5 stanów) |
| 10 | Context manager = Pythonic RAII — `@contextmanager` > klasa `__enter__`/`__exit__` |
| 11 | Generator pipeline > explicit Pipeline class — `yield from` + composable generators |
| 12 | Dict dispatch > if/elif chain — Strategy, Factory, State |
| 13 | `@functools.wraps` ZAWSZE na Python decoratorach — zachowuje `__name__`, `__doc__` |
| 14 | Adapter = Protocol + composition, bez ABC inheritance |
| 15 | Facade = moduł Python lub `__init__.py` re-export, bez klasy |
| 16 | DI = constructor injection z Protocol, bez frameworka (chyba że duży system) |
| 17 | NIGDY `eval()`/`exec()` — `ast.literal_eval()` lub `lark`/`pyparsing` |
| 18 | NIGDY Singleton metaclass — `lru_cache(1)` lub module-level |
| 19 | Wzorzec GoF ma sens dopiero gdy Pythonic alternatywa jest niewystarczająca |
| 20 | YAGNI — nie implementuj wzorca na 2 warianty |

---

> **Powiązane sekcje:**
> - `06-function-api-design.md` — Callable vs Protocol, `@overload`, factory classmethod
> - `07-class-protocol-design.md` — Protocol, ABC, composition vs inheritance, `@dataclass`
> - `02-type-hints.md` — `Callable`, `ParamSpec`, `TypeVar`, generics
> - `04-naming.md` — konwencje nazw klas wzorcowych (`Factory`, `Service`, `Repository`)

---

## 1. Filozofia — wzorce w Pythonie

### 1.1 Python ≠ Java

Peter Norvig (1998): **16 z 23 wzorców GoF jest uproszczonych lub zbędnych** w językach z first-class functions, duck typing i metaprogramowaniem. Python ma te feature'y natywnie.

| Feature Pythona | Zastępuje wzorzec GoF |
|-----------------|----------------------|
| First-class functions, `Callable` | Strategy, Command, Template Method (częściowo) |
| `Protocol` (structural subtyping) | Adapter (częściowo), Abstract Factory |
| Generators (`yield`, `yield from`) | Iterator |
| Decorators (`@functools.wraps`) | Decorator (GoF), Proxy (częściowo) |
| `match/case` | State (proste FSM), Visitor (częściowo) |
| `__init_subclass__` | Registry, Factory Method |
| `contextlib.contextmanager` | Template Method (resource variant) |
| `functools.singledispatch` | Visitor |
| Module-level instance | Singleton |
| `dataclasses.replace()` | Prototype |

### 1.2 Kiedy używać wzorca

| Sytuacja | Decyzja |
|----------|---------|
| Problem pasuje do wzorca GoF | Najpierw sprawdź Pythonic alternatywę |
| Pythonic alternatywa istnieje | Użyj jej — jest idiomatyczna i prostsza |
| Brak Pythonic alternatywy | Wzorzec GoF z type hints i Protocol |
| Wzorzec wymaga ABC hierarchy | Rozważ Protocol + composition zamiast |
| Ma ≤5 parametrów / 2-3 warianty | Za wcześnie na wzorzec — YAGNI |

### 1.3 Tabela decyzyjna: klasa vs callable

| Wzorzec ma… | Użyj klasy | Użyj callable |
|-------------|------------|---------------|
| Jedną metodę publiczną | ❌ | ✅ `Callable[..., R]` |
| Stan między wywołaniami | ✅ | ❌ (lub `functools.partial`) |
| Wiele metod | ✅ `Protocol` | ❌ |
| Lifecycle (init → use → cleanup) | ✅ context manager | ❌ |
| Potrzebuje `isinstance()` | ✅ `runtime_checkable Protocol` | ❌ |

---

## 2. Ranking częstości użycia

Posortowane od **najczęściej** do **najrzadziej** stosowanych w produkcyjnym kodzie Python.

> ℹ️ **Nota:** Ranking dotyczy **ogólnych produkcyjnych aplikacji** (web, ML, CLI, worker services). Specjalistyczne domeny (compilers, graphics, DSL) mogą preferować inne wzorce.

| Rank | Wzorzec | Częstość | Kategoria | Pythonic alternatywa |
|------|---------|----------|-----------|---------------------|
| 🥇 | **Iterator** | 10/10 | Behavioral | `yield`, generator expressions, `itertools` |
| 🥇 | **Context Manager** | 10/10 | Pythonic | `@contextmanager`, `ExitStack` |
| 🥈 | **Strategy** | 9/10 | Behavioral | `Callable`, dict dispatch |
| 🥈 | **Facade** | 9/10 | Structural | Moduł Python, `__init__.py` re-export |
| 🥉 | **Observer** | 8/10 | Behavioral | `blinker`, Django signals |
| 🥉 | **Adapter** | 8/10 | Structural | Protocol + composition |
| 🥉 | **Registry** | 8/10 | Pythonic | `__init_subclass__`, entry points |
| 🥉 | **Dependency Injection** | 8/10 | Pythonic | Constructor injection, `Depends()` |
| 🥉 | **Pipeline** | 8/10 | Pythonic | Generator chain, `functools.reduce` |
| 4 | **Builder** | 7/10 | Creational | `@dataclass` + defaults, `**kwargs` |
| 4 | **Decorator (GoF)** | 7/10 | Structural | `@decorator` syntax, `__getattr__` |
| 4 | **Proxy** | 7/10 | Structural | `@property`, `@cached_property`, `__getattr__` |
| 4 | **Chain of Responsibility** | 7/10 | Behavioral | Lista callables, middleware stack |
| 4 | **Template Method** | 7/10 | Behavioral | ABC + hooks, composition |
| 4 | **Plugin / Hook** | 7/10 | Pythonic | `pluggy`, entry points |
| 5 | **Composite** | 6/10 | Structural | Recursive `list[Self]`, nested dict |
| 5 | **Command** | 6/10 | Behavioral | `functools.partial`, callable |
| 5 | **Repository** | 6/10 | Pythonic | Protocol + ORM session |
| 6 | **Flyweight** | 5/10 | Structural | `__slots__`, `sys.intern`, `lru_cache` |
| 6 | **Object Pool** | 5/10 | Creational | `Queue`, `ThreadPoolExecutor` |
| 6 | **State** | 5/10 | Behavioral | `match/case` + Enum |
| 6 | **Mediator** | 5/10 | Behavioral | Event bus, `asyncio.Queue` |
| 6 | **Unit of Work** | 5/10 | Pythonic | Context manager, SQLAlchemy Session |
| 7 | **Factory Method** | 4/10 | Creational | Dict dispatch, `type[T]` callable |
| 7 | **Bridge** | 4/10 | Structural | DI constructor, Protocol |
| 7 | **Visitor** | 4/10 | Behavioral | `singledispatch`, `match/case` |
| 7 | **Null Object** | 4/10 | Pythonic | `NullHandler`, `nullcontext()` |
| 8 | **Memento** | 3/10 | Behavioral | `copy.deepcopy`, `dataclasses.replace` |
| 9 | **Abstract Factory** | 2/10 | Creational | Callable injection, `@dataclass` family |
| 9 | **Prototype** | 2/10 | Creational | `dataclasses.replace()`, `copy.copy()` |
| 9 | **Interpreter** | 2/10 | Behavioral | `ast`, `match/case`, `lark`/`pyparsing` |
| 9 | **Monostate / Borg** | 2/10 | Creational | Module-level state |
| 10 | **Singleton** | 1/10 | Creational | ⚠️ **Anti-pattern** — module-level instance |

---

## 3. Wzorce kreacyjne (Creational)

### 3.1 Factory Method — `type[T]` jako callable

| Pole | Wartość |
|------|---------|
| Częstość | 4/10 |
| Opis | Definiuje interfejs tworzenia obiektów — podklasy/callables decydują co stworzyć |
| Kiedy | Plugin architectures, konfigurowalny typ tworzonych obiektów |
| Kiedy NIE | Mało wariantów (dict dispatch wystarczy), klasy i funkcje to first-class objects |

```python
# ❌ GoF — niepotrzebna hierarchia klas
class Creator(ABC):
    @abstractmethod
    def factory_method(self) -> Product: ...

class ConcreteCreator(Creator):
    def factory_method(self) -> Product:
        return ConcreteProduct()

# ✅ Pythonic — callable/dict dispatch
from typing import TypeAlias

ProductFactory: TypeAlias = Callable[..., Product]

FACTORIES: dict[str, type[Product]] = {
    "manga": MangaProduct,
    "webtoon": WebtoonProduct,
}

def create(kind: str) -> Product:
    return FACTORIES[kind]()
```

> **Real-world:** SQLAlchemy `sessionmaker(bind=engine)`, pytest `tmp_path_factory`, Click `@click.command()`.

### 3.2 Abstract Factory — callable injection

| Pole | Wartość |
|------|---------|
| Częstość | 2/10 |
| Opis | Produkuje rodziny powiązanych obiektów bez specyfikowania concrete classes |
| Kiedy | Cross-platform UI toolkit, spójna rodzina obiektów |
| Kiedy NIE | Brandon Rhodes: „awkward workaround for lack of first-class functions" — w Pythonie przekaż callables |

```python
# ❌ GoF — osobna klasa na każdą rodzinę
class AbstractFactory(ABC):
    @abstractmethod
    def create_button(self) -> Button: ...
    @abstractmethod
    def create_checkbox(self) -> Checkbox: ...

# ✅ Pythonic — dataclass z type callables
@dataclass(frozen=True)
class UIKit:
    button: type[Button] = MacButton
    checkbox: type[Checkbox] = MacCheckbox

def build_ui(kit: UIKit = UIKit()) -> None:
    btn = kit.button(label="OK")
    chk = kit.checkbox(checked=True)
```

> **Real-world:** Django `DATABASES` backend, SQLAlchemy `create_engine()` dialect family, `json.loads(parse_float=Decimal)`.

### 3.3 Builder — `@dataclass` + defaults

| Pole | Wartość |
|------|---------|
| Częstość | 7/10 |
| Opis | Konstruuje złożone obiekty krok po kroku — fluent API |
| Kiedy | ≥6 opcjonalnych parametrów, budowa wielokrokowa (query, pipeline config) |
| Kiedy NIE | ≤5 parametrów (`@dataclass` wystarczy), Brandon Rhodes: „degenerate builder is never needed in Python" (`**kwargs`) |

```python
# ❌ GoF — degenerate builder (zbędny w Pythonie)
class QueryBuilder:
    def __init__(self) -> None:
        self._table = ""
        self._where: list[str] = []

    def table(self, t: str) -> "QueryBuilder":
        self._table = t
        return self

    def where(self, w: str) -> "QueryBuilder":
        self._where.append(w)
        return self

    def build(self) -> str:
        return f"SELECT * FROM {self._table} WHERE {' AND '.join(self._where)}"

# ✅ Pythonic — dataclass + factory classmethod
@dataclass(frozen=True)
class Query:
    table: str
    where: tuple[str, ...] = ()
    limit: int | None = None

    @classmethod
    def from_params(cls, table: str, **filters: str) -> "Query":
        """Factory classmethod jako alternatywa buildera."""
        conditions = tuple(f"{k}={v!r}" for k, v in filters.items())
        return cls(table=table, where=conditions)
```

> **Uzasadniony Builder:** Gdy API wymaga fluent chaining — SQLAlchemy `select(User).where(...).order_by(...)`, matplotlib, httpx `Client(base_url=..., headers=..., timeout=...)`.

> **Real-world:** SQLAlchemy query builder, matplotlib `figure().add_subplot().plot()`, Pydantic `ConfigDict`.

### 3.4 Prototype — `dataclasses.replace()`

| Pole | Wartość |
|------|---------|
| Częstość | 2/10 |
| Opis | Kopiuje istniejące obiekty bez uzależniania od ich klas |
| Kiedy | Tworzenie wariantów kosztownego obiektu, snapshot + modyfikacja |
| Kiedy NIE | `dataclasses.replace()` + `copy.copy()` pokrywają 99% przypadków — nie buduj infra na `clone()` |

```python
# ❌ GoF — dedykowana metoda clone
class Prototype(ABC):
    @abstractmethod
    def clone(self) -> "Prototype": ...

# ✅ Pythonic — stdlib replace/copy
from dataclasses import dataclass, replace

@dataclass(frozen=True)
class PipelineConfig:
    model: str = "default"
    batch_size: int = 8
    device: str = "cuda"

base = PipelineConfig()
cpu_config = replace(base, device="cpu", batch_size=1)
```

> **Real-world:** `dataclasses.replace()` (PEP 557), Pydantic `model.model_copy(update={...})`, Django `queryset._clone()`.

### 3.5 Singleton — ⚠️ anti-pattern

| Pole | Wartość |
|------|---------|
| Częstość | 1/10 — **anti-pattern** |
| Opis | Zapewnia jedną instancję klasy z globalnym dostępem |
| Kiedy | Prawie NIGDY — faif/python-patterns przeniosło go do „Anti-Patterns" |
| Kiedy NIE | ZAWSZE rozważ alternatywę. Utrudnia testowanie, łamie SRP, tight coupling |

```python
# ❌ NIGDY — metaclass singleton
class SingletonMeta(type):
    _instances: dict[type, object] = {}
    def __call__(cls, *args: object, **kwargs: object) -> object:
        if cls not in cls._instances:
            cls._instances[cls] = super().__call__(*args, **kwargs)
        return cls._instances[cls]

# ✅ Pythonic — module-level instance
# config.py — moduł Pythona to naturalny singleton (importowany raz)
_settings: Settings | None = None

def get_settings() -> Settings:
    global _settings
    if _settings is None:
        _settings = Settings.from_env()
    return _settings
```

> **Jeszcze lepiej:** `functools.lru_cache(maxsize=1)` na factory function — lazy singleton bez `global`.

```python
# ✅ Najczystszy Pythonic singleton
from functools import lru_cache

@lru_cache(maxsize=1)
def get_settings() -> Settings:
    return Settings.from_env()
```

> **Real-world:** `logging.getLogger(name)` (cache per name), Django `settings` module, Python `None`/`True`/`False`.

### 3.6 Object Pool — `Queue` + context manager

> ℹ️ Nie jest wzorcem GoF — to dodatkowy wzorzec kreacyjny szeroko stosowany w praktyce.

| Pole | Wartość |
|------|---------|
| Częstość | 5/10 |
| Opis | Reużywanie kosztownych obiektów zamiast create/destroy |
| Kiedy | DB connections, thread workers, GPU contexts — kosztowna inicjalizacja |
| Kiedy NIE | Tanie obiekty (dataclass, DTO) — pool dodaje complexity bez zysku |

```python
# ✅ Pythonic — Queue + contextmanager
from queue import Queue
from contextlib import contextmanager
from collections.abc import Generator

@contextmanager
def pooled(pool: Queue[T]) -> Generator[T]:
    obj = pool.get()
    try:
        yield obj
    finally:
        pool.put(obj)

# Użycie
with pooled(connection_pool) as conn:
    conn.execute("SELECT 1")
```

> **Real-world:** `concurrent.futures.ThreadPoolExecutor`, SQLAlchemy `create_engine(pool_size=5)`, httpx `AsyncClient()` connection pooling.

### 3.7 Monostate / Borg — ⚠️ anti-pattern

> ℹ️ Nie jest wzorcem GoF — to Pythonowa alternatywa Singletona (Alex Martelli).

| Pole | Wartość |
|------|---------|
| Częstość | 2/10 — **anti-pattern** |
| Opis | Wszystkie instancje współdzielą stan (`__dict__`), ale są osobnymi obiektami |
| Kiedy | Prawie NIGDY — te same problemy co Singleton (tight coupling, global state) |
| Kiedy NIE | ZAWSZE rozważ module-level state lub `lru_cache(1)` |

```python
# ❌ NIGDY — Borg/Monostate (shared __dict__)
class Borg:
    _shared: dict[str, object] = {}
    def __init__(self) -> None:
        self.__dict__ = self._shared

# ✅ Pythonic — module-level state (to samo, ale jawne i proste)
# config.py
_state: dict[str, object] = {}

def get(key: str) -> object:
    return _state[key]

def set_value(key: str, value: object) -> None:
    _state[key] = value
```

> **Dlaczego anti-pattern?** Shared mutable state + utrudnia testowanie (ten sam problem co Singleton). Module-level dict jest przynajmniej jawne.

---

## 4. Wzorce strukturalne (Structural)

### 4.1 Adapter — Protocol + composition

| Pole | Wartość |
|------|---------|
| Częstość | 8/10 |
| Opis | Opakowuje obiekt z niekompatybilnym interfejsem tak, by pasował do oczekiwanego `Protocol` |
| Kiedy | Integracja z legacy API, third-party library wrapping, ujednolicanie interfejsów |
| Kiedy NIE | Oba interfejsy pod twoją kontrolą (zunifikuj je), adapter >5 metod (rozważ Bridge) |

```python
# ❌ Java-like — niepotrzebne ABC
class AbstractTranslator(ABC):
    @abstractmethod
    def translate(self, text: str, target_lang: str) -> str: ...

class GoogleAdapter(AbstractTranslator):
    ...

# ✅ Pythonic — Protocol + duck typing
class Translator(Protocol):
    def translate(self, text: str, target_lang: str) -> str: ...

class GoogleAdapter:
    """Adapts LegacyGoogleAPI to Translator Protocol."""

    def __init__(self, api: LegacyGoogleAPI) -> None:
        self._api = api

    def translate(self, text: str, target_lang: str) -> str:
        return self._api.translate_text("auto", target_lang, text)

def process(translator: Translator) -> None:
    result = translator.translate("こんにちは", "pl")
```

> **Prosty adapter = funkcja**, nie klasa:

```python
# ✅ Adapter jako funkcja (gdy wystarczy 1 metoda)
def adapt_legacy(api: LegacyGoogleAPI) -> Callable[[str, str], str]:
    return lambda text, lang: api.translate_text("auto", lang, text)
```

> **Real-world:** Django `DatabaseWrapper` (backend adaptery), httpx `Transport`, `logging.handlers.SocketHandler`, `socket.makefile()`.

### 4.2 Bridge — Protocol + DI

| Pole | Wartość |
|------|---------|
| Częstość | 4/10 |
| Opis | Oddziela abstrakcję od implementacji — dwie niezależne osie zmienności |
| Kiedy | m×n kombinacji (shape × renderer), wymienność backend w runtime, cross-platform code |
| Kiedy NIE | Jedna oś zmienności (zwykła composition), abstrakcja i implementacja nie zmieniają się niezależnie |

```python
# ✅ Pythonic — Protocol jako implementation interface
class StorageBackend(Protocol):
    def save(self, key: str, data: bytes) -> None: ...
    def load(self, key: str) -> bytes: ...

class ImageProcessor:
    """Abstraction — niezależna od storage."""

    def __init__(self, storage: StorageBackend) -> None:
        self._storage = storage

    def process_and_save(self, key: str, image: bytes) -> None:
        result = self._transform(image)
        self._storage.save(key, result)
```

> **Real-world:** Python `logging` (Logger abstraction + Handler implementation), SQLAlchemy (Engine + Dialect).

### 4.3 Composite — recursive `list[Self]`

| Pole | Wartość |
|------|---------|
| Częstość | 6/10 |
| Opis | Drzewiasta struktura — leaf i container mają ten sam interfejs |
| Kiedy | Drzewa: menu, filesystem, AST, UI components, pipeline DAG |
| Kiedy NIE | Struktura płaska (lista wystarczy), leaf i composite mają zupełnie różne API |

```python
# ❌ Java-like — osobne klasy Leaf/Composite + ABC
class Component(ABC):
    @abstractmethod
    def total_price(self) -> float: ...

class Leaf(Component):
    ...

class CompositeItem(Component):
    _children: list[Component]
    ...

# ✅ Pythonic — jedna klasa, recursive children
from __future__ import annotations

@dataclass
class MenuItem:
    name: str
    price: float
    children: list[MenuItem] = field(default_factory=list)

    def total_price(self) -> float:
        if not self.children:
            return self.price
        return sum(c.total_price() for c in self.children)

    def add(self, item: MenuItem) -> None:
        self.children.append(item)
```

> **Real-world:** Django `Q` objects (`Q(a=1) | Q(b=2)`), Click `Group`/`Command`, `ast.Module` tree, pytest collection hierarchy.

### 4.4 Decorator (GoF) vs Python `@decorator`

> ⚠️ **To NIE jest to samo!**

| | GoF Decorator Pattern | Python `@decorator` syntax |
|--|----------------------|---------------------------|
| **Co to** | Wrapper **klasa** z tym samym interfejsem | **Funkcja** modyfikująca inną funkcję/klasę |
| **Mechanizm** | Composition (wraps object) | Higher-order function |
| **Geneza** | 1994, Gang of Four | 2004, Python 2.4 (PEP 318) |

| Pole | Wartość |
|------|---------|
| Częstość | 7/10 (obie formy łącznie) |
| Opis | Dynamicznie dodaje behavior do obiektu/funkcji bez modyfikacji oryginału |
| Kiedy | Stackowalne modyfikacje (logging + caching + auth), behavior na obiekcie którego klasy nie kontrolujesz |
| Kiedy NIE | Kontrolujesz klasę bazową (rozszerz ją), <2 warianty (over-engineering) |

**GoF Decorator — wrapper class z `__getattr__`:**

```python
# ✅ Dynamic wrapper
class LoggingWrapper:
    """GoF Decorator: loguje dostęp do atrybutów."""

    def __init__(self, wrapped: object) -> None:
        self._wrapped = wrapped

    def __getattr__(self, name: str) -> object:
        logger.debug(f"Accessing {name} on {type(self._wrapped).__name__}")
        return getattr(self._wrapped, name)

# Stackowanie:
service = LoggingWrapper(AuthWrapper(RealService()))
```

**Python `@decorator` — higher-order function:**

```python
# ✅ Python decorator syntax (NIE GoF pattern)
import functools
from typing import Callable, ParamSpec, TypeVar

P = ParamSpec("P")
R = TypeVar("R")

def log_calls(func: Callable[P, R]) -> Callable[P, R]:
    @functools.wraps(func)  # ZAWSZE — zachowuje __name__, __doc__
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> R:
        logger.debug(f"Calling {func.__name__}")
        return func(*args, **kwargs)
    return wrapper

@log_calls
def process_document(data: np.ndarray) -> list[Region]:
    ...
```

> **Real-world GoF:** `io.BufferedReader(io.FileIO(...))`, Django middleware stack, `logging.Filter`.
> **Real-world @decorator:** `@functools.lru_cache`, `@pytest.fixture`, `@app.get("/")` (FastAPI), `@property`.

### 4.5 Facade — moduł Python

| Pole | Wartość |
|------|---------|
| Częstość | 9/10 |
| Opis | Uproszczony interfejs do złożonego podsystemu |
| Kiedy | Ukrycie złożoności subsystemu, SDK/library entry point, refactoring legacy kodu |
| Kiedy NIE | Facade staje się god class, subsystem jest już prosty |

```python
# ✅ Pythonic — moduł jako Facade (nawet nie klasa!)
# myapp/api/process.py
"""Facade: jeden import, jedna funkcja, zero wiedzy o internals."""

from myapp.services.parser import ParserService
from myapp.services.processor import ProcessorService
from myapp.services.renderer import RenderService

def process_page(input_path: str, target_lang: str = "pl") -> bytes:
    """Facade: parse → process → render w jednym wywołaniu."""
    regions = ParserService().extract(input_path)
    processed = ProcessorService().process(regions, target_lang)
    return RenderService().render(input_path, processed)
```

```python
# ✅ __init__.py re-export jako Facade
# myapp/__init__.py
from myapp.api.process import process_page
from myapp.api.analyze import analyze_document

__all__ = ["process_page", "analyze_document"]
```

> **Real-world:** `requests` (facade na urllib3 + cookies + SSL), FastAPI `FastAPI()`, Pydantic `BaseModel`, Click `@click.command()`.

### 4.6 Flyweight — `__slots__` + intern

| Pole | Wartość |
|------|---------|
| Częstość | 5/10 |
| Opis | Współdzielenie wspólnych danych między wieloma obiektami — oszczędność RAM |
| Kiedy | Tysiące+ obiektów o wspólnych danych (rendered glyphs, tile map, particle system) |
| Kiedy NIE | Mało obiektów (premature optimization), obiekty są mutable |

```python
# ✅ Pythonic — __new__ z cache + __slots__
class Glyph:
    __slots__ = ("char", "font", "size")
    _cache: dict[tuple[str, str, int], "Glyph"] = {}

    def __new__(cls, char: str, font: str, size: int) -> "Glyph":
        key = (char, font, size)
        if key not in cls._cache:
            instance = super().__new__(cls)
            instance.char = char
            instance.font = font
            instance.size = size
            cls._cache[key] = instance
        return cls._cache[key]

# Python sam stosuje Flyweight:
assert True is bool(1)           # bool — 2 instancje
assert 42 is (41 + 1)            # int (-5..256) — pre-cached
assert () is tuple()             # empty tuple — singleton
```

> **Real-world:** Python int cache (-5..256), `sys.intern()`, `enum.Enum` (jedna instancja per wartość), SQLAlchemy identity map.

### 4.7 Proxy — `@property` + `__getattr__`

| Pole | Wartość |
|------|---------|
| Częstość | 7/10 |
| Opis | Zastępnik obiektu kontrolujący dostęp — lazy loading, caching, access control, logging |
| Kiedy | Lazy init ciężkiego obiektu (model ML), caching, remote proxy (RPC stub), logging proxy |
| Kiedy NIE | Prosty obiekt (overhead > benefit), `__getattr__` zamazuje stacktrace |

```python
# ✅ Lazy proxy — odkłada ciężką inicjalizację
class LazyModel:
    """Proxy: ładuje model ML dopiero przy pierwszym użyciu."""

    def __init__(self, model_path: str) -> None:
        self._model_path = model_path
        self._model: HeavyModel | None = None

    def _load(self) -> HeavyModel:
        if self._model is None:
            self._model = load_heavy_model(self._model_path)
        return self._model

    def __getattr__(self, name: str) -> object:
        return getattr(self._load(), name)
```

```python
# ✅ Micro-proxy — @cached_property
import functools

class AppConfig:
    @functools.cached_property
    def db_engine(self) -> Engine:
        """Lazy-loaded, cached po pierwszym dostępie."""
        return create_engine(self.database_url)
```

> **Real-world:** Django `QuerySet` (lazy SQL), SQLAlchemy `LazyLoader` (relacje), `weakref.proxy()`, `unittest.mock.MagicMock`, Celery `AsyncResult`.

---

## 5. Wzorce behawioralne (Behavioral)

### 5.1 Iterator — `yield` + `itertools`

| Pole | Wartość |
|------|---------|
| Częstość | **10/10** — najczęstszy wzorzec w Pythonie |
| Opis | Sekwencyjne przechodzenie elementów bez ujawniania implementacji |
| Kiedy | Lazy evaluation, streaming, niestandardowy traversal |
| Kiedy NIE | Random access (użyj `__getitem__`), dane w pamięci + wielokrotna iteracja (lista) |

```python
# ✅ Generator function — najczęstszy sposób
from collections.abc import Iterator

def read_pages(manga_path: Path) -> Iterator[np.ndarray]:
    """Lazy loading stron mangi — nie ładuje wszystkich do RAM."""
    for page_file in sorted(manga_path.glob("*.png")):
        yield cv2.imread(str(page_file))

# ✅ yield from — delegacja do sub-iteratora
def flatten(nested: list[list[T]]) -> Iterator[T]:
    for sublist in nested:
        yield from sublist

# ✅ Generator expression — one-liner
total = sum(page.size for page in read_pages(path))
```

```python
# ❌ Java-like — klasa z __iter__/__next__ (rzadko potrzebna)
class PageIterator:
    def __init__(self, pages: list[Page]) -> None:
        self._pages = pages
        self._index = 0

    def __iter__(self) -> "PageIterator":
        return self

    def __next__(self) -> Page:
        if self._index >= len(self._pages):
            raise StopIteration
        page = self._pages[self._index]
        self._index += 1
        return page
```

> **Real-world:** `itertools` (chain, islice, groupby), Django QuerySets (lazy), `csv.reader`, `pathlib.Path.iterdir()`, `map()`, `filter()`.

### 5.2 Strategy — `Callable` + dict dispatch

| Pole | Wartość |
|------|---------|
| Częstość | **9/10** |
| Opis | Rodzina wymiennych algorytmów — klient wybiera w runtime |
| Kiedy | Wymienne algorytmy (hashing, kompresja, serialization), konfigurowalny retry/backoff |
| Kiedy NIE | Jeden algorytm na zawsze (YAGNI), 2 opcje z prostym `if/else` |

```python
# ❌ Java-style — klasa per strategia
class HashStrategy(ABC):
    @abstractmethod
    def hash(self, data: bytes) -> str: ...

class MD5Strategy(HashStrategy):
    def hash(self, data: bytes) -> str:
        return hashlib.md5(data).hexdigest()

# ✅ Pythonic way 1: Callable (najczęściej!)
from typing import TypeAlias

Hasher: TypeAlias = Callable[[bytes], str]

def process(data: bytes, algo: str = "sha256") -> str:
    return hashlib.new(algo, data).hexdigest()

# ✅ Pythonic way 2: Protocol (gdy strategia ma >1 metodę)
class Serializer(Protocol):
    def serialize(self, data: object) -> bytes: ...
    def deserialize(self, raw: bytes) -> object: ...
```

> **Dict dispatch — Strategy bez if/elif:**

```python
# ✅ Dict dispatch
STRATEGIES: dict[str, Callable[[bytes], str]] = {
    "md5": lambda d: hashlib.md5(d).hexdigest(),
    "sha256": lambda d: hashlib.sha256(d).hexdigest(),
}

def hash_data(data: bytes, algo: str = "sha256") -> str:
    return STRATEGIES[algo](data)
```

> **Real-world:** `sorted(key=...)`, `json.dumps(default=...)`, `hashlib.new(name)`, `logging.Formatter`.

### 5.3 Observer — callback list + signals

| Pole | Wartość |
|------|---------|
| Częstość | 8/10 |
| Opis | Mechanizm subskrypcji — powiadamia wielu słuchaczy o zdarzeniach |
| Kiedy | Event system, reactive UI, pub/sub, decoupling modułów |
| Kiedy NIE | Kolejność powiadomień krytyczna i trudna do kontroli, 1 observer (direct callback) |

```python
# ✅ Pythonic — prosty callback list
from collections import defaultdict
from typing import Any, Callable

class EventEmitter:
    def __init__(self) -> None:
        self._listeners: dict[str, list[Callable[..., Any]]] = defaultdict(list)

    def on(self, event: str, fn: Callable[..., Any]) -> None:
        self._listeners[event].append(fn)

    def emit(self, event: str, *args: Any, **kw: Any) -> None:
        for fn in self._listeners[event]:
            fn(*args, **kw)
```

```python
# ✅ Production-grade — blinker
from blinker import signal

page_processed = signal("page-processed")

@page_processed.connect
def log_processing(sender: Any, **kw: Any) -> None:
    logger.info(f"Processed page {kw['page_num']}")

# Emit z dowolnego miejsca w kodzie:
page_processed.send(self, page_num=42, lang="pl")
```

> **Real-world:** Django `signals` (`post_save`, `pre_delete`), Flask `blinker`, `asyncio.Event`, SQLAlchemy event system.

### 5.4 Chain of Responsibility — middleware stack

| Pole | Wartość |
|------|---------|
| Częstość | 7/10 |
| Opis | Request przechodzi przez łańcuch handlerów — każdy obsługuje lub deleguje dalej |
| Kiedy | Middleware (ASGI/WSGI), walidacja wieloetapowa, logging z fallback |
| Kiedy NIE | Zawsze wiadomo, który handler obsłuży (direct dispatch), chain = 1 handler |

```python
# ✅ Pythonic — lista callables zamiast linked list
from typing import Any, Callable, TypeAlias

Handler: TypeAlias = Callable[[Any], Any | None]

def chain(*handlers: Handler) -> Handler:
    """Uruchamia handlery po kolei aż jeden zwróci wynik."""
    def dispatch(request: Any) -> Any | None:
        for handler in handlers:
            if (result := handler(request)) is not None:
                return result
        return None
    return dispatch

# Użycie
result = chain(auth_check, rate_limit, process)(request)
```

> **Real-world:** Django `MIDDLEWARE` stack, Python `logging` (handler propagation), ASGI middleware chain.

### 5.5 Template Method — ABC + hooks

| Pole | Wartość |
|------|---------|
| Częstość | 7/10 |
| Opis | Szkielet algorytmu w nadklasie — podklasy override'ują kroki |
| Kiedy | Framework hooks (setup/teardown), ETL pipelines, test fixtures |
| Kiedy NIE | Composition (Strategy) daje lepszy decoupling, override >50% kroków, hierarchy >2 levels |

```python
# ✅ Pythonic — ABC z template + hooks
from abc import ABC, abstractmethod

class DataPipeline(ABC):
    def run(self, source: str) -> list[dict[str, str]]:
        """Template method — NIE override'uj."""
        raw = self.extract(source)
        clean = self.transform(raw)
        return self.validate(clean)

    @abstractmethod
    def extract(self, source: str) -> list[dict[str, str]]: ...

    @abstractmethod
    def transform(self, data: list[dict[str, str]]) -> list[dict[str, str]]: ...

    def validate(self, data: list[dict[str, str]]) -> list[dict[str, str]]:
        """Hook — domyślna implementacja, override opcjonalny."""
        return [d for d in data if d]
```

> **Real-world:** `unittest.TestCase` (`setUp`/`tearDown`), Django `View.dispatch()` → `get()`/`post()`, `http.server.BaseHTTPRequestHandler`.

### 5.6 Command — `functools.partial`

| Pole | Wartość |
|------|---------|
| Częstość | 6/10 |
| Opis | Enkapsuluje request jako obiekt — undo/redo, queue, macro |
| Kiedy | Undo/redo system, task queue (Celery), macro recording |
| Kiedy NIE | Proste wywołanie (bez undo/queue), `functools.partial` wystarczy |

```python
# ✅ Pythonic — Protocol + dataclass (gdy potrzebny undo)
class Command(Protocol):
    def execute(self) -> None: ...
    def undo(self) -> None: ...

@dataclass
class InsertText:
    doc: list[str]
    pos: int
    text: str

    def execute(self) -> None:
        self.doc.insert(self.pos, self.text)

    def undo(self) -> None:
        self.doc.pop(self.pos)

# ✅ Prostsza alternatywa (bez undo) — callable
from functools import partial
cmd = partial(translate_text, text="hello", target="pl")
cmd()  # wywołanie odroczone
```

> **Real-world:** Celery tasks (`@app.task`), Django management commands, GUI action binding.

### 5.7 State — `match/case` + Enum

| Pole | Wartość |
|------|---------|
| Częstość | 5/10 |
| Opis | Obiekt zmienia zachowanie gdy zmienia się stan — wygląda jakby zmienił klasę |
| Kiedy | Finite state machines (order processing, protocol handlers), workflow engines |
| Kiedy NIE | ≤3 stany (`match/case` wystarczy), stany bez różnego zachowania (to Enum, nie State) |

```python
# ✅ Pythonic — match/case + Enum (proste FSM)
from enum import Enum, auto

class OrderStatus(Enum):
    PENDING = auto()
    SHIPPED = auto()
    DELIVERED = auto()
    CANCELLED = auto()

def process_order(status: OrderStatus) -> OrderStatus:
    match status:
        case OrderStatus.PENDING:
            return OrderStatus.SHIPPED
        case OrderStatus.SHIPPED:
            return OrderStatus.DELIVERED
        case OrderStatus.DELIVERED | OrderStatus.CANCELLED:
            raise ValueError(f"Cannot process order in state {status}")
```

```python
# ✅ Protocol-based State (złożone FSM z wieloma akcjami)
class OrderState(Protocol):
    def process(self, order: "Order") -> None: ...
    def cancel(self, order: "Order") -> None: ...

class Pending:
    def process(self, order: "Order") -> None:
        order.state = Shipped()

    def cancel(self, order: "Order") -> None:
        order.state = Cancelled()

class Shipped:
    def process(self, order: "Order") -> None:
        raise ValueError("Already shipped")

    def cancel(self, order: "Order") -> None:
        raise ValueError("Cannot cancel shipped order")
```

> **Real-world:** `asyncio` connection states, `http.client` HTTPResponse, `transitions` library.

### 5.8 Mediator — event bus

| Pole | Wartość |
|------|---------|
| Częstość | 5/10 |
| Opis | Centralizuje komunikację między obiektami — redukuje coupling |
| Kiedy | Chat room / message broker, orkiestracja wielu serwisów, GUI widgets |
| Kiedy NIE | Mediator staje się god object, 1:1 zależność (direct injection), Observer wystarczy |

```python
# ✅ Pythonic — event bus z typed events
from collections import defaultdict
from typing import Any, Callable
from dataclasses import dataclass

@dataclass(frozen=True)
class PageProcessed:
    page_num: int
    lang: str

@dataclass(frozen=True)
class ParseCompleted:
    page_num: int
    text: str

class EventBus:
    """Prosty Mediator — komponenty nie znają się nawzajem."""

    def __init__(self) -> None:
        self._handlers: dict[type, list[Callable[..., None]]] = defaultdict(list)

    def subscribe(self, event_type: type, handler: Callable[..., None]) -> None:
        self._handlers[event_type].append(handler)

    def publish(self, event: object) -> None:
        for handler in self._handlers[type(event)]:
            handler(event)

# Użycie — zero direct coupling między komponentami
bus = EventBus()
bus.subscribe(PageTranslated, lambda e: logger.info(f"Page {e.page_num}"))
bus.publish(PageTranslated(page_num=1, lang="pl"))
```

> **Real-world:** Django `signals` (de facto mediator), `asyncio` event loop, message brokers (RabbitMQ, Redis pub/sub).

### 5.9 Visitor — `singledispatch`

| Pole | Wartość |
|------|---------|
| Częstość | 4/10 |
| Opis | Separuje algorytmy od obiektów — nowa operacja bez modyfikacji klas |
| Kiedy | AST traversal, export do wielu formatów, analiza statyczna |
| Kiedy NIE | Hierarchia zmienia się często, `match/case` wystarczy |

```python
# ❌ GoF — accept/visit double dispatch
class Node(ABC):
    @abstractmethod
    def accept(self, visitor: "Visitor") -> None: ...

# ✅ Pythonic — functools.singledispatch
from functools import singledispatch
from typing import TypeAlias

class IntNode:
    def __init__(self, value: int) -> None:
        self.value = value

class AddNode:
    def __init__(self, left: "Node", right: "Node") -> None:
        self.left = left
        self.right = right

Node: TypeAlias = IntNode | AddNode

@singledispatch
def evaluate(node: Node) -> int:
    raise TypeError(f"Unknown node: {type(node)}")

@evaluate.register
def _(node: IntNode) -> int:
    return node.value

@evaluate.register
def _(node: AddNode) -> int:
    return evaluate(node.left) + evaluate(node.right)
```

> **Real-world:** `ast.NodeVisitor` / `ast.NodeTransformer`, `docutils`, mypy type checker visitors.

### 5.10 Memento — `copy.deepcopy`

| Pole | Wartość |
|------|---------|
| Częstość | 3/10 |
| Opis | Snapshot stanu obiektu z możliwością przywrócenia |
| Kiedy | Undo/redo, checkpoint/rollback |
| Kiedy NIE | Kosztowny deep copy (diff-based approach), proste wartości (kopia zmiennej) |

```python
# ✅ Pythonic — copy + dataclass
import copy

@dataclass
class EditorState:
    content: str
    cursor: int

class Editor:
    def __init__(self) -> None:
        self._state = EditorState("", 0)
        self._history: list[EditorState] = []

    def save(self) -> None:
        self._history.append(copy.deepcopy(self._state))

    def undo(self) -> None:
        if self._history:
            self._state = self._history.pop()
```

> **Real-world:** `pickle` (serializacja stanu), `__getstate__`/`__setstate__`, Django `Model` save with `update_fields`.

### 5.11 Interpreter — `ast` + `match/case`

| Pole | Wartość |
|------|---------|
| Częstość | 2/10 |
| Opis | Definiuje gramatykę i interpreter do przetwarzania wyrażeń |
| Kiedy | DSL, expression evaluation engine |
| Kiedy NIE | Złożone gramatyki (użyj `lark`, `pyparsing`), prosty pattern matching |

```python
# ✅ Pythonic — ast + match/case
import ast
import operator

OPS = {ast.Add: operator.add, ast.Sub: operator.sub,
       ast.Mult: operator.mul, ast.Div: operator.truediv}

def safe_eval(expr: str) -> float:
    """Bezpieczna ewaluacja wyrażeń — NIGDY eval()."""
    tree = ast.parse(expr, mode="eval")

    def _eval(node: ast.expr) -> float:
        match node:
            case ast.Constant(value=v) if isinstance(v, int | float):
                return float(v)
            case ast.BinOp(left=l, op=op, right=r):
                return OPS[type(op)](_eval(l), _eval(r))
            case _:
                raise ValueError(f"Unsupported: {ast.dump(node)}")

    return _eval(tree.body)
```

> ⚠️ **NIGDY `eval()` / `exec()`** — ruff `S307` / `S102`.

> **Real-world:** `ast.literal_eval()`, SQLAlchemy expression language, `lark` parser.

---

## 6. Wzorce Pythonic / aplikacyjne

### 6.1 Context Manager — `@contextmanager`

| Pole | Wartość |
|------|---------|
| Częstość | **10/10** — ex aequo z Iterator |
| Opis | Resource acquisition/release z gwarancją cleanup — Pythonowy RAII |
| Kiedy | Pliki, połączenia, locki, transakcje, timing, tymczasowe zmiany stanu |
| Kiedy NIE | Brak cleanup logic, resource lifecycle ≠ scope bloku `with` |

```python
# ✅ Dekorator @contextmanager — najczęstszy sposób
from contextlib import contextmanager
from collections.abc import Iterator

@contextmanager
def timer(label: str) -> Iterator[None]:
    start = time.perf_counter()
    try:
        yield
    finally:
        elapsed = time.perf_counter() - start
        logger.info(f"{label}: {elapsed:.3f}s")

# ✅ Klasa z __enter__/__exit__ (gdy potrzebujesz więcej kontroli)
class ManagedConnection:
    def __init__(self, url: str) -> None:
        self._url = url

    def __enter__(self) -> "ManagedConnection":
        self._conn = connect(self._url)
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_val: BaseException | None,
        tb: TracebackType | None,
    ) -> None:
        self._conn.close()
```

> **`contextlib` utilities:**

```python
from contextlib import suppress, closing, ExitStack, nullcontext

# suppress — swallow specific exceptions
with suppress(FileNotFoundError):
    path.unlink()

# ExitStack — dynamic number of context managers
with ExitStack() as stack:
    files = [stack.enter_context(open(f)) for f in file_list]
```

> **Real-world:** `open()`, `threading.Lock()`, `tempfile.TemporaryDirectory()`, `unittest.mock.patch()`, `decimal.localcontext()`.

#### Async variant — `@asynccontextmanager`

```python
from __future__ import annotations

from contextlib import asynccontextmanager
from collections.abc import AsyncIterator

@asynccontextmanager
async def managed_db_session(url: str) -> AsyncIterator[AsyncSession]:
    """Acquire async DB connection, guaranteed cleanup on exit."""
    session = AsyncSession(url)
    try:
        await session.connect()
        yield session
    finally:
        await session.disconnect()
```

### 6.2 Registry — `__init_subclass__`

| Pole | Wartość |
|------|---------|
| Częstość | 8/10 |
| Opis | Automatyczna rejestracja klas/handlerów — nowe implementacje bez modyfikacji rejestru |
| Kiedy | Plugin system, factory z auto-rejestracją, command/handler registry |
| Kiedy NIE | 2-3 stałe klasy (hardcoded dict), import order matters, explicit > implicit |

```python
# ✅ __init_subclass__ — zero metaclass, zero decorator
class Codec:
    _registry: dict[str, type["Codec"]] = {}

    def __init_subclass__(cls, *, format: str, **kw: object) -> None:
        super().__init_subclass__(**kw)
        Codec._registry[format] = cls

    @classmethod
    def get(cls, format: str) -> type["Codec"]:
        return cls._registry[format]

class JSONCodec(Codec, format="json"):
    """Auto-rejestracja przy definicji klasy."""
    ...

class YAMLCodec(Codec, format="yaml"):
    ...

# Użycie
codec_cls = Codec.get("json")  # → JSONCodec
```

> **Real-world:** pytest plugin discovery, `setuptools` entry_points, SQLAlchemy declarative registry, DRF serializer registry.

### 6.3 Dependency Injection — constructor injection

| Pole | Wartość |
|------|---------|
| Częstość | 8/10 |
| Opis | Zależności dostarczane z zewnątrz, nie tworzone wewnątrz — testability + zamienność |
| Kiedy | Testability (mock deps), konfigurowalność per environment, DIP z SOLID |
| Kiedy NIE | Proste skrypty, pure function bez stanu, nie dodawaj frameworka DI na zapas |

```python
# ✅ Constructor injection — BEZ frameworka
class ProcessingService:
    def __init__(
        self,
        parser: ParserEngine,
        processor: Processor,
        renderer: TextRenderer,
    ) -> None:
        self._parser = parser
        self._processor = processor
        self._renderer = renderer

    def process_page(self, image: np.ndarray) -> np.ndarray:
        text = self._parser.recognize(image)
        processed = self._processor.process(text)
        return self._renderer.render(image, processed)

# Produkcja
service = ProcessingService(
    parser=DefaultParser(), processor=DefaultProcessor(), renderer=PillowRenderer(),
)
# Testy
service = ProcessingService(
    parser=FakeParser(), processor=FakeProcessor(), renderer=FakeRenderer(),
)
```

```python
# ✅ Function-level DI — default parameter
def fetch_data(
    url: str,
    client: httpx.AsyncClient | None = None,
) -> dict[str, Any]:
    _client = client or httpx.AsyncClient()
    return _client.get(url).json()
```

> **Real-world:** FastAPI `Depends()`, pytest fixtures (to DI system!), `dependency-injector` library.

### 6.4 Pipeline — generator chain

| Pole | Wartość |
|------|---------|
| Częstość | 8/10 |
| Opis | Dane przetwarzane przez sekwencję transformacji — output → input |
| Kiedy | ETL, image processing, text pipelines, middleware chains |
| Kiedy NIE | 2 kroki (zwykłe wywołanie), branching/conditionals (to DAG, nie pipeline) |

```python
# ✅ Functional pipeline — reduce
from functools import reduce
from typing import Callable, TypeVar

T = TypeVar("T")

def pipeline(data: T, *steps: Callable[[T], T]) -> T:
    return reduce(lambda d, step: step(d), steps, data)

result = pipeline(
    "  Hello World  ",
    str.strip,
    str.lower,
    lambda s: s.replace(" ", "_"),
)  # → "hello_world"

# ✅ Generator pipeline — lazy, memory-efficient
def read_lines(path: Path) -> Iterator[str]:
    with open(path) as f:
        yield from f

def strip_lines(lines: Iterable[str]) -> Iterator[str]:
    for line in lines:
        yield line.strip()

def non_empty(lines: Iterable[str]) -> Iterator[str]:
    for line in lines:
        if line:
            yield line

# Composable generators — zero pamięci na intermediate results
for line in non_empty(strip_lines(read_lines(data_path))):
    process(line)
```

> **Real-world:** scikit-learn `Pipeline`, pandas method chaining, Unix pipes philosophy, ASGI/WSGI middleware.

### 6.5 Plugin / Hook — `pluggy` + entry points

| Pole | Wartość |
|------|---------|
| Częstość | 7/10 |
| Opis | Rozszerzalny system — zewnętrzny kod podpina się do zdefiniowanych punktów |
| Kiedy | Extensible applications, framework hooks, test extensibility |
| Kiedy NIE | Brak userów pluginów (YAGNI), Observer wystarczy |

```python
# ✅ Entry points — standardowy plugin system
import importlib.metadata

def load_plugins(group: str = "myapp.plugins") -> list[Plugin]:
    plugins: list[Plugin] = []
    for ep in importlib.metadata.entry_points(group=group):
        plugin_cls = ep.load()
        plugins.append(plugin_cls())
    return plugins
```

> **Real-world:** `pytest` (`pluggy` hookspec/hookimpl), `setuptools` entry_points, `flake8`/`ruff` plugin architecture.

### 6.6 Repository — Protocol + ORM session

| Pole | Wartość |
|------|---------|
| Częstość | 6/10 |
| Opis | Abstrakcja nad warstwą persystencji — domain logic nie wie o storage |
| Kiedy | Clean Architecture, testowanie bez DB, wymienność storage backend |
| Kiedy NIE | CRUD bez domain logic (ORM wystarczy), prototypy |

```python
# ✅ Protocol-based Repository
class UserRepository(Protocol):
    def get(self, user_id: int) -> User | None: ...
    def save(self, user: User) -> None: ...

class SqlUserRepository:
    def __init__(self, session: Session) -> None:
        self._session = session

    def get(self, user_id: int) -> User | None:
        return self._session.get(User, user_id)

    def save(self, user: User) -> None:
        self._session.add(user)

class InMemoryUserRepository:
    """Do testów — zero DB."""

    def __init__(self) -> None:
        self._store: dict[int, User] = {}

    def get(self, user_id: int) -> User | None:
        return self._store.get(user_id)

    def save(self, user: User) -> None:
        self._store[user.id] = user
```

> **Real-world:** Django `Manager`/`QuerySet`, SQLAlchemy `Session`, "Architecture Patterns with Python" (Percival & Gregory).

### 6.7 Unit of Work — context manager

| Pole | Wartość |
|------|---------|
| Częstość | 5/10 |
| Opis | Grupuje operacje w jedną transakcję — atomowy commit/rollback |
| Kiedy | Spójność wielu operacji, batch processing, koordynacja repozytoriów |
| Kiedy NIE | Pojedyncze CRUD, framework zarządza transakcjami (`@transaction.atomic`) |

```python
# ✅ Pythonic — context manager UoW
class UnitOfWork:
    def __init__(self, session_factory: Callable[[], Session]) -> None:
        self._factory = session_factory

    def __enter__(self) -> "UnitOfWork":
        self.session = self._factory()
        self.users = SqlUserRepository(self.session)
        self.orders = SqlOrderRepository(self.session)
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_val: BaseException | None,
        tb: TracebackType | None,
    ) -> None:
        if exc_type:
            self.session.rollback()
        self.session.close()

    def commit(self) -> None:
        self.session.commit()

# Użycie
with UnitOfWork(session_factory) as uow:
    user = uow.users.get(1)
    uow.orders.save(Order(user_id=user.id))
    uow.commit()
```

> **Real-world:** SQLAlchemy `Session` (to UoW!), Django `transaction.atomic()`.

### 6.8 Null Object — no-op z interfejsem

| Pole | Wartość |
|------|---------|
| Częstość | 4/10 |
| Opis | Obiekt "brak" z prawidłowym interfejsem — eliminuje `if x is None` |
| Kiedy | Default behavior, NullHandler, terminal node w chain, optional deps |
| Kiedy NIE | `None` jest jednoznaczny, Null Object maskuje prawdziwe błędy |

```python
# ✅ Pythonic — Null Object z Protocol
class Logger(Protocol):
    def log(self, msg: str) -> None: ...

class NullLogger:
    """Null Object — swallows all log calls."""
    def log(self, msg: str) -> None:
        pass  # intentional no-op

def process(data: str, logger: Logger | None = None) -> str:
    _logger = logger or NullLogger()
    _logger.log(f"Processing: {data}")
    return data.upper()
```

> **Real-world:** `logging.NullHandler`, `contextlib.nullcontext()`, `unittest.mock.MagicMock()`.

---

## 7. Antypatterny — nadużywanie wzorców

| Antypattern | Waga | Dlaczego źle | Naprawa |
|-------------|------|-------------|---------|
| Singleton metaclass | 🔴 CRITICAL | Tight coupling, nietestowalne, łamie SRP | Module-level instance lub `lru_cache(1)` |
| Klasa z jedną metodą | 🔴 CRITICAL | Ukryta funkcja w class wrapper | Zwykła funkcja + `Callable` |
| Factory hierarchy | 🟡 HIGH | Zbędna abstrakcja — klasy są first-class | Dict dispatch lub `type[T]` callable |
| ABC gdzie wystarczy Protocol | 🟡 HIGH | Wymuszanie inheritance bez powodu | `Protocol` (structural subtyping) |
| GoF Iterator class | 🟡 HIGH | Python ma `yield`, `itertools`, generator expressions | Generator function |
| Wzorzec na 2 warianty | 🟡 HIGH | Over-engineering — YAGNI | `if/else` lub `match/case` |
| Strategy class per algorytm | 🟢 MEDIUM | W Pythonie callable zastępuje klasę | `Callable`, dict dispatch |
| Visitor z accept/visit | 🟢 MEDIUM | Python ma `singledispatch` i `match/case` | `@singledispatch` |
| Builder na ≤5 parametrów | 🟢 MEDIUM | `@dataclass` + defaults wystarczą | Keyword arguments + dataclass |
| `**kwargs` God Object | 🟢 MEDIUM | Brak type safety, ukryte API | Typed `@dataclass` lub `Protocol` |

---

## 8. Egzekucja ruff

Reguły ruff powiązane z wzorcami projektowymi:

| Reguła | Opis | Powiązany wzorzec |
|--------|------|-------------------|
| `PLW0603` | `global` statement | Singleton anti-pattern |
| `S307` | Użycie `eval()` | Interpreter — NIGDY `eval` |
| `S102` | Użycie `exec()` | Interpreter — NIGDY `exec` |
| `UP028` | `yield` loop → `yield from` | Iterator — Pythonic delegation |
| `C401` | Unnecessary list around generator | Iterator — lazy evaluation |
| `SIM117` | Nested `with` → combined | Context Manager — czytelność |
| `ASYNC100` | Blocking call in async | Context Manager — `async with` |
| `B009` | `getattr(x, "const")` → `x.const` | Proxy — dozwolone w dynamic proxy |
| `B010` | `setattr` with constant | Decorator — złe dekorowanie |
| `B006` | Mutable argument default | Creational — `None` sentinel |
| `RUF012` | Mutable class default | Flyweight — shared state risk |

---
## Źródła

- [python-patterns.guide — Brandon Rhodes](https://python-patterns.guide/) — Pythonic reimagination wzorców GoF
- [Refactoring Guru — Design Patterns Catalog](https://refactoring.guru/design-patterns/catalog) — kompletny katalog z diagramami UML
- [SourceMaking — Design Patterns](https://sourcemaking.com/design_patterns) — wzorce z przykładami i krytyka
- [PEP 544 — Protocols: Structural subtyping](https://peps.python.org/pep-0544/) — Protocol zamiast ABC
- [PEP 3119 — Introducing Abstract Base Classes](https://peps.python.org/pep-3119/) — kiedy ABC jest uzasadnione
- [PEP 318 — Decorators for Functions and Methods](https://peps.python.org/pep-0318/) — Python `@decorator` syntax
- [PEP 443 — Single-dispatch generic functions](https://peps.python.org/pep-0443/) — `@singledispatch` (Pythonic Visitor)
- [PEP 487 — Simpler customisation of class creation](https://peps.python.org/pep-0487/) — `__init_subclass__` (Pythonic Registry)
- [pluggy documentation](https://pluggy.readthedocs.io/) — pytest-style plugin system
- [Architecture Patterns with Python — Percival & Gregory](https://www.cosmicpython.com/) — Repository, UoW, DI w Pythonie
- [Peter Norvig — Design Patterns in Dynamic Languages (1998)](https://norvig.com/design-patterns/) — 16/23 wzorców uproszczonych w dynamicznych językach
- [faif/python-patterns on GitHub](https://github.com/faif/python-patterns) — community collection Pythonic patterns
