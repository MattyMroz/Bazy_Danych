# 03 — Imports & Exports

> **Cel:** Porządek importów, public API, circular imports, lazy loading.
> **Scope:** Uniwersalny — Python ≥3.10.

---

## Spis treści

1. [Po co porządek importów](#1-po-co-porządek-importów)
2. [5-grupowy porządek](#2-5-grupowy-porządek)
3. [`from __future__ import annotations`](#3-from-__future__-import-annotations)
4. [`from x import y` vs `import x`](#4-from-x-import-y-vs-import-x)
5. [Absolute vs relative imports](#5-absolute-vs-relative-imports)
6. [Star imports](#6-star-imports)
7. [`__all__` i public API](#7-__all__-i-public-api)
8. [Re-exports z `__init__.py`](#8-re-exports-z-__init__py)
9. [TYPE_CHECKING block](#9-type_checking-block)
10. [Circular imports](#10-circular-imports)
11. [Lazy imports](#11-lazy-imports)
12. [Konwencjonalne aliasy](#12-konwencjonalne-aliasy)
13. [Import Decision Tree](#13-import-decision-tree)
14. [ruff enforcement](#14-ruff-enforcement)


## 📋 Quick Reference (ściąga)

### 5-grupowy porządek

```python
from __future__ import annotations      # 1. Future (ZAWSZE!)
import os                               # 2. Stdlib
import httpx                            # 3. Third-party
from myproject.config import Settings    # 4. Project absolute
from .types import Result                # 5. Relative
```

### Checklist

| ✅ Do | ❌ Don't |
|-------|---------|
| `annotations` na L1 | Pomijać annotations |
| 5 grup, sorted, puste linie | Chaotyczne importy |
| `from x import Y` | `from x import *` |
| `__all__` w każdym `__init__.py` | Brak `__all__` |
| TYPE_CHECKING dla heavy annotation-only imports | `import torch` na module level bez powodu |
| Relative wewnątrz pakietu (max `..`) | `from ...deep import X` |
| Standard alias (`np`, `pd`, `plt`) | Wymyślony alias (`import json as j`) |
| Lazy import + komentarz dlaczego | Lazy import bez wyjaśnienia |

### Import decision tree

```
Potrzebujesz import?
├── Tylko do type hints?        → TYPE_CHECKING  [TCH]
├── Heavy, opcjonalny?          → Lazy import + komentarz  [E402]
├── Ten sam pakiet?             → from .module import Y  [I001]
├── Inny pakiet w projekcie?    → from myproject.x import Y  [I001]
└── Zewnętrzny?                 → import x / from x import Y  [I001, F401]
```

---

## 1. Po co porządek importów

Importy to **wizytówka modułu** — pierwsze co czytasz. ruff sortuje automatycznie, ale musisz wiedzieć CO i DLACZEGO.

| Korzyść | Jak |
|---------|-----|
| **Szybki scan** | Wiesz w 2s jakie deps ma moduł |
| **Merge conflicts** | Sorted = mniej konfliktów |
| **Dead imports** | Łatwo zauważyć nieużywane |
| **CI green** | ruff wymusza porządek automatycznie |

---

## 2. 5-grupowy porządek

Każdy moduł Python — 5 grup oddzielonych pustą linią. **Kolejność jest NIEPRZYPADKOWA.**

| Grupa | Dlaczego taka kolejność |
|-------|------------------------|
| **1. `__future__`** | ZAWSZE pierwszy — zmienia semantykę Pythona na cały moduł |
| **2. Stdlib** | Niezależny — jeśli jest Python, jest stdlib |
| **3. Third-party** | Niezależne od Twojego projektu |
| **4. Project absolute** | Twój kod — zależy od stdlib + third-party |
| **5. Relative** | Zawsze ostatnie — lokalne, bezpośrednie (same package) |

```python
from __future__ import annotations      # 1️⃣ Future (ZAWSZE linia 1)

import os                               # 2️⃣ Stdlib
import sys
from pathlib import Path

import httpx                            # 3️⃣ Third-party
from loguru import logger
from pydantic import BaseModel

from myproject.config import Settings    # 4️⃣ Project (absolute)
from myproject.services import Engine

from .types import SearchResult         # 5️⃣ Relative (same package)
from .config import ServiceConfig
```

| Reguła | Detale |
|--------|--------|
| **Kolejność** | 1→2→3→4→5, pusta linia między grupami |
| **Sorted w grupie** | `import` przed `from`, potem alfabetycznie |
| **ruff config** | `known-first-party = ["myproject"]` w `pyproject.toml` |

### Troubleshooting

| Problem | Rozwiązanie |
|---------|-------------|
| Import w złej grupie | `ruff check --show-settings \| grep known` → dodaj do `known-first-party` |
| `I001` po edicie | Normalne — `ruff check --fix` |
| Import z dev-dep w prod | `F401` → usuń lub przenieś do TYPE_CHECKING |

---

## 3. `from __future__ import annotations`

> 📎 Szczegóły w `02-type-hints.md` (sekcja 3).

### ⛔ HARD RULE

```python
# ✅ KAŻDY moduł — MUSI być PIERWSZĄ instrukcją (po docstringu modułu)
from __future__ import annotations
```

**Dlaczego:** Forward references, TYPE_CHECKING, `X | Y` syntax na 3.9+, brak ewaluacji adnotacji w runtime.

---

## 4. `from x import y` vs `import x`

### Tabela decyzyjna

| Sytuacja | Styl | Przykład |
|----------|------|---------|
| Klasa/funkcja używana wielokrotnie | `from x import Y` | `from pathlib import Path` |
| Kilka rzeczy z jednego modułu | `from x import A, B` | `from dataclasses import dataclass, field` |
| Moduł z wieloma submodułami | `import x` | `import os` |
| Ryzyko kolizji nazw | `import x` lub alias | `import json` |
| Typing-only | `from typing import X` | `from typing import Final` |

### Multi-line imports

```python
# ✅ Więcej niż 3-4 elementy → wieloliniowy (max 120 znaków na linię)
from typing import (
    TYPE_CHECKING,
    Final,
    NamedTuple,
    Protocol,
    TypeVar,
)
```

> 💡 ruff automatycznie łamie za długie import linie.

---

## 5. Absolute vs relative imports

| Kontekst | Styl | Dlaczego |
|----------|------|----------|
| **Wewnątrz pakietu** | `from .x import Y` | Krótkie, refaktorowalne |
| **Między pakietami** | `from myproject.x import Y` | Jasne skąd pochodzi |
| **`__init__.py` re-exports** | `from .module import Class` | Public API pakietu |
| **Skrypty/CLI** (top-level) | `from myproject.x import Y` | Relative nie działa poza pakietem |

### ⛔ HARD RULE: Max 1 poziom `..`

```python
from ..utils import timer              # ✅ Jeden poziom wyżej — OK
from ...core.config import Settings    # ❌ Trzy kropki → użyj absolute import
```

> 💡 Relative imports działają TYLKO wewnątrz pakietów (folderów z `__init__.py`). Nie działają w standalone skryptach.

---

## 6. Star imports

### ⛔ NIGDY nie używaj `from x import *`

```python
from os.path import *            # ❌ Namespace pollution, shadowing, nieczytelność
from os.path import exists, join  # ✅ Jawnie wymieniasz co potrzebujesz
```

**Jedyny wyjątek:** `__init__.py` z `__all__` w module źródłowym — ale nawet wtedy jawne importy są lepsze.

---

## 7. `__all__` i public API

`__all__` definiuje **publiczne API** modułu — lista stringów:

```python
__all__ = ["Timer", "elapsed", "TIMER_PRECISION"]

class Timer: ...
def elapsed() -> float: ...
TIMER_PRECISION: Final[float] = 0.001
def _internal_helper() -> None: ...  # prywatne — NIE w __all__
```

### Re-exports + `__all__`: F401 Rule

```python
# ✅ Re-export w __init__.py — MUSI mieć __all__
from .config import Config
from .service import Service

__all__ = ["Config", "Service"]
# ruff rozumie: Config + Service w __all__ → nie "unused" (F401)
```

Bez `__all__` ruff uważa re-exportowane symbole za "unused imports" (F401). Rozwiązanie: `__all__` albo `# noqa: F401` per import.

### ⛔ HARD RULE: Każdy `__init__.py` MUSI mieć `__all__`

```python
__all__ = ["UserService", "UserConfig"]  # pakiet z API
__all__: list[str] = []                             # pusty pakiet
```

### Format

```python
# ✅ Literały stringów, sorted, trailing comma
__all__ = [
    "BATCH_SIZE",
    "Config",
    "process",
]

# ❌ Dynamiczne __all__ — nie rób tego
__all__ = [name for name in dir() if not name.startswith("_")]
```

| W `__all__`? | Element |
|-------------|---------|
| ✅ | Publiczne klasy, funkcje, stałe, typy |
| ❌ | `_private`, importy z cudzych pakietów |

> 💡 Importy w `__init__.py` wymagają `__all__` albo `# noqa: F401`. Preferuj `__all__` — komunikuje intencję.

---

## 8. Re-exports z `__init__.py`

`__init__.py` jako fasada — ukrywasz wewnętrzną strukturę:

```python
# myproject/services/user/__init__.py
from .config import UserConfig
from .service import UserService

__all__ = ["UserConfig", "UserService"]
```

```python
# ✅ Użytkownik importuje z pakietu, nie z głębokich ścieżek
from myproject.services.user import UserService
```

### Reguły

| Reguła | Dlaczego |
|--------|----------|
| Re-eksportuj TYLKO publiczne API | Nie wystawiaj wewnętrznych helperów |
| ZAWSZE definiuj `__all__` | Jasno mówi co jest public |
| Nie importuj heavy deps | `__init__.py` działa przy `import mypackage` — nie ładuj np. torch |
| Flat > deep | Lepiej `from myproject import X` niż `from myproject.a.b.c import X` |

> 💡 Każdy import na module level w `__init__.py` **wykonuje się** przy imporcie pakietu — uważaj na ciężkie operacje.

---

## 9. TYPE_CHECKING block

> 📎 Pełna dokumentacja w `02-type-hints.md` (sekcja 6). Tu tylko import-specific wzorce.

```python
from __future__ import annotations
from typing import TYPE_CHECKING, Final

if TYPE_CHECKING:
    import numpy as np
    from collections.abc import Callable
    from myproject.types import Result
```

| Przenoś ✅ | Nie przenoś ❌ |
|------------|---------------|
| Heavy deps TYLKO w adnotacjach (`numpy`, `torch`) | Typy używane w runtime (`isinstance()`, default values) |
| `collections.abc` (`Callable`, `Iterator`) | Dekoratory (`@dataclass`), bazowe klasy (`Protocol`) |
| Importy tworzące circular dependency | `Final` — bo `Final[int] = 5` jest runtime |

### ruff TCH rules

| Rule | Co robi |
|------|---------|
| `TCH001` | Third-party annotation-only → TYPE_CHECKING |
| `TCH002` | First-party annotation-only → TYPE_CHECKING |
| `TCH003` | Stdlib annotation-only → TYPE_CHECKING |

> 💡 Nie przenoś na siłę WSZYSTKIEGO. Przenoś gdy: (a) heavy, (b) circular, (c) ONLY in annotations.

---

## 10. Circular imports

Moduł A importuje B, B importuje A → `ImportError` lub `NameError`.

### Jak rozpoznać

| Symptom | Co widzisz |
|---------|-----------|
| `ImportError: cannot import name 'X' from partially initialized module` | Circular na module level |
| `NameError: name 'X' is not defined` | Circular z annotation-only ref |
| Import działa z CLI ale nie z pytest | Inna kolejność importowania |

### 4 strategie naprawy

#### 1. TYPE_CHECKING (najczęstsza)

Import potrzebny TYLKO do type hints:

```python
from __future__ import annotations
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from b import B  # nie istnieje w runtime

class A:
    def method(self) -> B: ...  # OK — string annotation
```

#### 2. Wydziel typy do osobnego modułu

```python
# types.py — zero importów z a.py i b.py
class AType(Protocol): ...
class BType(Protocol): ...
```

#### 3. Import w function body (ostateczność)

```python
class B:
    def method(self) -> A:
        from a import A  # cache'owany w sys.modules po pierwszym imporcie
        return A()
```

**Wady:** Trudniejsze do śledzenia, narzędzia nie widzą dependency.

#### 4. Refaktor architektury

Powtarzające się circulary → problem w architekturze. Rozważ: merge modułów, wspólna abstrakcja (Protocol/ABC), Dependency Inversion.

### Drzewo decyzyjne

```
Circular import?
├── Tylko do type hints?  → TYPE_CHECKING (1)
├── Oba moduły w runtime?
│   ├── Mały scope → types.py (2)
│   └── Duży scope → refaktor (4)
└── Jednorazowy w runtime? → function body (3)
```

---

## 11. Lazy imports

Import wewnątrz funkcji — wykonuje się TYLKO przy wywołaniu:

```python
def detect(image_path: str) -> list[int]:
    # Heavy dep — importuj tylko gdy potrzebne (startup time)
    import torch
    model = torch.load("model.pt")
```

| Kiedy ✅ | Kiedy ❌ |
|---------|---------|
| Heavy dep opcjonalny (`torch`, `cv2`) | Normalny, lekki import (`pathlib`, `json`) |
| Startup time krytyczny (CLI, API) | Import używany w wielu miejscach |
| Opcjonalny feature | Test files |
| Fix circular import (strategia 3) | — |

### ⛔ HARD RULE: Lazy import ZAWSZE z komentarzem dlaczego

```python
# ✅ Komentarz DLACZEGO lazy
def detect(path: str) -> list[int]:
    import torch  # heavy: ładowany tylko w GPU path
    ...

# ❌ Lazy bez wyjaśnienia
def detect(path: str) -> list[int]:
    import torch
    ...
```

### Optional dependency guard

Wzorzec dla deps, które mogą nie być zainstalowane:

```python
try:
    import torch
except ImportError:
    torch = None  # type: ignore[assignment]

def detect(path: str) -> list[int]:
    if torch is None:
        msg = "torch required for GPU detection — pip install torch"
        raise RuntimeError(msg)
    ...
```

**Różnica vs lazy import:** Guard sprawdza dostępność przy starcie modułu, lazy import odracza moment importu.

### Import side effects

```python
# ❌ Side effect na module level
db = connect_to_database()  # odpala się przy KAŻDYM imporcie modułu

# ✅ Inicjalizację rób w main()/setup()
def init_db() -> Database:
    return connect_to_database()
```

> 💡 Python cachuje moduły (`sys.modules`) — drugi `import torch` w tej samej sesji to tylko dict lookup.

---

## 12. Konwencjonalne aliasy

```python
import numpy as np              # de facto standard — ZAWSZE używaj
import pandas as pd
import matplotlib.pyplot as plt
import tensorflow as tf
import torch.nn as nn
import seaborn as sns
```

| ✅ Tak | ❌ Nie |
|-------|------|
| Standardowe: `np`, `pd`, `plt`, `tf`, `nn`, `sns` | Wymyślone: `import json as j` |
| Re-export alias: `router as detection_router` | — |

> 💡 Nie znasz standardowego aliasu? Nie twórz aliasu — pisz pełną nazwę.

---

## 13. Import Decision Tree

```
Potrzebujesz użyć coś w kodzie?
│
├─ Tylko w type hints (adnotacjach)?
│  └─ YES → TYPE_CHECKING block (sekcja 9)
│
├─ Heavy dependency (torch, cv2, pandas)?
│  ├─ Opcjonalny feature? → try/except + lazy (sekcja 11)
│  └─ Wolne na start? → Lazy import w function body
│
├─ Ten sam pakiet (internal)?
│  ├─ Wewnątrz pakietu → from .module import X
│  └─ Inny pakiet → from myproject.package import X
│
├─ Tworzy circular dependency? → TYPE_CHECKING lub refaktor (sekcja 10)
│
└─ Zewnętrzny pakiet → from package import X
```

### Torch + TYPE_CHECKING — case study

```python
from __future__ import annotations

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from torch import nn

def build_model(config: dict[str, int]) -> "nn.Sequential":
    """Tworzy model — torch import tylko gdy wywołane."""
    import torch  # Lazy — tylko jeśli ta funkcja jest wywoływana
    return torch.nn.Sequential(...)
```

**Dlaczego dwa importy?** TYPE_CHECKING → mypy autocomplete. Lazy w function → torch ładuje się TYLKO gdy `build_model()` jest wywoływana.

---

## 14. ruff enforcement

| Rule | Co robi | Auto-fix? |
|------|---------|-----------|
| `I001` | Import unsorted | ✅ |
| `I002` | Missing required import (konfigurowane w `required-imports`) | ✅ |
| `F401` | Unused import | ✅ |
| `TCH001-003` | Annotation-only → TYPE_CHECKING | ✅ |
| `E402` | Import not at top | ⚠️ Manual |

```toml
# pyproject.toml
[tool.ruff.lint.isort]
known-first-party = ["myproject"]
required-imports = ["from __future__ import annotations"]
```

```bash
# Sprawdź + napraw automatycznie
ruff check --fix --select I,F401,TCH myproject/
```

> 💡 `required-imports` automatycznie dodaje `annotations` import przy `--fix`. Ustawiasz raz, zapominasz.

---
## Źródła

- [PEP 8 — Imports](https://peps.python.org/pep-0008/#imports)
- [PEP 328 — Multi-Line and Absolute/Relative](https://peps.python.org/pep-0328/)
- [PEP 563 — Postponed Evaluation of Annotations](https://peps.python.org/pep-0563/)
- [Python docs — `__all__`](https://docs.python.org/3/tutorial/modules.html#importing-from-a-package)
- [ruff isort (I)](https://docs.astral.sh/ruff/rules/#isort-i)
- [ruff flake8-type-checking (TCH)](https://docs.astral.sh/ruff/rules/#flake8-type-checking-tch)
