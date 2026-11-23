# 00 — uv & Tooling

> **Cel:** Uniwersalny source of truth dla Python package management, lintingu, type checkingu i dev workflow.
> **Scope:** Ten plik jest PRZENOŚNY — pasuje do każdego nowego projektu Python. Nie zawiera konfiguracji specyficznej dla konkretnego repo.

---

## Spis treści

1. [uv — Komendy](#uv--komendy)
2. [pyproject.toml — Sekcje](#pyprojecttoml--sekcje)
3. [ruff — Linter & Formatter](#ruff--linter--formatter)
4. [mypy — Type Checker](#mypy--type-checker)
5. [pre-commit — Automatyzacja](#pre-commit--automatyzacja)
6. [Dev Workflow](#dev-workflow)
7. [.gitignore — Template](#gitignore--template)

> **pytest & coverage** → patrz `10-testing.md` (osobna sekcja, DRY)


## 📋 Quick Reference (ściąga)

```bash
# Nowy pakiet
uv init <pkg>                      # tworzy pyproject.toml + .venv + uv.lock
uv add <pkg>                       # dependency
uv add --dev <pkg>                 # dev tool

# Po git pull
uv sync

# Przed commitem (lub pre-commit robi automatycznie)
uv run ruff check --fix .          # lint + autofix
uv format                          # formatowanie
uv run mypy src/                   # type check
uv run pytest                      # testy

# Diagnostyka
uv tree                            # drzewo zależności
uv audit                           # security check
uv run ruff rule <CODE>            # nauka reguły
```


---

## 1. uv — Komendy

### Czym jest uv?

`uv` to ultra-szybki package manager od Astral (twórcy ruff). Zastępuje: `pip`, `pip-tools`, `pipenv`, `poetry`, `pyenv`, `pipx` — **jednym narzędziem**.

### Project management

| Komenda | Co robi | Kiedy używasz |
|---------|---------|---------------|
| `uv init` | Tworzy nowy projekt (`--app`, `--lib`, `--build-backend`) | Raz na projekt |
| `uv add <pkg>` | Dodaje dependency do `[project.dependencies]` | Za KAŻDYM razem gdy dodajesz pakiet |
| `uv add --dev <pkg>` | Dodaje do grupy `dev` w `[dependency-groups]` | Narzędzia deweloperskie (ruff, mypy, pytest) |
| `uv add --group <name> <pkg>` | Dodaje do nazwanej grupy (np. `lint`, `test`) | Organizacja dev deps w grupy |
| `uv add --optional <extra> <pkg>` | Dodaje do `[project.optional-dependencies]` | Feature extras (np. `[cuda]`, `[web]`) |
| `uv add -r requirements.txt` | Import zależności z pliku | Migracja ze starego projektu |
| `uv remove <pkg>` | Usuwa dependency (`--dev`/`--group`/`--optional`) | Usuwanie pakietu |
| `uv sync` | Instaluje lockfile do `.venv` | Po `git pull`, odtworzenie env |
| `uv sync --exact` | j.w. + usuwa pakiety których nie ma w lockfile | Czysty env, CI |
| `uv lock` | Tworzy/aktualizuje `uv.lock` bez instalacji | Zwykle automatyczne po `uv add` |
| `uv run <cmd>` | Odpala komendę w kontekście projektu (auto-sync) | Uruchamianie czegokolwiek |
| `uv run --with <pkg> <cmd>` | Odpala z ad-hoc dep bez dodawania do projektu | Jednorazowy script |
| `uv tree` | Drzewo zależności (kto wymaga kogo) | Debugging dependency conflicts |
| `uv export` | Eksportuje lockfile → `requirements.txt` / `pylock.toml` | Docker, deploy, CI bez uv |
| `uv version` | Wyświetla/zmienia wersję (`--bump major/minor/patch`) | Release management |
| `uv audit` | Sprawdza znane podatności (CVE) w zależnościach | Bezpieczeństwo, CI |
| `uv format` | Wrapper na `ruff format` — formatuje kod | Code style |
| `uv build` | Buduje sdist/wheel (`--sdist`, `--wheel`) | Pakowanie do dystrybucji |
| `uv publish` | Upload do PyPI / custom index | Publikacja pakietu |

### Python management

| Komenda | Co robi | Kiedy używasz |
|---------|---------|---------------|
| `uv python install <ver>` | Instaluje Python (np. `3.12`, `3.13`) | Potrzebujesz konkretnej wersji |
| `uv python list` | Lista dostępnych instalacji | Sprawdzenie co masz / co dostępne |
| `uv python pin <ver>` | Zapisuje wymaganą wersję do `.python-version` | Fiks wersji dla repo |
| `uv python upgrade` | Upgrade do najnowszego patcha | Bezpieczeństwo |
| `uv python find` | Szuka interpretera na systemie | Debugging |

> 💡 **`.python-version` vs `requires-python`:** `.python-version` (`uv python pin`) = pin dla **developerów** („użyj tej wersji”). `requires-python` w pyproject.toml = constraint dla **userów/CI** („minimum X”). Oba mogą współistnieć.

### pip-compatible (low-level)

> **Kiedy używać?** Gdy pracujesz z legacy projektem bez `pyproject.toml`, w Docker, albo w CI bez uv project mode.

| Komenda | Odpowiednik pip |
|---------|----------------|
| `uv pip install <pkg>` | `pip install <pkg>` |
| `uv pip compile` | `pip-compile` (pip-tools) |
| `uv pip sync` | `pip-sync` (pip-tools) |
| `uv pip list` | `pip list` |
| `uv pip freeze` | `pip freeze` |
| `uv pip show <pkg>` | `pip show <pkg>` |
| `uv pip tree` | `pipdeptree` |
| `uv pip check` | `pip check` |
| `uv pip uninstall <pkg>` | `pip uninstall <pkg>` |

### Global tools (jak pipx)

| Komenda | Co robi |
|---------|---------|
| `uv tool install <pkg>` | Instaluje CLI tool globalnie (izolowany env) |
| `uv tool run <pkg>` / `uvx <pkg>` | Jednorazowe uruchomienie bez instalacji |
| `uv tool list` | Lista zainstalowanych global tools |

### Maintenance

| Komenda | Co robi |
|---------|---------|
| `uv self update` | Aktualizacja uv do najnowszej wersji |
| `uv cache clean` | Czyści cache (odzyskuje dysk) |
| `uv cache dir` | Pokazuje lokalizację cache |
| `uv auth login` | Logowanie do prywatnego indeksu (PyPI, Artifactory) |

### Zmienne środowiskowe (CI / Docker)

| Zmienna | Co robi | Kiedy |
|---------|---------|-------|
| `UV_PYTHON=3.12` | Default Python version | CI bez `.python-version` |
| `UV_CACHE_DIR=/tmp/uv-cache` | Lokalizacja cache | CI — cache mount |
| `UV_NO_CACHE=1` | Wyłącza cache | Ephemeral CI runners |
| `UV_LINK_MODE=copy` | Kopiuj zamiast hardlink | Docker (cross-filesystem) |
| `UV_FROZEN=1` | Fail jeśli lockfile outdated | CI — gwarancja reproducibility |
| `UV_COMPILE_BYTECODE=1` | Tworzy `.pyc` przy instalacji | Docker — szybszy cold start |

### ⛔ HARD RULES

- **NIGDY** ręcznie edytuj `[project.dependencies]`, `[project.optional-dependencies]` ani `[dependency-groups]` w pyproject.toml
- **ZAWSZE** używaj `uv add` / `uv remove` — pilnuje spójności lockfile i pyproject.toml
- **NIGDY** `pip install` w projekcie uv — użyj `uv add` lub `uv pip install`

### Co commitować, co .gitignore?

| Plik | Git | Dlaczego |
|------|-----|----------|
| `pyproject.toml` | ✅ commit | Definicja projektu |
| `uv.lock` | ✅ commit | Reproducible builds |
| `.python-version` | ✅ commit | Pin wersji Pythona |
| `.venv/` | ❌ .gitignore | Lokalne środowisko |

### ⛔ `uv.lock` — reproducibility requirement

`uv.lock` jest **OBOWIĄZKOWY** w CI/CD i deploymencie. Zawiera dokładne wersje WSZYSTKICH zależności łącznie z transitywnymi.

```bash
# CI — gwarancja że instalujesz dokładnie to co developerzy testowali
uv sync --frozen --all-groups  # fail jeśli lock jest outdated
```

| Scenario | Komenda | Co robi |
|----------|---------|----------|
| Dev | `uv add numpy` | Auto-aktualizuje `uv.lock` |
| CI/CD | `UV_FROZEN=1 uv sync` | Fail jeśli `uv.lock` nie pokrywa `pyproject.toml` |
| Docker | `--frozen` flag | Gwarancja reprodukowanego build-u |
| Deploy | `uv export --frozen` | Export lock → vendored requirements.txt |

---

## 2. pyproject.toml — Sekcje

### Czym jest pyproject.toml?

Jeden plik konfiguracyjny, który **zastępuje 7+ starych plików**: `setup.py`, `setup.cfg`, `requirements.txt`, `.flake8`, `mypy.ini`, `pytest.ini`, `tox.ini`. Standard PEP 621.

### `[project]` — Metadane projektu

```toml
[project]
name = "my-project"
version = "0.1.0"
description = "What this project does"
requires-python = ">=3.12"                # Minimalna wersja Pythona
dependencies = [
    "httpx>=0.27,<1",        # Wersjonowanie: >=min,<next_major
    "pydantic>=2.0,<3",
]
```

**Dlaczego `>=X,<Y`?** — Semver: kompatybilność w ramach major version. `>=0.27,<1` = "od 0.27 do 0.x, ale nie 1.0".

> Pozostałe pola (`license`, `authors`, `keywords`, `classifiers`) — patrz [PEP 621](https://peps.python.org/pep-0621/).

### `[project.optional-dependencies]` — Feature extras

```toml
[project.optional-dependencies]
cuda = ["torch[cuda]>=2.2"]
cpu = ["torch>=2.2"]
web = ["fastapi>=0.115", "uvicorn>=0.34"]
all = ["my-project[cuda,web]"]         # Combo extra
```

- Instalacja: `uv add --optional cuda torch[cuda]` → `pip install my-project[cuda]`
- **NIE** do dev deps — do tego `[dependency-groups]`

### `[dependency-groups]` — Dev dependencies (PEP 735)

```toml
[dependency-groups]
dev = [
    { include-group = "lint" },      # Grupy mogą includeować inne!
    { include-group = "test" },
    { include-group = "type" },
]
lint = ["ruff>=0.15"]
test = ["pytest>=8", "coverage[toml]>=7"]
type = ["mypy>=1.20"]
docs = ["mkdocs-material>=9"]
```

| Komenda | Efekt |
|---------|-------|
| `uv add --dev ruff` | Dodaje do `dev` group |
| `uv add --group lint ruff` | Dodaje do `lint` group |
| `uv sync --group lint --group test` | Instaluje tylko wybrane grupy |
| `uv sync --all-groups` | Instaluje wszystkie grupy |
| `uv sync --no-dev` | Bez dev deps (production) |

### `[tool.uv]` — uv-specific config

```toml
[tool.uv]
default-groups = ["dev"]               # Grupy instalowane domyślnie

[tool.uv.sources]
# Override sources w developmencie (git, path, workspace)
some-lib = { path = "../some-lib", editable = true }
```

### `[build-system]` — Jak budować pakiet

```toml
[build-system]
requires = ["hatchling"]               # Build backend
build-backend = "hatchling.build"
```

> Potrzebne tylko jeśli budujesz pakiet (library). Dla aplikacji bez dystrybucji — opcjonalne.

### `[project.scripts]` — CLI entry points

```toml
[project.scripts]
my-cli = "my_project.cli:main"    # `uv run my-cli` lub po aktywacji: `my-cli`
```

**Czym jest?** Mapuje nazwę komendy → funkcja Python. Po `uv sync`, komenda jest dostępna w `.venv/bin/` (Linux) lub `.venv/Scripts/` (Windows).

---

## 3. ruff — Linter & Formatter

### Czym jest ruff?

**Linter + formatter w jednym** od Astral. Jest 10-100x szybszy od flake8/black/isort/pylint razem wziętych — bo napisany w Rust. Zastępuje: `flake8`, `black`, `isort`, `pylint`, `pyflakes`, `pycodestyle`, `pydocstyle`, `bandit`, i wiele innych.

### Jak to działa?

ruff ma **kategorie reguł** (prefixes). Każda kategoria to jakby "wtyczka" sprawdzająca inny aspekt kodu:

- `F` = Pyflakes (bugs) — np. `F401` = "importujesz coś czego nie używasz"
- `S` = Bandit (security) — np. `S101` = "używasz `assert` w kodzie production"
- `D` = pydocstyle (docstrings) — np. `D100` = "moduł nie ma docstringa"

**Format kodu reguły:** `{PREFIX}{NUMER}` — prefix = kategoria, numer = konkretna reguła.

### Jak uczyć się reguł?

```bash
uv run ruff rule F401           # Wyjaśnienie jednej reguły z przykładami
uv run ruff linter              # Lista wszystkich kategorii / pluginów
uv run ruff check --show-fixes . # Pokazuje CO ruff naprawiłby (bez naprawiania)
uv run ruff check --diff .      # Diff: jak kod wyglądałby po fixie (CI dry-run)
```

> 💡 **Tip:** `ruff rule <code>` to najszybszy sposób nauki — wyświetla opis reguły, przykład złego i dobrego kodu, link do docs.

### Jak czytać priorytet?

| Symbol | Tier | Znaczenie | Kiedy włączyć |
|--------|------|-----------|---------------|
| 🔴 | **MUSISZ** | Łapie bugi, security issues, broken code | Każdy projekt od dnia 1 |
| 🟡 | **POWINIENEŚ** | Jakość kodu, czytelność, maintainability | Poważny projekt, zespół |
| 🟢 | **FAJNIE MIEĆ** | Styl, niszowe, domain-specific | Gdy framework tego wymaga |

### 🔴 TIER 1 — MUSISZ (bugs, security, broken code)

Te reguły łapią **prawdziwe problemy**: bugi, luki bezpieczeństwa, martwy kod.

| Prefix | Nazwa | Co łapie (po ludzku) | Przykład problemu |
|--------|-------|---------------------|-------------------|
| **F** | Pyflakes | Import którego nie używasz, zmienna która nie istnieje, zdefiniowałeś coś dwa razy | `import os` (ale nigdy nie użyłeś `os`) |
| **E** | pycodestyle Error | Złe wcięcia, błędy składni stylu | Tab zamiast spacji, brak spacji po `:` |
| **W** | pycodestyle Warning | Trailing whitespace, zbyt wiele pustych linii | Spacja na końcu linii, 3 blank lines zamiast 2 |
| **I** | isort | Importy nieposortowane / niezgrupowane | `import os` po `import numpy` zamiast przed |
| **N** | pep8-naming | Zła konwencja nazw: klasa nie CamelCase, funkcja nie snake_case | `class myClass` zamiast `class MyClass` |
| **UP** | pyupgrade | Stary syntax Pythona — jest nowszy, lepszy | `dict()` → `{}`, `"{}".format(x)` → `f"{x}"` |
| **B** | flake8-bugbear | Typowe bugi: mutable default, unreliable `len()` check | `def f(x=[]):` — bug! lista jest współdzielona |
| **S** | flake8-bandit | Security: hardcoded hasła, `eval()`, pickle, SQL injection | `password = "admin123"` w kodzie źródłowym |
| **BLE** | flake8-blind-except | `except:` / `except Exception:` — łapie za dużo, ukrywa bugi | `except: pass` — ukrywasz KAŻDY błąd |
| **G** | flake8-logging-format | f-string/format w logging — gubimy lazy evaluation | `logging.info(f"val={x}")` → `logging.info("val=%s", x)` |
| **T20** | flake8-print | `print()` w production code — powinien used logging | `print("debug")` zapomniane w PR |
| **PGH** | pygrep-hooks | `eval()`, blanket `type: ignore`, blanket `noqa` | `# type: ignore` bez kodu błędu |
| **RUF** | Ruff-specific | Ambiguous unicode, unused `noqa`, Ruff-only rules | `ℓ = 1` — to nie `l`, to unicode `ℓ` |

### 🟡 TIER 2 — POWINIENEŚ (jakość, czytelność, maintainability)

Te reguły robią kod **czystszym i łatwiejszym do utrzymania**. Nie łapią bugów, ale zapobiegają problemom.

| Prefix | Nazwa | Co poprawia (po ludzku) | Przykład |
|--------|-------|------------------------|----------|
| **C4** | flake8-comprehensions | Niepotrzebne list/dict/set wrapping | `list([x for x in y])` → `[x for x in y]` |
| **D** | pydocstyle | Brakujące/źle sformatowane docstringi | Funkcja publiczna bez opisu |
| **ANN** | flake8-annotations | Brak type annotations | `def f(x):` zamiast `def f(x: int) -> str:` |
| **PL** | Pylint | 4 sub-kategorie: **PLC** (convention), **PLE** (error), **PLR** (refactoring), **PLW** (warning). Zbyt wiele argumentów, za duża złożoność | `def f(a,b,c,d,e,f,g,h,i):` → za dużo args (PLR0913) |
| **C90** | mccabe | Za duża cyclomatic complexity | 20 zagnieżdżonych `if/else` |
| **SIM** | flake8-simplify | Kod do uproszczenia | `if x == True:` → `if x:` |
| **RET** | flake8-return | Niepotrzebny `else` po `return` | `if x: return 1; else: return 2` → `if x: return 1; return 2` |
| **PTH** | flake8-use-pathlib | `os.path` zamiast nowoczesnego `pathlib` | `os.path.join(a, b)` → `Path(a) / b` |
| **PT** | flake8-pytest-style | pytest best practices | Fixture bez `@pytest.fixture`, `pytest.raises` bez `match` |
| **TRY** | tryceratops | Exception handling: za długi `try`, brak `raise from`, zbyt ogólny `except` | ❌ `try: ...100 linii... except:` ✅ `try: x() except ValueError as e: raise AppError from e` |
| **TC** | flake8-type-checking | Import tylko do typów — powinien być pod `if TYPE_CHECKING` | Import pydantic modelu tylko do annotacji |
| **ISC** | flake8-implicit-str-concat | Niejawne sklejanie stringów | `("hello " "world")` — celowe czy bug? |
| **PERF** | Perflint | Performance anti-patterns | `for x in list(dict.keys())` → `for x in dict` |
| **LOG** | flake8-logging | Problemy z modułem logging | `logging.warn()` → `logging.warning()` |

### 🟢 TIER 3 — FAJNIE MIEĆ (styl, niszowe, domain-specific)

Opcjonalne — włączaj selektywnie per projekt. Pogrupowane tematycznie:

**🐍 Modern Python & Code Quality:**

| Prefix | Nazwa | Co robi |
|--------|-------|---------|
| **EM** | flake8-errmsg | String literal w `raise` → wymusza zmienne |
| **FBT** | flake8-boolean-trap | Boolean jako positional arg → wymusza keyword |
| **ARG** | flake8-unused-arguments | Unused function args |
| **ERA** | eradicate | Zakomentowany kod |
| **A** | flake8-builtins | Shadowing builtins (`list`, `dict`, `type`) |
| **FLY** | flynt | String concat → f-string |
| **FURB** | refurb | Modern Python idioms |
| **SLF** | flake8-self | Dostęp do prywatnych atrybutów `_internal` |
| **RSE** | flake8-raise | Zbędne `raise` parentheses |
| **SLOT** | flake8-slots | Brak `__slots__` w classes |

**📝 Style & Formatting:**

| Prefix | Nazwa | Co robi |
|--------|-------|---------|
| **COM** | flake8-commas | Trailing commas |
| **Q** | flake8-quotes | Styl cudzysłowów |
| **CPY** | flake8-copyright | Copyright header |
| **EXE** | flake8-executable | Shebang/encoding |

**📋 Documentation & TODOs:**

| Prefix | Nazwa | Co robi |
|--------|-------|---------|
| **DOC** | pydoclint | Docstring ↔ podpis sync |
| **FIX** | flake8-fixme | Wykrywa FIXME/TODO/HACK |
| **TD** | flake8-todos | Egzekwuje format TODO |

**📦 Import & Compatibility:**

| Prefix | Nazwa | Co robi |
|--------|-------|---------|
| **FA** | flake8-future-annotations | `from __future__ import annotations` (Python <3.12) |
| **TID** | flake8-tidy-imports | Banned/relative imports |
| **ICN** | flake8-import-conventions | Alias: `np`, `pd`, `plt` |

**⚡ Domain-Specific (per framework):**

| Prefix | Framework | Co robi |
|--------|-----------|---------|
| **FAST** | FastAPI | FastAPI-specific rules |
| **DJ** | Django | Django-specific rules |
| **NPY** | NumPy | Deprecated NumPy API |
| **PD** | Pandas | Pandas anti-patterns |
| **ASYNC** | asyncio | Async anti-patterns |
| **DTZ** | datetime | `datetime.now()` bez timezone |
| **PYI** | typing | `.pyi` stub files |

### Jak wybrać reguły dla swojego projektu?

**Krok 1:** Zacznij od Tier 1 🔴 — zawsze, każdy projekt:

```toml
select = ["F", "E", "W", "I", "N", "UP", "B", "S", "BLE", "G", "T20", "PGH", "RUF"]
```

**Krok 2:** Dodaj Tier 2 🟡 — gdy projekt jest poważny (nie jednodniowy skrypt):

```toml
select = [
    # Tier 1
    "F", "E", "W", "I", "N", "UP", "B", "S", "BLE", "G", "T20", "PGH", "RUF",
    # Tier 2
    "C4", "SIM", "RET", "PTH", "PT", "TRY", "PERF", "PL", "LOG",
    # Tier 2 — jeśli masz type hints → "ANN", "TC"
    # Tier 2 — jeśli masz docstringi → "D"
    # Tier 2 — opcjonalnie → "ISC" (implicit str concat), "C90" (complexity)
]
```

**Krok 3:** Dodaj Tier 3 🟢 — per projekt, per framework:
- ML projekt? → `"NPY"`, `"PD"`, `"ICN"`
- FastAPI? → `"FAST"`
- Python <3.12? → `"FA"`

### Rekomendowana konfiguracja (Universal Starter)

Skopiuj do nowego projektu i dostosuj `target-version` i `line-length` do swoich potrzeb.

```toml
[tool.ruff]
target-version = "py312"     # ← dostosuj do requires-python
line-length = 88             # ← 88 (default ruff/black) lub 120 (szerokie monitory)
indent-width = 4

[tool.ruff.lint]
select = [
    # ── 🔴 Tier 1: MUSISZ ─────────────────
    "F",      # Pyflakes — unused imports, undefined names
    "E", "W", # pycodestyle — errors + warnings
    "I",      # isort — import sorting
    "N",      # pep8-naming — naming conventions
    "UP",     # pyupgrade — modern Python syntax
    "B",      # flake8-bugbear — common bugs
    "S",      # flake8-bandit — security issues
    "BLE",    # flake8-blind-except — overboard exception catching
    "G",      # flake8-logging-format — proper logging
    "T20",    # flake8-print — no print() in production
    "PGH",    # pygrep-hooks — no blanket type:ignore/noqa
    "RUF",    # Ruff-specific — ambiguous unicode, unused noqa
    # ── 🟡 Tier 2: POWINIENEŚ ─────────────
    "C4",     # flake8-comprehensions — clean comprehensions
    "SIM",    # flake8-simplify — simplify code
    "RET",    # flake8-return — clean returns
    "PTH",    # flake8-use-pathlib — modern path handling
    "PT",     # flake8-pytest-style — pytest best practices
    "TRY",    # tryceratops — exception handling patterns
    "PERF",   # Perflint — performance anti-patterns
    "PL",     # Pylint — PLC/PLE/PLR/PLW checks
    "LOG",    # flake8-logging — logging module issues
    # ── Tier 2 opcjonalne (odkomentuj gdy potrzebujesz) ──
    # "D",    # pydocstyle — docstring rules (wymaga: convention = "google")
    # "ANN",  # flake8-annotations — type hint enforcement
    # "TC",   # flake8-type-checking — TYPE_CHECKING optimization
    # "ISC",  # flake8-implicit-str-concat — niejawne sklejanie stringów
    # "C90",  # mccabe — complexity control (wymaga: max-complexity)
]
ignore = [
    # ── Pragmatyczne wyjątki ──
    "PLR0913",  # Too many arguments — normalne w config functions / __init__
    "PLR2004",  # Magic value comparison — za głośne; `if status == 200:` jest czytelne
    "TRY003",   # Long message in exception — osobna klasa na każdy msg to overengineering
    # ── Odkomentuj jeśli włączysz "EM" (flake8-errmsg) w select ──
    # "EM101",  # String literal in raise — pragmatycznie OK
    # "EM102",  # f-string in raise — j.w.
    # ── Opcjonalne (odkomentuj jeśli włączyłeś D) ──
    # "D100",   # Missing module docstring — nie każdy moduł potrzebuje docstring
    # "D104",   # Missing __init__.py docstring — prawie nigdy
    # "D105",   # Missing magic method docstring — __repr__ nie potrzebuje
    # "D107",   # Missing __init__ docstring — class docstring wystarczy
]

[tool.ruff.lint.per-file-ignores]
# Testy: assert OK — S101 jest włączone globalnie, wyłączamy tylko w testach
"tests/**" = ["S101"]
# Skrypty/CLI: print() OK
"scripts/**" = ["T20"]
# __init__.py: re-export OK
"__init__.py" = ["F401"]
# Migracje / generated code
# "migrations/**" = ["ALL"]

[tool.ruff.lint.pydocstyle]
# Aktywne tylko gdy "D" odkomentowane w select
convention = "google"

[tool.ruff.lint.isort]
known-first-party = ["my_project"]  # ← nazwa twojego pakietu
# known-third-party = []            # Zwykle auto-detected przez ruff
# section-order = ["future", "standard-library", "third-party", "first-party", "local-folder"]

[tool.ruff.lint.pylint]
max-args = 8                 # Domyślnie 5; 8 to pragmatyczny próg

[tool.ruff.lint.mccabe]
# Aktywne tylko gdy "C90" odkomentowane w select
max-complexity = 12           # Domyślnie 10; 12 daje margines

[tool.ruff.format]
quote-style = "double"        # Zgodne z PEP 8 recommendation
indent-style = "space"        # Zawsze spacje, nigdy taby
skip-magic-trailing-comma = false
line-ending = "auto"          # \n na Unix, \r\n na Windows
docstring-code-format = true  # Formatuje code blocks w docstringach
```

### Anatomia per-file-ignores

`per-file-ignores` to mechanizm **kontekstowych wyjątków**. Zamiast robić `# noqa` w każdym pliku, mówisz ruff: "w tych plikach/folderach, te reguły nie obowiązują":

```toml
[tool.ruff.lint.per-file-ignores]
# Wzorzec: "ścieżka/glob" = ["RULE1", "RULE2"]

"tests/**" = ["S101"]          # assert jest OK w testach
"scripts/**" = ["T20"]         # print() jest OK w skryptach CLI
"__init__.py" = ["F401"]       # re-exporty nie są "unused imports"
"external/**" = ["ALL"]        # vendored/external code — nie lintujemy
"**/migrations/**" = ["ALL"]   # auto-generated migrations
```

**Zasada:** `per-file-ignores` > `# noqa` w pojedynczym pliku. Używaj `# noqa: RULE` TYLKO gdy wyjątek dotyczy jednej konkretnej linii i nie da się go zgeneralizować na cały folder.

### Zaawansowane: ruff config tips

| Tip | Co | Kiedy |
|-----|----|-------|
| `ruff.toml` | Standalone config (zamiast `[tool.ruff]` w pyproject.toml) | Monorepo, shared config |
| `extend = "../base-ruff.toml"` | Dziedziczenie configu | Monorepo — base + per-project overrides |
| `target-version` | Auto-detected z `requires-python` jeśli nie podasz | Gdy chcesz nadpisać |

---

## 4. mypy — Type Checker

### Czym jest mypy?

Sprawdza **poprawność type annotations** bez uruchamiania kodu. Łapie bugi których linter nie widzi — np. "ta funkcja zwraca `str`, ale próbujesz ją traktować jako `int`".

### Co daje `strict = true`?

`strict` włącza ~15 flag naraz. Najważniejsze:

| Flaga | Co robi (po ludzku) |
|-------|---------------------|
| `disallow_untyped_defs` | Każda funkcja MUSI mieć type hints |
| `disallow_any_generics` | `list` → `list[str]` (musi być specyficzny) |
| `warn_return_any` | Ostrzega gdy zwracasz `Any` |
| `no_implicit_reexport` | Import w `__init__.py` musi być explicit |
| `check_untyped_defs` | Sprawdza ciała nawet nieannotowanych funkcji |
| `strict_equality` | Porównywanie niezgodnych typów → error |

### Rekomendowana konfiguracja (Universal Starter)

```toml
[tool.mypy]
strict = true                     # Włącza ~15 strict flags
warn_unreachable = true           # Wykrywa martwy kod
pretty = true                     # Czytelniejsze errory
show_error_codes = true           # Pokazuje kody errorów (np. [assignment])
show_error_code_links = true      # Linki do dokumentacji
python_version = "3.12"           # ← dostosuj do requires-python
enable_error_code = ["deprecated"]  # Ostrzega o deprecated API

# ── Per-module overrides ──

# 3rd party bez stubów — odkomentuj i dodaj swoje pakiety
# [[tool.mypy.overrides]]
# module = ["torch", "torch.*", "cv2", "cv2.*"]
# ignore_missing_imports = true

# Testy — mogą mieć untyped fixtures
[[tool.mypy.overrides]]
module = ["tests.*"]
disallow_untyped_defs = false

# Vendored / external code — nie sprawdzamy
[[tool.mypy.overrides]]
module = ["vendored.*", "external.*"]
ignore_errors = true
```

### Kiedy potrzebujesz overrides?

Nie każdy pakiet ma type stubs, nie każdy moduł jest w pełni otypowany. Overrides pozwalają **poluzować reguły** w konkretnych miejscach:

| Sytuacja | Override |
|----------|---------|
| Library nie ma type stubów | `ignore_missing_imports = true` |
| Testy — fixtures bez typów | `disallow_untyped_defs = false` |
| Vendored code — nie twoje | `ignore_errors = true` |
| Legacy moduł — stopniowa migracja | `disallow_untyped_defs = false` |

### Dodatkowe przydatne flagi

| Flaga | Co robi | Kiedy |
|-------|---------|-------|
| `warn_unreachable` | Wykrywa unreachable code | Zawsze warto |
| `enable_error_code = ["deprecated"]` | Ostrzega o deprecated API | Warto |
| `plugins = ["pydantic.mypy"]` | Rozumie pydantic models | Gdy używasz pydantic |
| `local_partial_types` | Strict None-inference | Przyszły default w mypy 2.0 |

> 💡 **Tip:** Pierwszy raz odpalasz mypy i dostajesz `missing stubs`? Użyj `uv run mypy --install-types` — auto-instaluje brakujące type stuby.

---

## 5. pre-commit — Automatyzacja

### Czym jest pre-commit?

Framework, który **uruchamia linter + formatter PRZED każdym commitem**. Nie musisz pamiętać o `ruff check` — git robi to za ciebie. Jeśli coś nie przejdzie, commit jest blokowany.

```yaml
# .pre-commit-config.yaml
repos:
  # Podstawowe hooki (trailing whitespace, EOF, YAML/TOML syntax)
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-toml
      - id: check-merge-conflict

  # ruff: lint + format
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.15.9              # ← zaktualizuj: uv run ruff version
    hooks:
      - id: ruff              # Linter z autofix
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format       # Formatter

  # mypy — local hook (lepsza integracja z zależnościami projektu)
  - repo: local
    hooks:
      - id: mypy
        name: mypy
        entry: uv run mypy
        language: system
        types: [python]
        args: [--strict]
```

**Setup:**

```bash
uv add --dev pre-commit
uv run pre-commit install          # Aktywuje hooki w .git/
uv run pre-commit run --all-files  # Jednorazowo na całym repo
```

---

## 6. Dev Workflow

> Każda zmiana przechodzi: lint → format → type check → test → commit. pre-commit automatyzuje 2-4.

### Codzienna pętla

```
1. Edytujesz plik
     ↓
2. uv run ruff check --fix .     ← lint + autofix
     ↓
3. uv format                     ← formatowanie (lub uv run ruff format .)
     ↓
4. uv run mypy src/              ← type check
     ↓
5. uv run pytest tests/          ← testy
     ↓
6. git commit                    ← pre-commit automatycznie robi 2-4
```

### Kluczowe komendy do zapamiętania

| Sytuacja | Komenda |
|----------|---------|
| Dodajesz pakiet | `uv add <pkg>` |
| Dodajesz dev tool | `uv add --dev <pkg>` |
| Po `git pull` | `uv sync` |
| Czysty env | `uv sync --exact` |
| Sprawdź security | `uv audit` |
| Update uv | `uv self update` |
| Formatuj | `uv format` |
| Lint | `uv run ruff check --fix .` |
| Type check | `uv run mypy src/` |
| Testy | `uv run pytest` |

### CI (GitHub Actions — minimal starter)

```yaml
# .github/workflows/check.yml
name: Check
on: [push, pull_request]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v6
        with:
          enable-cache: true        # Cache .uv między runami
      - run: uv sync --frozen --all-groups
      - run: uv run ruff check .
      - run: uv run ruff format --check .
      - run: uv run mypy src/
      - run: uv run pytest
```

> `--frozen` = fail jeśli `uv.lock` nie jest aktualny z `pyproject.toml`. Wymusza reproducibility.

---

## 7. .gitignore — Template

### Co commitować, co ignorować?

| Plik / Folder | Git | Dlaczego |
|---------------|-----|----------|
| `pyproject.toml` | ✅ commit | Definicja projektu |
| `uv.lock` | ✅ commit | Reproducible builds (`--frozen` w CI) |
| `.python-version` | ✅ commit | Pin wersji Pythona (`uv python pin`) |
| `.env.example` | ✅ commit | Template sekretów (bez wartości) |
| `.venv/` | ❌ ignore | Lokalne środowisko (regenerowalne: `uv sync`) |
| `.env` | ❌ ignore | Sekrety, konfiguracja lokalna |
| `dist/`, `build/` | ❌ ignore | Build artefakty (`uv build`) |
| `.ruff_cache/` | ❌ ignore | Auto-regenerowane |
| `.mypy_cache/` | ❌ ignore | Auto-regenerowane |
| `.pytest_cache/` | ❌ ignore | Auto-regenerowane |
| `.coverage`, `htmlcov/` | ❌ ignore | Artefakty testów |
| `.pypirc` | ❌ ignore | Credentials do PyPI (API tokeny) |
| `.dmypy.json` | ❌ ignore | mypy daemon artifacts |

### Legacy entries — CO USUNĄĆ z GitHub template

Domyślny GitHub Python .gitignore ma ~200 linii. Większość to legacy z ery setuptools/buildout. Z `uv` **nie potrzebujesz**:

| Entry | Dlaczego zbędne |
|-------|-----------------|
| `pip-log.txt`, `pip-delete-this-directory.txt` | Artefakty `pip` — uv ich nie tworzy |
| `develop-eggs/`, `.eggs/`, `eggs/`, `.installed.cfg` | `setup.py develop` — martwa technologia |
| `lib/`, `lib64/`, `parts/`, `var/`, `share/python-wheels/` | `zc.buildout` — lata 2000-2010 |
| `sdist/`, `wheels/` | Pokryte przez `dist/` |
| `MANIFEST` | `distutils` — uv tego nie tworzy |
| `.Python` | Stary virtualenv artifact |
| `venv/`, `ENV/`, `env/`, `env.bak/`, `venv.bak/` | Redundantne — uv używa `.venv/` |
| `celerybeat-schedule`, `.scrapy`, `.webassets-cache` | Framework-specific — dodawaj PER PROJECT |
| `.pdm-python`, `.pdm-build/`, `.pixi`, `Pipfile.lock` | Inne package managers — nie używasz ich |
| `*.sage.py`, `*.mo`, `*.pot` | Niszowe — dodawaj tylko jeśli używasz |
| Komentarze z linkami do pypa/pipenv | Nie potrzebujesz tutoriala w .gitignore |

### Styl komentarzy

Używaj Unicode box-drawing separatorów — czytelne, profesjonalne:

```gitignore
# ── Nazwa Sekcji ──────────────────────────────────────────────────────────────

entry_1/
*.pattern
# NOTE: wyjaśnienie dla ważnych wyjątków
```

Dla nagłówka projektu — **nie używaj**. `.gitignore` nie potrzebuje bannera z nazwą projektu ani opisem stacku. Zacznij od pierwszej sekcji.

### Porządek sekcji (zalecany)

1. **Runtime** — `__pycache__/`, `*.py[codz]`, `*.so`
2. **Build** — `dist/`, `build/`, `*.egg-info/`
3. **Virtual Env** — `.venv/`
4. **Testing** — `.pytest_cache/`, `.hypothesis/`, `.coverage`
5. **Tool Caches** — `.ruff_cache/`, `.mypy_cache/`
6. **IDE** — `.vscode/`, `.idea/`, `*.swp`
7. **Jupyter** — `.ipynb_checkpoints/`
8. **OS** — `.DS_Store`, `Thumbs.db`
9. **Secrets** — `.env`, `.env.local`
10. **Logs** — `logs/`, `*.log`
11. **Temp** — `*.tmp`, `*.cache`
12. **Binary assets** (per project) — images, video, audio, models, data
13. **Frontend** (jeśli monorepo) — `node_modules/`, `.next/`
14. **Project-specific** — foldery runtime, workspace, external deps

### Universal Starter Template

Minimalny .gitignore dla **każdego** nowego projektu Python + uv:

```gitignore
# ── Python Runtime ─────────────────────────────────────────────────────────────

__pycache__/
*.py[codz]
*$py.class
*.so
*.pyo
*.pyd


# ── Build & Distribution ──────────────────────────────────────────────────────

build/
dist/
*.egg-info/
*.egg


# ── Virtual Environments ──────────────────────────────────────────────────────

.venv/
# NOTE: .python-version and uv.lock SHOULD be committed


# ── Testing & Coverage ────────────────────────────────────────────────────────

.pytest_cache/
.hypothesis/
.coverage
.coverage.*
htmlcov/
coverage.xml


# ── Tool Caches ───────────────────────────────────────────────────────────────

.mypy_cache/
.dmypy.json
dmypy.json
.ruff_cache/


# ── IDE & Editor ──────────────────────────────────────────────────────────────

.vscode/
.idea/
*.swp
*.swo
*~


# ── Jupyter ───────────────────────────────────────────────────────────────────

.ipynb_checkpoints/


# ── OS Generated ──────────────────────────────────────────────────────────────

.DS_Store
Thumbs.db
desktop.ini


# ── Secrets ───────────────────────────────────────────────────────────────────

.env
.env.local
.env.*.local
!.env.example
.pypirc


# ── Logs ──────────────────────────────────────────────────────────────────────

logs/
*.log


# ── Temporary Files ───────────────────────────────────────────────────────────

*.tmp
*.temp
*.cache
```

### ML / AI Project Extras

Dodaj do starter template jeśli projekt pracuje z modelami ML:

```gitignore
# ── Images ────────────────────────────────────────────────────────────────────

*.jpg
*.jpeg
*.png
*.gif
*.bmp
*.tiff
*.tif
*.webp
*.ico
*.heic
*.heif
# NOTE: SVG tracked (text-based, useful in docs/frontend)


# ── Video ─────────────────────────────────────────────────────────────────────

*.mp4
*.avi
*.mov
*.mkv
*.webm


# ── Audio ─────────────────────────────────────────────────────────────────────

*.mp3
*.wav
*.flac
*.aac
*.ogg


# ── AI/ML Model Weights ──────────────────────────────────────────────────────

*.safetensors
*.pt
*.pth
*.onnx
*.ckpt
*.bin
*.h5
*.hdf5
*.pkl
*.pickle
*.pb
*.tflite
*.weights
*.msgpack


# ── Data Files ────────────────────────────────────────────────────────────────

*.csv
*.tsv
*.dat
*.npy
*.npz
*.parquet
*.feather
*.arrow


# ── Archives ──────────────────────────────────────────────────────────────────

*.zip
*.tar
*.tar.gz
*.tar.bz2
*.tar.xz
*.rar
*.7z
*.gz
*.bz2


# ── Database ──────────────────────────────────────────────────────────────────

*.db
*.sqlite
*.sqlite3
```

### Frontend Monorepo Extras

Dodaj jeśli frontend żyje w tym samym repo:

```gitignore
# ── Node.js / Frontend ───────────────────────────────────────────────────────

node_modules/
.next/
out/
.turbo/
.vercel/
*.tsbuildinfo
next-env.d.ts
```

---

## Źródła

- [uv CLI Reference](https://docs.astral.sh/uv/reference/cli/)
- [uv Concepts: Dependencies](https://docs.astral.sh/uv/concepts/projects/dependencies/)
- [Ruff Rules — pełna lista](https://docs.astral.sh/ruff/rules/)
- [Ruff Configuration](https://docs.astral.sh/ruff/configuration/)
- [mypy Configuration](https://mypy.readthedocs.io/en/stable/config_file.html)
- [pre-commit](https://pre-commit.com/)

---
