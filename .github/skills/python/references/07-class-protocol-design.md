# 07 — Class & Protocol Design

> **Cel:** Kompletne reguły projektowania klas, Protocol, ABC, composition i decyzji OOP w Pythonie — kiedy klasa jest uzasadniona, a kiedy to over-engineering.
> **Scope:** Uniwersalny — Python ≥3.10, `from __future__ import annotations`, ruff 120 chars, mypy strict, pydantic.

---

## Spis treści

1. [Kiedy klasa jest uzasadniona — tabela decyzyjna](#1-kiedy-klasa-jest-uzasadniona--tabela-decyzyjna)
2. [Protocol — structural subtyping](#2-protocol--structural-subtyping)
3. [ABC — Abstract Base Class](#3-abc--abstract-base-class)
4. [Protocol vs ABC — ujednolicona tabela decyzyjna](#4-protocol-vs-abc--ujednolicona-tabela-decyzyjna)
5. [Kompozycja vs dziedziczenie](#5-kompozycja-vs-dziedziczenie)
6. [dataclass vs Pydantic vs NamedTuple vs TypedDict](#6-dataclass-vs-pydantic-vs-namedtuple-vs-typeddict)
7. [Properties](#7-properties)
8. [`__slots__`](#8-__slots__)
9. [Reguły projektowania klas](#9-reguły-projektowania-klas)
10. [Zaawansowane mechanizmy do unikania](#10-zaawansowane-mechanizmy-do-unikania)
11. [Egzekucja ruff](#11-egzekucja-ruff)


## 📋 Quick Reference (ściąga)

| # | Reguła | Wartość |
|---|--------|---------|
| 1 | Klasa vs funkcja | Klasa TYLKO gdy shared mutable state, lifecycle lub polimorfizm |
| 2 | Protocol vs ABC | Protocol = default; ABC = wymuszony kontrakt + shared implementation |
| 3 | `runtime_checkable` | TYLKO gdy potrzebujesz `isinstance()` (np. plugin registry) |
| 4 | Composition vs Inheritance | Composition = default; Inheritance max 2 poziomy |
| 5 | Mixin max | Max 2 mixiny na klasę; mixin = stateless behaviour |
| 6 | Dane wewnętrzne | `dataclass(slots=True)` |
| 7 | Dane z walidacją / API | `pydantic BaseModel` |
| 8 | Immutable record | `NamedTuple` |
| 9 | Dict interop / JSON | `TypedDict` |
| 10 | `@property` | TYLKO: tanie (O(1)), bez side effects, bez argumentów |
| 11 | `__slots__` | >1000 instancji lub memory-critical → `slots=True` |
| 12 | `__init__` | Validate + assign, ZERO logiki; I/O → factory classmethod |
| 13 | Mutable class attrs | NIGDY `class Foo: items = []`; state w `__init__` |
| 14 | `@staticmethod` | NIGDY → module-level function |
| 15 | `metaclass` | NIGDY w app code → Protocol, decorator, `__init_subclass__` |
| 16 | Inheritance depth ≥3 | STOP → refactor na composition |
| 17 | Dunder `__eq__` bez `__hash__` | NIGDY → dodaj `__hash__` lub `frozen=True` |

---

> **Powiązane sekcje:**
> - `06-function-api-design.md` — parametry, return types, Callable vs Protocol (perspektywa functional), `@overload`, API design
> - `02-type-hints.md` — szczegóły składni typów, generics, TypeVar
> - `04-naming.md` — konwencje nazw klas, metod, atrybutów

---

## 1. Kiedy klasa jest uzasadniona — tabela decyzyjna

### 1.1 Główna tabela decyzyjna

> **Kluczowy insight (Hitchhiker's Guide to Python):** Python nie jest Javą — module-level functions, closures i moduły jako namespace to pełnoprawne narzędzia. Klasa bez stanu to _code smell_.

| Sytuacja | Użyj klasy | Użyj funkcji | Użyj closure | Dlaczego |
|----------|------------|---------------|---------------|-----------|
| Shared mutable state między metodami | ✅ | ❌ | ❌ | Klasa = naturalny kontener stanu współdzielonego |
| Kilka powiązanych metod na tych samych danych | ✅ | ❌ | ❌ | Spójność: dane + operacje razem |
| Polimorfizm / substytucja (duck typing) | ✅ | ❌ | ❌ | Protocol/ABC wymagają klasy po stronie implementacji |
| Lifecycle zasobu (open/close, connect/disconnect) | ✅ (context manager) | ❌ | ❌ | `__enter__`/`__exit__` = bezpieczne zarządzanie zasobem |
| Dependency injection >2 zależności | ✅ | ❌ | ❌ | Klasa jako kontener zależności |
| Zero stanu, pure transformation | ❌ | ✅ | ❌ | Free function — prostsze, testowalniejsze |
| Jedna operacja, brak state | ❌ | ✅ | ❌ | Single-method class = function in disguise |
| Fabryka z konfiguracją (partial application) | ❌ | ❌ | ✅ | Closure = lekka alternatywa dla klasy z 1 metodą |
| Callback z przechwyconym kontekstem | ❌ | ❌ | ✅ | Closure domyka zmienne — klasa byłaby overkill |
| Namespace dla constów / utility | ❌ (moduł) | ✅ | ❌ | Moduł = namespace w Pythonie; `class Utils:` to Java smell |
| Config / validation boundary | ✅ (pydantic) | ❌ | ❌ | Pydantic BaseModel daje walidację, serialization, IDE support |
| `__init__` + jedna metoda | ❌ | ✅ | ✅ | Anti-pattern: klasa jest ukrytą funkcją |

### 1.2 Sygnały że klasa jest POTRZEBNA

| Sygnał | Dlaczego → klasa | Przykład |
|--------|------------------|----------|
| >1 metoda operuje na tym samym stanie | Spójność danych i operacji | `ImageProcessor` z `.resize()`, `.crop()`, `.save()` |
| Instancja ma lifecycle (init → use → cleanup) | Context manager pattern | `DatabaseConnection`, `ModelSession` |
| Potrzebujesz substytucji w testach | Protocol + klasa implementująca | `PaymentService` → mock w teście |
| Stan mutuje się między wywołaniami | Free function musiałaby zwracać nowy stan | `PipelineState` z kolejnymi krokami |
| DI container — wiele zależności | Konstruktor jako wiring | `Orchestrator(detector, translator, renderer)` |

### 1.3 Sygnały że klasa jest ZBĘDNA

| Sygnał | Dlaczego ❌ | Akcja |
|--------|------------|-------|
| Brak `self` usage poza `__init__` | Klasa nie ma stanu | Zamień na free function |
| Tylko `__init__` + jedna publiczna metoda | Funkcja w przebraniu klasy | Zamień na funkcję / closure |
| `@staticmethod` everywhere | Moduł udający klasę | Zamień na module-level functions |
| `class Utils:` / `class Helpers:` | Java-style namespace — Python ma moduły | Zamień na moduł |
| Klasa istnieje "bo OOP" | Cargo cult z Javy / C# | Zadaj sobie pytanie: "jaki stan trzyma ta klasa?" |

```python
# ✅ Klasa uzasadniona — shared state, lifecycle, wiele metod
from __future__ import annotations

from pathlib import Path
from types import TracebackType

class ModelSession:
    """Sesja modelu ML z zarządzaniem lifecycle."""

    def __init__(self, model_path: Path, *, device: str = "cpu") -> None:
        self._model_path = model_path
        self._device = device
        self._model: Model | None = None

    def __enter__(self) -> ModelSession:
        self._model = load_model(self._model_path, device=self._device)
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_val: BaseException | None,
        exc_tb: TracebackType | None,
    ) -> None:
        if self._model is not None:
            self._model.unload()
            self._model = None

    def predict(self, data: np.ndarray) -> np.ndarray:
        """Predykcja na załadowanym modelu."""
        if self._model is None:
            msg = "Session not entered — use 'with' statement"
            raise RuntimeError(msg)
        return self._model.forward(data)
```

```python
# ❌ Klasa bez stanu — to powinna być free function
from __future__ import annotations

class TextCleaner:
    def clean(self, text: str) -> str:
        return text.strip().lower()

# Użycie: TextCleaner().clean("Hello")  ← po co instancja?

# ✅ Poprawnie: free function
def clean_text(text: str) -> str:
    """Wyczyść tekst — strip + lowercase."""
    return text.strip().lower()
```

```python
# ❌ Single-method class — closure jest lżejsze
from __future__ import annotations

class Multiplier:
    def __init__(self, factor: float) -> None:
        self._factor = factor

    def apply(self, value: float) -> float:
        return value * self._factor

# ✅ Poprawnie: closure
def make_multiplier(factor: float) -> Callable[[float], float]:
    """Zwróć closure mnożące przez factor."""
    def multiply(value: float) -> float:
        return value * factor
    return multiply
```

---

## 2. Protocol — structural subtyping

### 2.1 Czym jest Protocol (PEP 544)

| Aspekt | Opis | Dlaczego |
|--------|------|----------|
| Typ subtyping | **Structural** (duck typing) — klasa pasuje jeśli MA wymagane metody | Nie wymaga inheritance; najlepsza elastyczność |
| Runtime enforcement | BEZ (domyślnie) — czysto statyczny check (mypy/pyright) | Zero overhead w runtime |
| Analogia | Go interfaces, TypeScript interfaces | Jeśli wygląda jak kaczka i kwacze jak kaczka... |
| Import | `from typing import Protocol, runtime_checkable` | stdlib od 3.8 |

### 2.2 Minimalny Protocol — reguły projektowania

| Reguła | Wartość | Dlaczego | Kiedy NIE |
|--------|---------|----------|-----------|
| ISP (Interface Segregation) | Minimalna liczba metod | Łatwiej spełnić; więcej klas pasuje | Gdy metody są nierozerwalnie połączone |
| Method count | 1–3 metody | Więcej → split na mniejsze Protocols | Gdy klasa wrapper naprawdę wymaga 4+ |
| Attributes w Protocol | Sparingly — preferuj methods | Atrybut wymusza konkretną implementację | `@property` daje elastyczność |
| Naming | Suffix `-able` lub prefix `Supports-` | `Translatable`, `SupportsRead` | Nazwy domenowe: `TextDetector` też OK |

```python
# ✅ Minimalny Protocol — ISP: jedna odpowiedzialność
from __future__ import annotations

from typing import Protocol

class Translatable(Protocol):
    """Każdy obiekt który potrafi przetłumaczyć tekst."""

    def translate(self, text: str, *, target_lang: str) -> str: ...
```

```python
# ❌ God Protocol — łamie ISP, nikt tego nie zaimplementuje w całości
from __future__ import annotations

from typing import Protocol

class TextService(Protocol):
    def translate(self, text: str, *, target_lang: str) -> str: ...
    def detect_language(self, text: str) -> str: ...
    def summarize(self, text: str, *, max_length: int) -> str: ...
    def classify(self, text: str) -> list[str]: ...
    def embed(self, text: str) -> list[float]: ...
    # → 5 metod = 5 powodów do zmiany = Split na 5 Protocols
```

### 2.3 `runtime_checkable` — tabela decyzyjna

| Kryterium | `@runtime_checkable` | Bez decorator | Dlaczego |
|-----------|---------------------|---------------|----------|
| Potrzebujesz `isinstance()` check | ✅ TAK | ❌ `isinstance` rzuci `TypeError` | Plugin system, registry, dispatch |
| Performance-critical hot path | ❌ NIE — runtime overhead | ✅ Lepiej | `isinstance` z Protocol jest ~10-100x wolniejsze niż z klasą |
| Statyczny type checking wystarczy | ❌ Niepotrzebne | ✅ mypy/pyright sprawdza | Dodawanie `runtime_checkable` "na wszelki wypadek" = noise |
| Sprawdzanie struktury (hasattr) | ✅ TAK | ❌ | `runtime_checkable` sprawdza obecność metod |

> ⚠️ **Gotcha:** `runtime_checkable` sprawdza TYLKO obecność metod/atrybutów, NIE ich sygnatury. `isinstance(obj, MyProtocol)` zwróci `True` nawet jeśli metoda ma złe typy argumentów.

```python
# ✅ runtime_checkable — plugin registry z isinstance check
from __future__ import annotations

from typing import Protocol, runtime_checkable

@runtime_checkable
class Detector(Protocol):
    """Detektor paneli — runtime-checkable dla plugin registry."""

    def detect(self, image: np.ndarray) -> list[BBox]: ...

def register_detector(obj: object) -> Detector:
    """Zarejestruj detektor z runtime validation."""
    if not isinstance(obj, Detector):
        msg = f"{type(obj).__name__} does not implement Detector protocol"
        raise TypeError(msg)
    return obj
```

```python
# ❌ runtime_checkable bez powodu — overhead bez wartości
from __future__ import annotations

from typing import Protocol, runtime_checkable

@runtime_checkable  # Nigdzie nie robimy isinstance — po co?
class Renderer(Protocol):
    def render(self, page: Page) -> bytes: ...

# Lepiej: bez @runtime_checkable → czysty static check
```

### 2.4 Kompozycja Protocol

| Wzorzec | Kiedy | Syntax |
|---------|-------|--------|
| Single Protocol | Jedna capability | `class Readable(Protocol): def read(self) -> bytes: ...` |
| Composed Protocol | Klasa musi mieć WIELE capabilities | `class ReadWritable(Readable, Writable, Protocol): ...` |
| Protocol + generics | Typed container/processor | `class Processor(Protocol[T]): def process(self, item: T) -> T: ...` |

```python
# ✅ Composed Protocol — ISP zachowane, kompozycja gdy potrzeba
from __future__ import annotations

from typing import Protocol

class Readable(Protocol):
    def read(self) -> bytes: ...

class Writable(Protocol):
    def write(self, data: bytes) -> None: ...

class ReadWritable(Readable, Writable, Protocol):
    """Łączy Readable + Writable — użyj gdy potrzebujesz obu."""
    ...
```

### 2.5 Protocol vs Callable — tabela decyzyjna

> Uwaga: rozbudowana wersja tabeli z sekcji 06 — tutaj z perspektywy **class design**.

| Kryterium | `Callable[[X], Y]` | Protocol z `__call__` | Protocol z named method | Dlaczego |
|-----------|--------------------|-----------------------|------------------------|-----|
| Prosta sygnatura (1–2 args) | ✅ | ❌ Overkill | ❌ Overkill | `Callable` jest zwięzłe |
| Keyword args | ❌ Nie wspiera | ✅ | ✅ | `Callable` nie opisuje kwarg names |
| Obiekt z atrybutami + callable | ❌ | ✅ | ✅ | Protocol opisuje pełny interface |
| Semantyka domenowa | ❌ Anonimowe | ❌ Generyczne | ✅ `Detector.detect()` | Named method = self-documenting |
| Polimorfizm (wiele implementacji) | ⚠️ Słabe | ⚠️ OK | ✅ Najlepsze | Named method → jasne co implementujesz |

---

## 3. ABC — Abstract Base Class

### 3.1 Podstawy ABC

| Aspekt | Opis | Dlaczego |
|--------|------|----------|
| Typ subtyping | **Nominal** — klasa MUSI jawnie dziedziczyć | Wymuszenie kontraktu w subclasses |
| Runtime enforcement | TAK — `TypeError` jeśli brak implementacji `@abstractmethod` | Szybki fail przy instancji |
| Import | `from abc import ABC, abstractmethod` | stdlib |
| Use case | Framework / library design — wymuszasz kontrakt | Plugin system z jasnym kontraktem |

### 3.2 Kiedy ABC — tabela decyzyjna

| Sytuacja | ABC | Protocol | Dlaczego |
|----------|-----|----------|----------|
| Framework wymusza kontrakt na plugins | ✅ | ⚠️ | ABC daje runtime `TypeError` jeśli brak implementacji |
| Shared default implementation (Template Method) | ✅ | ❌ Protocol nie ma implementacji | ABC może mieć concrete methods |
| Consumer code potrzebuje flexibility | ❌ | ✅ | Protocol nie wymaga inheritance |
| Third-party klasy (nie możesz zmienić) | ❌ | ✅ | Structural typing = pasuje jeśli ma metody |
| Explicit documentation "musisz zaimplementować X" | ✅ | ⚠️ | ABC jest self-documenting przez `@abstractmethod` |
| Unit testing z mock | ⚠️ Może wymagać subclass | ✅ Dowolny obiekt pasuje | Mock nie musi dziedziczyć po Protocol |

### 3.3 `@abstractmethod` — reguły

| Reguła | Dlaczego | Przykład |
|--------|----------|---------|
| Zawsze z `ABC` jako base | `@abstractmethod` bez `ABC` nie wymusza | `class Base(ABC):` |
| Nie łącz z `@staticmethod` | Google Style bans `@staticmethod` | Użyj `@classmethod` + `@abstractmethod` |
| `@classmethod` + `@abstractmethod`: `@abstractmethod` WEWNĄTRZ | Kolejność dekoratorów ma znaczenie | Patrz snippet |
| Body: `...` (Ellipsis) nie `pass` | Konwencja — `...` sygnalizuje "do zaimplementowania" | `def process(self) -> None: ...` |

```python
# ✅ Poprawna kolejność: @classmethod NA ZEWNĄTRZ, @abstractmethod WEWNĄTRZ
from __future__ import annotations

from abc import ABC, abstractmethod

class BaseLoader(ABC):
    @classmethod
    @abstractmethod
    def from_config(cls, config: dict) -> BaseLoader: ...
```

```python
# ❌ Odwrócona kolejność — @abstractmethod na zewnątrz nie zadziała poprawnie
from __future__ import annotations

from abc import ABC, abstractmethod

class BaseLoader(ABC):
    @abstractmethod
    @classmethod  # ❌ classmethod owinięty w abstractmethod → TypeError w runtime
    def from_config(cls, config: dict) -> BaseLoader: ...
```

```python
# ✅ ABC z Template Method pattern
from __future__ import annotations

from abc import ABC, abstractmethod

class BaseExporter(ABC):
    """Bazowy exporter z Template Method pattern."""

    def export(self, data: list[Page]) -> bytes:
        """Template method — wywołuje abstrakcyjne kroki."""
        validated = self._validate(data)
        transformed = self._transform(validated)
        return self._serialize(transformed)

    def _validate(self, data: list[Page]) -> list[Page]:
        """Hook z domyślną implementacją — subclass MOŻE nadpisać."""
        return [p for p in data if p.is_valid]

    @abstractmethod
    def _transform(self, data: list[Page]) -> list[dict]: ...

    @abstractmethod
    def _serialize(self, data: list[dict]) -> bytes: ...


class JsonExporter(BaseExporter):
    """Eksport do JSON — implementuje abstrakcyjne kroki."""

    def _transform(self, data: list[Page]) -> list[dict]:
        return [page.to_dict() for page in data]

    def _serialize(self, data: list[dict]) -> bytes:
        return json.dumps(data, ensure_ascii=False).encode()
```

```python
# ❌ ABC bez @abstractmethod — subclass może "zapomnieć" implementacji
from __future__ import annotations

from abc import ABC

class BaseExporter(ABC):
    def transform(self, data):  # Nie abstract → subclass nie musi nadpisać
        raise NotImplementedError  # Runtime bomb zamiast static check
```

### 3.4 ABC + dataclass / slots — pułapki

| Kombinacja | Działa? | Pułapka |
|------------|---------|---------|
| ABC + dataclass | ✅ TAK | Pamiętaj: `@dataclass` na subclass, nie na ABC |
| ABC + `__slots__` | ⚠️ Komplikacje | ABC metaclass + slots = potencjalne konflikty z MRO |
| ABC + pydantic | ❌ Unikaj | Pydantic ma własną metaclass — konflikty. Użyj Protocol |

---

## 4. Protocol vs ABC — ujednolicona tabela decyzyjna

| Kryterium | Protocol | ABC | WHY wygrywa |
|-----------|----------|-----|-------------|
| Runtime enforcement | ❌ Brak (domyślnie) | ✅ `TypeError` na instantiation | ABC → szybki fail |
| Inheritance wymagana? | ❌ NIE | ✅ TAK | Protocol → większa elastyczność |
| Third-party classes | ✅ Pasują automatycznie | ❌ Muszą jawnie dziedziczyć | Protocol → zero coupling |
| Default implementation | ❌ NIE (Protocol = interface) | ✅ TAK (concrete methods) | ABC → Template Method |
| Testing (mock) | ✅ Dowolny obiekt | ⚠️ Mock musi dziedziczyć | Protocol → prostsze testy |
| Discoverability | ⚠️ Implicit ("co pasuje?") | ✅ Explicit (hierarchy widoczna) | ABC → jasna dokumentacja |
| Flexible composition | ✅ Multiple Protocols łatwe | ⚠️ Multiple ABC = MRO issues | Protocol → composition-friendly |
| mypy strict | ✅ Pełne wsparcie | ✅ Pełne wsparcie | Remis |
| Performance | ✅ Zero runtime overhead | ⚠️ Metaclass overhead (minimalny) | Protocol → marginally |
| **Domyślny wybór** | **✅ PREFEROWANY** | Gdy potrzebujesz enforcement LUB default impl | **Modern Python → Protocol first** |

### Reguła decyzyjna (flowchart)

```
Potrzebujesz polimorfizmu?
├─ NIE → free function (sekcja 1)
└─ TAK → Czy kontrolujesz WSZYSTKIE implementacje?
    ├─ NIE (third-party, unknown) → Protocol ← DOMYŚLNY WYBÓR
    └─ TAK → Czy masz SHARED IMPLEMENTATION (konkretne metody do reuse)?
        ├─ TAK → ABC (Template Method pattern) — shared impl + @abstractmethod
        └─ NIE → Protocol — ZAWSZE Protocol gdy brak shared implementation
```

**Reguła kciuka:** Shared implementation → ABC; brak shared implementation → Protocol.

---

## 5. Kompozycja vs dziedziczenie

### 5.1 Główna tabela decyzyjna

| Kryterium | Composition (has-a) | Inheritance (is-a) | Dlaczego wygrywa |
|-----------|--------------------|--------------------|-----------------|
| Coupling | ✅ Loose — zależność przez interface | ❌ Tight — subclass zależy od implementacji parent | Composition → łatwiejsze zmiany |
| Testowalność | ✅ Mock dependency | ⚠️ Mock parent class jest trudniejszy | Composition → prostsze testy |
| Elastyczność runtime | ✅ Wymień komponent w runtime | ❌ Klasa ustalona compile-time | Composition → strategy pattern |
| Reuse kodu | ⚠️ Wymaga explicit delegation | ✅ Automatyczny reuse z parent | Inheritance → mniej boilerplate |
| Czytelność "co to jest" | ⚠️ Sprawdź co zawiera | ✅ `class Dog(Animal)` → jasne | Inheritance → self-documenting |
| Deep hierarchy (>2 lvl) | ✅ Flat composition | ❌ MRO hell, fragile base class | Composition → ZAWSZE powyżej 2 poziomów |
| Diamond problem | ✅ Brak | ❌ MRO confusion | Composition |

### 5.2 Reguła głębokości: max 2 poziomy

| Głębokość | OK? | Akcja |
|-----------|-----|-------|
| 0: Concrete class (brak parent) | ✅ | — |
| 1: `class Child(Parent)` | ✅ | Uzasadnij is-a relację |
| 2: `class Grandchild(Child)` | ⚠️ | Code review — czy naprawdę is-a? |
| 3+: `class GreatGrand(Grandchild)` | ❌ **STOP** | Refactor → composition |

### 5.3 Mixin — kiedy OK, kiedy nie

| Kryterium | Mixin OK | Mixin ❌ | Dlaczego |
|-----------|----------|---------|----------|
| Reusable behaviour (np. logging, serialization) | ✅ | — | Mixin = reusable aspect |
| Mixin trzyma stan | — | ❌ | Mixin powinien być stateless lub minimal state |
| >2 mixins na klasę | — | ❌ | MRO confusion, mixin hell |
| Diamond pattern | — | ❌ | Python MRO (C3 linearization) działa, ale utrudnia reasoning |
| Mixin wymaga `super().__init__()` chain | — | ⚠️ Risky | Kooperatywne `super()` jest kruche |

```python
# ✅ Composition — elastyczne, tesowalne, loose coupling
from __future__ import annotations

class TranslationPipeline:
    """Pipeline z injected dependencies — composition."""

    def __init__(
        self,
        detector: Detector,
        translator: Translator,
        renderer: Renderer,
    ) -> None:
        self._detector = detector
        self._translator = translator
        self._renderer = renderer

    def process(self, image: np.ndarray) -> bytes:
        """Przetwórz obraz przez pipeline."""
        panels = self._detector.detect(image)
        translated = self._translator.translate(panels)
        return self._renderer.render(image, translated)
```

```python
# ❌ Deep inheritance — tight coupling, fragile base class
from __future__ import annotations

class BaseProcessor:
    def process(self, data): ...

class ImageProcessor(BaseProcessor):
    def process(self, data): ...

class MangaProcessor(ImageProcessor):
    def process(self, data): ...

class TranslatedMangaProcessor(MangaProcessor):  # 3 poziomy deep — RED FLAG
    def process(self, data): ...
```

```python
# ✅ Mixin OK — stateless, reusable behaviour
from __future__ import annotations

import json

class JsonSerializableMixin:
    """Mixin dodający serializację JSON — stateless, reusable."""

    def to_json(self) -> str:
        return json.dumps(self.__dict__, ensure_ascii=False, default=str)

class PageResult(JsonSerializableMixin):
    def __init__(self, page_id: int, text: str) -> None:
        self.page_id = page_id
        self.text = text
```

```python
# ❌ Mixin hell — 4 mixiny, kto wie jaki jest MRO?
from __future__ import annotations

class LoggingMixin: ...
class CachingMixin: ...
class ValidationMixin: ...
class SerializationMixin: ...

class SuperService(LoggingMixin, CachingMixin, ValidationMixin, SerializationMixin):
    # MRO: SuperService → Logging → Caching → Validation → Serialization → object
    # Kto debuguje super().__init__() chain w tym?
    ...
```

---

## 6. dataclass vs Pydantic vs NamedTuple vs TypedDict

### 6.1 Ujednolicona tabela decyzyjna

| Cecha | `dataclass` | `pydantic BaseModel` | `NamedTuple` | `TypedDict` |
|-------|-------------|---------------------|--------------|-------------|
| Validation | ❌ Brak (ręcznie w `__post_init__`) | ✅ Automatic, rich validators | ❌ Brak | ❌ Brak |
| Immutability | `frozen=True` | `model_config = {"frozen": True}` | ✅ Domyślnie immutable | N/A (dict) |
| `__slots__` | `slots=True` (3.10+) | ❌ Niedostępne | ✅ Automatycznie | N/A |
| JSON serialization | ❌ Ręcznie | ✅ `.model_dump_json()` | ❌ Ręcznie | ❌ Ręcznie (ale dict-based) |
| IDE support (autocomplete) | ✅ Bardzo dobre | ✅ Bardzo dobre | ✅ Dobre | ⚠️ Zależy od IDE |
| Inheritance | ✅ TAK | ✅ TAK (z gotchas) | ⚠️ Ograniczone | ✅ TAK |
| Performance (creation) | ✅ Szybkie | ⚠️ ~5-10x wolniejsze (walidacja) | ✅ Najszybsze | ✅ Szybkie (to dict) |
| Memory | ✅ z `slots=True` | ⚠️ Więcej (metadata) | ✅ Kompaktowe | ⚠️ Dict overhead |
| Dependency | stdlib | pydantic (zewn.) | stdlib | stdlib |
| Pattern matching | ✅ | ✅ | ✅ | ❌ |

### 6.2 Kryteria decyzyjne — kiedy który

| Przypadek | Wybór | Dlaczego | Kiedy NIE |
|-----------|-------|----------|-----------|
| Internal data container (brak walidacji) | `dataclass` | Szybkie, zero dependency, IDE-friendly | Gdy potrzebujesz walidacji |
| API boundary (request/response) | `pydantic BaseModel` | Walidacja, serialization, schema generation | Internal-only data |
| Config / settings | `pydantic BaseModel` | `.env` support, validation, type coercion | Trywialna config (2 pola) |
| Immutable record (hash key, dict key) | `NamedTuple` | Hashowalne, tuple-compatible, memory-efficient | Gdy potrzebujesz mutacji |
| Interop z dict-based API / JSON schema | `TypedDict` | Typowany dict — dla legacy API, JSON | Gdy możesz użyć klasy |
| Wiele instancji, memory-critical | `dataclass(slots=True)` lub `NamedTuple` | Najniższy memory footprint | Gdy masz <1000 instancji |
| DTO (Data Transfer Object) | `dataclass(frozen=True)` | Immutable, lightweight, hashable | Gdy potrzebujesz walidacji |

```python
# ✅ dataclass — internal data, brak walidacji, slots dla memory
from __future__ import annotations

from dataclasses import dataclass

@dataclass(frozen=True, slots=True)
class BBox:
    """Bounding box — immutable, memory-efficient."""

    x: int
    y: int
    width: int
    height: int

    @property
    def area(self) -> int:
        return self.width * self.height
```

```python
# ✅ Pydantic — API boundary, walidacja, serialization
from __future__ import annotations

from pydantic import BaseModel, Field

class TranslationRequest(BaseModel):
    """Request na API boundary — walidacja wbudowana."""

    text: str = Field(min_length=1, max_length=10_000)
    source_lang: str = Field(default="ja", pattern=r"^[a-z]{2}$")
    target_lang: str = Field(default="pl", pattern=r"^[a-z]{2}$")
```

```python
# ✅ NamedTuple — immutable record, tuple-compatible
from __future__ import annotations

from typing import NamedTuple

class Point(NamedTuple):
    x: float
    y: float
```

```python
# ✅ TypedDict — interop z dict-based API
from __future__ import annotations

from typing import TypedDict

class PageMetadata(TypedDict):
    """Metadane strony — dla JSON API / legacy dict-based code."""

    page_id: int
    width: int
    height: int
    language: str
```

```python
# ❌ Bare dict — brak typów, brak IDE support, brak walidacji
from __future__ import annotations

def get_metadata(page) -> dict:  # Co jest w tym dict? Nikt nie wie.
    return {"page_id": 1, "width": 800, "lang": "ja"}
```

---

## 7. Properties

### 7.1 Tabela decyzyjna: property vs metoda

| Kryterium | `@property` | Metoda `get_x()` / `compute_x()` | Dlaczego |
|-----------|-------------|-----------------------------------|----------|
| Brak argumentów (poza self) | ✅ | ❌ Overkill | Property = brak-argowy accessor |
| Tanie obliczenie (O(1), brak I/O) | ✅ | ❌ | Caller oczekuje że `obj.x` jest instant |
| Brak side effects | ✅ | ❌ | Property nie powinno zmieniać stanu |
| Deterministyczy wynik | ✅ | ❌ | `obj.x` powinno być stabilne |
| Droga operacja (I/O, O(n+)) | ❌ | ✅ | Ukryte koszty za `.` accessor to pułapka |
| Side effects (logging, mutation) | ❌ | ✅ | Metoda sygnalizuje "coś się dzieje" |
| Wymaga argumentów | ❌ | ✅ | Property nie przyjmuje args |
| Asynchroniczne | ❌ | ✅ `async def` | `@property` nie wspiera `async` |

### 7.2 Reguła Google Style

> _"Use properties for accessing or setting data where you would normally have used simple, lightweight accessor or setter methods. Properties should be created with the `@property` decorator. The most common use is to make a public attribute read-only."_ — Google Python Style Guide

### 7.3 Wzorce property

```python
# ✅ Property — tanie, deterministic, brak side effects
from __future__ import annotations

from dataclasses import dataclass

@dataclass
class Rectangle:
    width: float
    height: float

    @property
    def area(self) -> float:
        """Pole prostokąta — O(1), brak side effects."""
        return self.width * self.height

    @property
    def is_square(self) -> bool:
        """Czy prostokąt jest kwadratem."""
        return self.width == self.height
```

```python
# ❌ Property abuse — I/O, drogie, side effects
from __future__ import annotations

class PageManager:
    @property
    def pages(self) -> list[Page]:
        # ❌ Database query ukryty za property!
        return self._db.fetch_all("SELECT * FROM pages")

    @property
    def page_count(self) -> int:
        # ❌ Kolejny DB query! Caller myśli że to O(1)
        return len(self.pages)  # Podwójny query!
```

```python
# ✅ Setter z walidacją — jedyny uzasadniony setter
from __future__ import annotations

class Volume:
    def __init__(self, level: int = 50) -> None:
        self.level = level  # Wywołuje setter

    @property
    def level(self) -> int:
        return self._level

    @level.setter
    def level(self, value: int) -> None:
        if not 0 <= value <= 100:
            msg = f"Volume must be 0-100, got {value}"
            raise ValueError(msg)
        self._level = value
```

---

## 8. `__slots__`

### 8.1 Tabela decyzyjna

| Kryterium | `__slots__` | Bez `__slots__` | Dlaczego |
|-----------|-------------|-----------------|----------|
| Wiele instancji (>1000) | ✅ | ❌ Pamięć | ~40-50% mniej RAM (brak `__dict__` per instance) |
| Memory-critical path | ✅ | ❌ | Mierzalny impact |
| Dynamic attrs potrzebne | ❌ | ✅ | `__slots__` blokuje `obj.new_attr = x` |
| Dataclass (3.10+) | `@dataclass(slots=True)` | `@dataclass` (domyślnie bez) | Najprościej |
| Inheritance z non-slot parent | ⚠️ Ryzyko | ✅ Bezpieczne | Slot + non-slot parent = `__dict__` i tak istnieje |
| Mixins / multiple inheritance | ⚠️ Komplikacje | ✅ Bezpieczne | Każda klasa w MRO musi definiować swoje slots |

### 8.2 Oszczędność pamięci — realne liczby

| Klasa | Bez slots (bytes) | Ze slots (bytes) | Oszczędność |
|-------|-------------------|------------------|-------------|
| 2 pola (int, str) | ~152 | ~96 | **~37%** |
| 5 pól (mixed) | ~240 | ~120 | **~50%** |
| 10 000 instancji × 5 pól | ~2.4 MB | ~1.2 MB | **~1.2 MB** |

### 8.3 Wzorce `__slots__`

#### Benchmark memory — `__slots__` vs dict

```python
import sys
from dataclasses import dataclass

@dataclass
class PointNoSlots:
    x: float
    y: float

@dataclass(slots=True)
class PointWithSlots:
    x: float
    y: float

p1 = PointNoSlots(1.0, 2.0)
p2 = PointWithSlots(1.0, 2.0)

print(f"No slots: {sys.getsizeof(p1)} bytes")   # ~288 bytes (zawiera __dict__)
print(f"With slots: {sys.getsizeof(p2)} bytes")  # ~48 bytes (tylko atrybuty)
# Dla 10 000 instancji: ~2.4 MB vs ~0.48 MB
```

#### Wzorzec implementacji

```python
# ✅ dataclass + slots — najprościej (Python 3.10+)
from __future__ import annotations

from dataclasses import dataclass

@dataclass(slots=True)
class TextBlock:
    """Blok tekstu — wiele instancji, slots dla memory."""

    text: str
    x: int
    y: int
    width: int
    height: int
    confidence: float
```

```python
# ✅ Manual __slots__ — gdy nie używasz dataclass
from __future__ import annotations

class Vertex:
    """Wierzchołek — setki tysięcy instancji."""

    __slots__ = ("x", "y", "z")

    def __init__(self, x: float, y: float, z: float) -> None:
        self.x = x
        self.y = y
        self.z = z
```

```python
# ❌ slots + inheritance gotcha — parent bez slots = __dict__ istnieje
from __future__ import annotations

class Parent:  # Brak __slots__ → ma __dict__
    def __init__(self) -> None:
        self.a = 1

class Child(Parent):
    __slots__ = ("b",)  # Dziecko ma slots, ale parent ma __dict__
    # → Child instancje MAJĄ __dict__ (z Parent) + slot "b"
    # → Zero memory savings!
```

```python
# ✅ slots + inheritance — poprawnie: parent MUSI mieć __slots__
from __future__ import annotations

class Parent:
    __slots__ = ("a",)

    def __init__(self) -> None:
        self.a = 1

class Child(Parent):
    __slots__ = ("b",)

    def __init__(self) -> None:
        super().__init__()
        self.b = 2
```

---

## 9. Reguły projektowania klas

### 9.1 `__init__` — minimalna logika

| Reguła | Dlaczego | Kiedy NIE |
|--------|----------|-----------|
| `__init__` = validate + assign, ZERO logiki | Konstruktor powinien być tani i przewidywalny | Nigdy nie łam — wydziel do factory / method |
| Nie rób I/O w `__init__` | Instancja powinna powstać bez side effects | Użyj factory classmethod: `cls.from_file(path)` |
| Nie rób heavy computation w `__init__` | Caller nie oczekuje wolnego konstruktora | Użyj lazy property lub explicit `.initialize()` |

```python
# ✅ Init = validate + assign, logika w osobnej metodzie
from __future__ import annotations

from pathlib import Path

class ModelLoader:
    """Loader z lazy initialization — init jest tani."""

    def __init__(self, model_path: Path, *, device: str = "cpu") -> None:
        if not model_path.exists():
            msg = f"Model not found: {model_path}"
            raise FileNotFoundError(msg)
        self._model_path = model_path
        self._device = device
        self._model: Model | None = None  # Lazy — nic nie ładujemy

    def load(self) -> None:
        """Explicit load — caller widzi że to jest kosztowne."""
        self._model = _load_from_disk(self._model_path, self._device)

    @classmethod
    def from_config(cls, config: ModelConfig) -> ModelLoader:
        """Factory method — alternatywna konstrukcja."""
        return cls(config.path, device=config.device)
```

```python
# ❌ Init z heavy logic — wolny, side-effecty, trudny do testowania
from __future__ import annotations

from pathlib import Path

class ModelLoader:
    def __init__(self, model_path: Path) -> None:
        self._model = _load_from_disk(model_path)  # ❌ I/O w init!
        self._warmup_cache()  # ❌ Heavy computation!
        logger.info("Model loaded")  # ❌ Side effect!
```

### 9.2 Mutable class attributes — TRAP

| Wzorzec | Bezpieczny? | Dlaczego |
|---------|-------------|----------|
| `class Foo: items = []` | ❌ **NIGDY** | Współdzielone między WSZYSTKIMI instancjami |
| `class Foo: count = 0` (immutable) | ✅ | Immutable class-level → każda instancja ma swoją kopię po przypisaniu |
| `class Foo: CONST = "value"` | ✅ | Stała — nigdy nie mutowana |

```python
# ❌ Mutable class attribute — współdzielone przez instancje
from __future__ import annotations

class PageCollector:
    pages: list[Page] = []  # ❌ WSZYSTKIE instancje współdzielą tę listę!

a = PageCollector()
b = PageCollector()
a.pages.append(Page(1))
print(b.pages)  # [Page(1)] ← b widzi dane z a!
```

```python
# ✅ Mutable state w __init__ — per-instancja
from __future__ import annotations

class PageCollector:
    def __init__(self) -> None:
        self.pages: list[Page] = []  # ✅ Nowa lista dla każdej instancji
```

### 9.3 Metody dunder — tabela decyzyjna

| Metoda | Kiedy implementować | Dlaczego | Auto w dataclass? |
|--------|--------------------|-----------|--------------------|
| `__repr__` | ZAWSZE dla data classes | Debug, logging, REPL | ✅ TAK |
| `__eq__` | Gdy porównanie po wartości (nie identność) | `==` domyślnie porównuje `id()` | ✅ TAK |
| `__hash__` | TYLKO jeśli immutable (`frozen`) | Hash musi być stabilny — mutable = bug | ✅ z `frozen=True` |
| `__str__` | Gdy user-facing representation ≠ `__repr__` | `print(obj)` powinno być czytelne | ❌ NIE |
| `__bool__` | Gdy "emptiness" ma sens | `if collection:` → `__bool__` | ❌ NIE |
| `__len__` | Container-style class | `len(obj)` support | ❌ NIE |
| `__iter__` | Iterable container | `for x in obj:` support | ❌ NIE |
| `__enter__` / `__exit__` | Resource lifecycle | `with obj:` — context manager | ❌ NIE |

```python
# ✅ Dobrze: __repr__ i __eq__ dla data class (ręcznie gdy nie dataclass)
from __future__ import annotations

class BBox:
    __slots__ = ("x", "y", "w", "h")

    def __init__(self, x: int, y: int, w: int, h: int) -> None:
        self.x = x
        self.y = y
        self.w = w
        self.h = h

    def __repr__(self) -> str:
        return f"BBox(x={self.x}, y={self.y}, w={self.w}, h={self.h})"

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, BBox):
            return NotImplemented
        return (self.x, self.y, self.w, self.h) == (other.x, other.y, other.w, other.h)
```

### 9.4 Prywatność przez konwencję

| Prefix | Semantyka | Enforcement |
|--------|-----------|-------------|
| `_name` | Internal / protected | ❌ Brak — konwencja | ✅ **Preferowany** |
| `__name` | Name mangling (`_Class__name`) | ⚠️ Częściowe — utrudnia dostęp | ❌ Używaj rzadko |
| `name` | Public | — | — |

| Reguła | Dlaczego |
|--------|----------|
| Preferuj `_` (single underscore) | Python nie ma private — konwencja wystarczy |
| `__` (dunder mangling) → RZADKO | Uzasadnione TYLKO gdy subclass mogłaby przypadkowo nadpisać |
| Nie rób getterów/setterów "bo Java" | Python ma properties — użyj jeśli potrzebujesz logiki |

---

## 10. Zaawansowane mechanizmy do unikania

### 10.1 Tabela mechanizmów

| Mechanizm | Problem | Waga | Alternatywa | Kiedy OK |
|-----------|---------|------|-------------|----------|
| `metaclass` | Implicit magic, trudne do debug, mypy issues | 🔴 CRITICAL | Class decorator, `__init_subclass__`, Protocol | Framework core (np. Django ORM, pydantic) — NIGDY w app code |
| `__getattr__` / `__getattribute__` | Implicit attribute resolution, ukryte side effects | 🔴 CRITICAL | Explicit methods, `@property` | Proxy objects, lazy loading (z dokumentacją!) |
| `type()` dynamic class creation | Unreadable, brak IDE support | 🟡 HIGH | `dataclass`, `NamedTuple`, class decorators | Metaprogramming library code |
| Multiple inheritance >2 levels | MRO confusion, diamond problem | 🟡 HIGH | Composition, mixins (max 2) | Prawie nigdy |
| `@staticmethod` | Google bans it — module function jest lepsza | 🟡 HIGH | Module-level function | **Nigdy** — ZAWSZE module function |
| `__init_subclass__` (complex) | Ok dla rejestracji; ZŁE dla complex logic | 🟢 MEDIUM | Class decorator, explicit registry | Simple plugin registration |
| Monkey patching | Runtime modification, niewidoczne, kruche | 🔴 CRITICAL | DI, Protocol, parametryzacja | Testing ONLY (via `monkeypatch` fixture) |
| `__new__` override | Singleton, immutables — zazwyczaj niepotrzebne | 🟡 HIGH | Module-level instance, `functools.cache` | `NamedTuple` (technicznie używa `__new__`) |
| `__del__` (destructor) | Nieokreślony timing, GC-dependent | 🔴 CRITICAL | Context manager (`__enter__`/`__exit__`), `atexit` | Prawie nigdy w app code |

### 10.2 `@staticmethod` — dlaczego NIE

| Argument za `@staticmethod` | Kontr-argument | Verdict |
|-----------------------------|---------------|---------|
| "Grupuje logicznie z klasą" | Moduł JEST namespace w Pythonie | Module function |
| "Nie potrzebuje `self`" | Właśnie — nie potrzebuje klasy | Module function |
| "Subclass może nadpisać" | Jeśli potrzebuje nadpisania → powinien być `@classmethod` lub zwykła metoda | `@classmethod` |

```python
# ❌ staticmethod — Google Style bans it
from __future__ import annotations

class MathUtils:
    @staticmethod
    def add(a: int, b: int) -> int:
        return a + b

# Użycie: MathUtils.add(1, 2) — po co klasa?
```

```python
# ✅ Module-level function — proste, testowalne, Pythonic
from __future__ import annotations

def add(a: int, b: int) -> int:
    """Dodaj dwie liczby."""
    return a + b
```

### 10.3 `__init_subclass__` — jedyny OK use case (registration)

```python
# ✅ Simple plugin registration via __init_subclass__
from __future__ import annotations

class DetectorRegistry:
    """Registry z auto-registration subclasses."""

    _registry: dict[str, type[DetectorRegistry]] = {}

    def __init_subclass__(cls, *, name: str = "", **kwargs: object) -> None:
        super().__init_subclass__(**kwargs)
        key = name or cls.__name__.lower()
        DetectorRegistry._registry[key] = cls

class YoloDetector(DetectorRegistry, name="yolo"):
    """Auto-registered as 'yolo'."""
    ...

class CTDDetector(DetectorRegistry, name="ctd"):
    """Auto-registered as 'ctd'."""
    ...
```

```python
# ❌ __init_subclass__ z complex logic — trudne do debug
from __future__ import annotations

class Base:
    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        # ❌ Complex validation, patching methods, modifying cls
        for name in dir(cls):
            if name.startswith("handle_"):
                setattr(cls, name, _wrap_with_logging(getattr(cls, name)))
        # → Użyj class decorator zamiast tego
```

---

## 11. Egzekucja ruff

### 11.1 Reguły związane z projektowaniem klas

| Reguła | Co łapie | Auto-fix? | Waga |
|--------|----------|-----------|------|
| `B006` | Mutable default w function/method args | ❌ | 🔴 Bug |
| `B008` | Mutable default w function call (np. `Field(default=[])`) | ❌ | 🔴 Bug |
| `B024` | ABC bez `@abstractmethod` | ❌ | 🟡 Warning |
| `B027` | Empty method w ABC bez `@abstractmethod` | ❌ | 🟡 Warning |
| `RUF012` | Mutable class attribute bez `ClassVar` annotation | ❌ | 🟡 Warning |
| `SIM110` | `for` loop → `any()`/`all()` (w metodach) | ✅ | 🟢 Style |
| `SIM114` | Combinable `if` branches | ✅ | 🟢 Style |
| `UP006` | `List[X]` → `list[X]` (w class attrs) | ✅ | 🟢 Style |
| `UP007` | `Union[X, Y]` → `X \| Y` | ✅ | 🟢 Style |
| `UP035` | `typing.Dict` → `dict` | ✅ | 🟢 Style |
| `PYI034` | `__return__` w `__enter__` should be `Self` | ✅ | 🟢 Style |
| `PLC0205` | `__slots__` should be a tuple, not list/set | ✅ | 🟢 Style |
| `PIE790` | Unnecessary `pass` (use `...` in Protocol/ABC) | ✅ | 🟢 Style |
| `PLW1641` | `__eq__` without `__hash__` | ❌ | 🟡 Warning |

### 11.2 Konfiguracja ruff — klasy

```toml
# pyproject.toml — sekcja [tool.ruff.lint]
[tool.ruff.lint]
select = [
    "B",      # bugbear — B006, B008, B024, B027
    "RUF",    # ruff-specific — RUF012
    "UP",     # pyupgrade — UP006, UP007
    "PYI",    # pyi stubs — PYI034
    "PLC",    # pylint convention — PLC0205
    "PLW",    # pylint warning — PLW1641
    "PIE",    # pie — PIE790
    "SIM",    # simplify — SIM110, SIM114
]
```

### 11.3 mypy strict — flagi dla klas

| Flaga | Co sprawdza | Dlaczego |
|-------|-------------|----------|
| `disallow_untyped_defs = true` | Każda metoda MUSI mieć type hints | Bez annotacji → mypy ignoruje metodę |
| `strict_equality = true` | Porównanie niezgodnych typów | `"str" == 42` → error |
| `warn_return_any = true` | Metoda zwraca `Any` zamiast konkretnego typu | Ucieczka z type systemu |
| `disallow_any_generics = true` | `list` zamiast `list[str]` | Raw generics tracą informację typową |
| `check_untyped_defs = true` | Sprawdza nawet nieannotowane funkcje | Safety net |

---
## Źródła

- [PEP 544 — Protocols: Structural subtyping](https://peps.python.org/pep-0544/)
- [PEP 3119 — Introducing Abstract Base Classes](https://peps.python.org/pep-3119/)
- [Google Python Style Guide — Classes](https://google.github.io/styleguide/pyguide.html#22-classes)
- [Google Python Style Guide — Properties](https://google.github.io/styleguide/pyguide.html#217-properties)
- [Python Data Model — __slots__](https://docs.python.org/3/reference/datamodel.html#slots)
- [dataclasses — Data Classes](https://docs.python.org/3/library/dataclasses.html)
- [Pydantic — BaseModel](https://docs.pydantic.dev/latest/concepts/models/)
- [ruff B024 abstract-base-class-without-abstract-method](https://docs.astral.sh/ruff/rules/abstract-base-class-without-abstract-method/)
- [ruff RUF012 mutable-class-default](https://docs.astral.sh/ruff/rules/mutable-class-default/)