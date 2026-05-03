# 12 — Testing

> **Cel:** pytest conventions, fixtures, parametrize, mocking via Protocols, markers, coverage.
> **Scope:** Uniwersalny — Python ≥3.10, pytest ≥8.0, pytest-asyncio, pytest-cov.
> **NIE duplikuje:** error handling (→08), design patterns (→09), async patterns (→przyszła sekcja).

---

## Spis treści

1. [pytest — setup & conventions](#1-pytest--setup--conventions)
2. [Test naming & structure](#2-test-naming--structure)
3. [Fixtures](#3-fixtures)
4. [Parametrize](#4-parametrize)
5. [Markers — organizacja testów](#5-markers--organizacja-testów)
6. [Mocking — Protocols & Fakes](#6-mocking--protocols--fakes)
7. [Async testing](#7-async-testing)
8. [Coverage](#8-coverage)
9. [Antypatterny](#9-antypatterny)
10. [Pylance & IDE type-checking w testach](#10-pylance--ide-type-checking-w-testach)
11. [Egzekucja ruff](#11-egzekucja-ruff)


## 📋 Quick Reference (ściąga)

| # | Reguła |
|---|--------|
| 1 | **AAA pattern:** Arrange → Act → Assert w każdym teście |
| 2 | **Fixtures** w `conftest.py` — dependency injection, nie setup/teardown |
| 3 | **`@parametrize`** zamiast duplikowania testów |
| 4 | **`--strict-markers`** — wyłap literówki w marker names |
| 5 | **Protocol + Fake** > `unittest.mock.patch` |
| 6 | **`monkeypatch`** do env vars i atrybutów |
| 7 | **`tmp_path`** do operacji na plikach |
| 8 | **`asyncio_mode = "auto"`** — automatyczne async test detection |
| 9 | **Coverage ≥30%** — enforce z `--cov-fail-under` |
| 10 | **`pytest.param(..., id="name")`** — czytelne nazwy w output |
| 11 | **`S101` w per-file-ignores** — assert OK w testach, NIE w prod |

---

## 1. pytest — setup & conventions

### 1.1 Konfiguracja w `pyproject.toml`

```toml
[tool.pytest.ini_options]
minversion = "8.0"
testpaths = ["tests"]
asyncio_mode = "auto"
addopts = [
    "-ra",                    # Show summary of all non-passing tests
    "--strict-markers",       # Fail on unknown markers
    "--strict-config",        # Fail on config errors
    "-x",                     # Stop on first failure (dev)
]
markers = [
    "slow: marks tests as slow (deselect with '-m \"not slow\"')",
    "integration: marks integration tests requiring external services",
    "gpu: marks tests requiring GPU",
]
```

### 1.2 Uruchomienie

```bash
# Podstawowe
uv run pytest

# Z coverage
uv run pytest --cov=myapp --cov-report=term-missing

# Tylko szybkie testy
uv run pytest -m "not slow and not integration"

# Konkretny plik/test
uv run pytest tests/test_users.py::TestUserService::test_create
```

### 1.3 Struktura katalogów

```
tests/
├── conftest.py              # Globalne fixtures
├── fakes.py                 # Fake implementations (protocols)
├── test_users/
│   ├── conftest.py          # Fixtures specyficzne dla modułu
│   ├── test_create.py
│   └── test_delete.py
├── test_payments/
│   ├── conftest.py
│   └── test_charge.py
└── test_integration/
    └── test_api.py
```

---

## 2. Test naming & structure

### 2.1 Konwencje nazewnictwa

| Element | Konwencja | Przykład |
|---------|-----------|---------|
| Plik testowy | `test_*.py` | `test_users.py` |
| Klasa testowa | `Test*` (bez `__init__`!) | `TestUserService` |
| Metoda/funkcja | `test_*` | `test_create_valid_user` |
| Fixture | noun (bez `test_` prefix) | `user_repo`, `sample_data` |

### 2.2 Wzorzec: Arrange-Act-Assert (AAA)

```python
def test_create_user_with_valid_data(user_repo: UserRepository) -> None:
    # Arrange
    data = CreateUserRequest(name="Alice", email="alice@example.com")

    # Act
    user = user_repo.create(data)

    # Assert
    assert user.id is not None
    assert user.name == "Alice"
    assert user.email == "alice@example.com"
```

### 2.3 Kiedy klasa vs standalone function

| Użyj | Kiedy |
|------|-------|
| Standalone `test_*()` | Proste testy bez shared setup |
| `class Test*` | Grupowanie testów per feature + wspólne fixtures |

```python
# ✅ Klasa — shared fixture via method
class TestPaymentService:
    @pytest.fixture
    def service(self) -> PaymentService:
        return PaymentService(gateway=FakeGateway())

    def test_charge_success(self, service: PaymentService) -> None:
        result = service.charge(amount=100)
        assert result.status == "paid"

    def test_charge_insufficient_funds(self, service: PaymentService) -> None:
        with pytest.raises(InsufficientFundsError):
            service.charge(amount=999_999)
```

---

## 3. Fixtures

### 3.1 Tabela scope

| Scope | Lifetime | Użyj gdy |
|-------|----------|----------|
| `"function"` (default) | Per test | Fresh state per test |
| `"class"` | Per test class | Shared within class |
| `"module"` | Per test file | Expensive setup per file |
| `"session"` | Cała sesja pytest | DB connection, server start |

### 3.2 Snippety

```python
import pytest
from collections.abc import Iterator


# ✅ Prosta fixture — factory
@pytest.fixture
def sample_user() -> User:
    return User(id=1, name="Alice", email="alice@example.com")


# ✅ Fixture z cleanup (yield)
@pytest.fixture
def temp_dir(tmp_path: Path) -> Iterator[Path]:
    work_dir = tmp_path / "work"
    work_dir.mkdir()
    yield work_dir
    # Cleanup po teście (opcjonalnie — tmp_path auto-cleanup)


# ✅ Fixture z parametryzacją
@pytest.fixture(params=["sqlite", "postgres"])
def db_backend(request: pytest.FixtureRequest) -> str:
    return request.param


# ✅ Session-scoped — expensive setup
@pytest.fixture(scope="session")
def database_engine() -> Iterator[Engine]:
    engine = create_engine("sqlite:///test.db")
    yield engine
    engine.dispose()
```

### 3.3 `conftest.py` — kiedy co

| Lokalizacja | Fixtures |
|-------------|---------|
| `tests/conftest.py` | Globalne: fake services, sample data, database |
| `tests/test_module/conftest.py` | Per-moduł: specyficzne fixtures |
| Test file / class | Per-test: ultra-specyficzne setup |

### 3.4 Data fixtures — fabryki testowych danych

```python
import numpy as np
import pytest


@pytest.fixture
def small_image() -> np.ndarray:
    """100x80 RGB image for testing."""
    return np.random.randint(0, 255, (100, 80, 3), dtype=np.uint8)


@pytest.fixture
def binary_mask() -> np.ndarray:
    """100x80 binary mask (0 or 255)."""
    mask = np.zeros((100, 80), dtype=np.uint8)
    mask[20:40, 30:60] = 255
    return mask
```

---

## 4. Parametrize

### 4.1 Podstawy

```python
import pytest


# ✅ Parametrize — zamiast duplikowania testów
@pytest.mark.parametrize(
    ("input_val", "expected"),
    [
        ("hello", "HELLO"),
        ("World", "WORLD"),
        ("", ""),
        ("123abc", "123ABC"),
    ],
)
def test_uppercase(input_val: str, expected: str) -> None:
    assert input_val.upper() == expected


# ✅ Parametrize z IDs — czytelne nazwy w output
@pytest.mark.parametrize(
    ("status_code", "should_retry"),
    [
        pytest.param(200, False, id="success"),
        pytest.param(429, True, id="rate-limited"),
        pytest.param(500, True, id="server-error"),
        pytest.param(404, False, id="not-found"),
    ],
)
def test_retry_decision(status_code: int, should_retry: bool) -> None:
    assert should_retry_request(status_code) == should_retry
```

### 4.2 Multi-parametrize — cartesian product

```python
# ✅ Dwa @parametrize = cartesian product (2 × 3 = 6 testów)
@pytest.mark.parametrize("format_type", ["json", "csv"])
@pytest.mark.parametrize("compression", ["none", "gzip", "zstd"])
def test_export(format_type: str, compression: str) -> None:
    result = export_data(format_type=format_type, compression=compression)
    assert result.is_valid()
```

### 4.3 Kiedy parametrize vs osobne testy

| Sytuacja | Użyj |
|----------|------|
| Ta sama logika, różne dane | `@parametrize` |
| Różna logika per case | Osobne `test_*` functions |
| >10 przypadków | `@parametrize` z external list |
| Error cases | Osobne testy (czytelniejsze asserty) |

### 4.4 fixture `params=` vs `@parametrize`

| Sytuacja | fixture `params=` | `@parametrize` |
|----------|------|-------|
| Kilka wariantów folderu/danych | ✅ Fixture z `params` | Możliwe, ale overkill |
| Kilka wariantów inputu do testu | ❌ Mniej użyteczne | ✅ Naturalnie |
| Jeden setup na wiele testów | ✅ TAK — fixture scope | ❌ Powtarza setup per test |
| Czytelność output | ⚠️ Generic `param0` | ✅ Z `pytest.param(..., id="name")` |

**TL;DR:** `fixture params` = ta SAMA fixture ma wiele wersji; `@parametrize` = różne inputy do testu.

---

## 5. Markers — organizacja testów

### 5.1 Wbudowane markery

| Marker | Działanie |
|--------|----------|
| `@pytest.mark.skip(reason="...")` | Pomija test |
| `@pytest.mark.skipif(cond, reason="...")` | Pomija warunkowo |
| `@pytest.mark.xfail(reason="...")` | Oczekiwany fail |
| `@pytest.mark.parametrize(...)` | Parametryzacja |

### 5.2 Custom markery

```python
# ✅ Definicja w pyproject.toml (patrz §1.1)
# Użycie:
@pytest.mark.slow
def test_heavy_computation() -> None:
    result = process_large_dataset(data)
    assert result.valid

@pytest.mark.integration
def test_api_endpoint(live_server: str) -> None:
    response = httpx.get(f"{live_server}/health")
    assert response.status_code == 200

@pytest.mark.gpu
def test_model_inference() -> None:
    output = model.predict(sample_input)
    assert output.shape == (1, 10)
```

```bash
# Uruchomienie z markerami
uv run pytest -m "not slow"                    # Pomiń wolne
uv run pytest -m "integration"                 # Tylko integracyjne
uv run pytest -m "not gpu and not integration"  # Szybkie unit
```

---

## 6. Mocking — Protocols & Fakes

### 6.1 Reguła

> 🔒 **HARD RULE:** Preferuj Protocols + Fakes nad `unittest.mock.patch`. Fakes to prawdziwe implementacje, nie magiczne mocki.

### 6.2 Tabela decyzyjna

| Sytuacja | Użyj | Dlaczego |
|----------|------|----------|
| External service (API, DB) | Fake (Protocol impl) | Type-safe, IDE support, testowalne |
| Environment variable | `monkeypatch.setenv()` | pytest built-in, clean |
| File system | `tmp_path` fixture | pytest built-in, auto-cleanup |
| Time/datetime | Fake clock lub `freezegun` | Deterministyczne |
| `unittest.mock.patch` | Ostateczność | Gdy refactor jest za drogi |

### 6.3 Snippety — Protocol + Fake

```python
from __future__ import annotations

from typing import Protocol


# ✅ Protocol — kontrakt
class PaymentGateway(Protocol):
    def charge(self, amount: int, currency: str) -> PaymentResult: ...
    def refund(self, transaction_id: str) -> RefundResult: ...


# ✅ Fake — test implementation
class FakePaymentGateway:
    """Fake gateway for testing — tracks calls, configurable responses."""

    def __init__(self) -> None:
        self.charges: list[tuple[int, str]] = []
        self.should_fail: bool = False

    def charge(self, amount: int, currency: str) -> PaymentResult:
        self.charges.append((amount, currency))
        if self.should_fail:
            msg = "Simulated payment failure"
            raise PaymentError(msg)
        return PaymentResult(status="paid", transaction_id="fake-txn-001")

    def refund(self, transaction_id: str) -> RefundResult:
        return RefundResult(status="refunded")


# ✅ Test z fake
class TestPaymentService:
    @pytest.fixture
    def gateway(self) -> FakePaymentGateway:
        return FakePaymentGateway()

    @pytest.fixture
    def service(self, gateway: FakePaymentGateway) -> PaymentService:
        return PaymentService(gateway=gateway)

    def test_charge_records_transaction(
        self, service: PaymentService, gateway: FakePaymentGateway
    ) -> None:
        service.process_order(amount=500, currency="PLN")
        assert len(gateway.charges) == 1
        assert gateway.charges[0] == (500, "PLN")

    def test_charge_failure_raises(
        self, service: PaymentService, gateway: FakePaymentGateway
    ) -> None:
        gateway.should_fail = True
        with pytest.raises(PaymentError):
            service.process_order(amount=500, currency="PLN")
```

### 6.4 `monkeypatch` — env vars & attributes

```python
def test_debug_mode(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("DEBUG", "true")
    settings = AppSettings()
    assert settings.debug is True


def test_override_attribute(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setattr("myapp.config.MAX_RETRIES", 0)
    assert get_max_retries() == 0
```

---

## 7. Async testing

### 7.1 Setup

```toml
# pyproject.toml
[tool.pytest.ini_options]
asyncio_mode = "auto"  # Automatycznie wykrywa async testy
```

### 7.2 Snippety

```python
import pytest


# ✅ Async test — automatycznie wykryty (asyncio_mode="auto")
async def test_fetch_user(client: AsyncClient) -> None:
    response = await client.get("/users/1")
    assert response.status_code == 200


# ✅ Async fixture
@pytest.fixture
async def async_client() -> AsyncIterator[AsyncClient]:
    async with AsyncClient(base_url="http://test") as client:
        yield client


# ✅ Async test z fake
async def test_process_async(fake_service: FakeService) -> None:
    result = await fake_service.process(data)
    assert result.status == "ok"
```

---

## 8. Coverage

### 8.1 Konfiguracja

```toml
# pyproject.toml
[tool.coverage.run]
source = ["myapp"]
omit = ["*/tests/*", "*/migrations/*"]

[tool.coverage.report]
fail_under = 30          # Minimalne pokrycie (%)
show_missing = true
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "if __name__ == .__main__.",
    "@overload",
]
```

### 8.2 Uruchomienie

```bash
# Coverage report
uv run pytest --cov=myapp --cov-report=term-missing

# HTML report
uv run pytest --cov=myapp --cov-report=html
# → open htmlcov/index.html

# Enforce minimum
uv run pytest --cov=myapp --cov-fail-under=30
```

### 8.3 Co pokrywać, co pomijać

| Pokrywaj ✅ | Pomijaj ❌ |
|------------|----------|
| Business logic | `TYPE_CHECKING` blocks |
| Error paths | `__main__` guards |
| Edge cases | Overloads |
| Public API | Auto-generated code |

---

## 9. Antypatterny

| # | Antypattern ❌ | Fix ✅ |
|---|---------------|-------|
| 1 | `unittest.TestCase` | pytest classes + fixtures |
| 2 | `mock.patch` na wszystko | Protocol + Fake |
| 3 | Brak `--strict-markers` | Dodaj do `addopts` |
| 4 | Test bez assert | Każdy test = ≥1 assert |
| 5 | Magiczne stringi/liczby | `pytest.param(..., id="name")` |
| 6 | Duplikacja setup | Fixtures w `conftest.py` |
| 7 | Duplikacja testów (różne dane) | `@pytest.mark.parametrize` |
| 8 | `assert x == True` | `assert x is True` lub `assert x` |
| 9 | Test zależy od kolejności | Każdy test izolowany |
| 10 | Brak coverage tracking | `--cov` w CI |

---

## 10. Pylance & IDE type-checking w testach

> 🔒 **HARD RULE:** Po napisaniu/edycji testów ZAWSZE sprawdź Pylance errors (`get_errors`) i napraw ZANIM uznasz task za skończony.

### 10.1 Typowe pułapki

| Problem | Przykład | Fix |
|---------|----------|-----|
| `str` vs `Literal` w `@parametrize` | `mode: str` gdy API oczekuje `DisplayMode` | Zaimportuj alias Literal i użyj go w sygnaturze |
| `reportPossiblyUnbound` | Zmienna bindowana w `with` wewnątrz `pytest.raises` | Zadeklaruj zmienną PRZED blokiem `with pytest.raises` |
| Brak importu typu | `Literal`, `DisplayMode`, `TypeAlias` — nie zaimportowane | Dodaj do importu z modułu źródłowego |

### 10.2 Przykład: `reportPossiblyUnbound`

```python
# ❌ BŁĄD — Pylance: reportPossiblyUnbound
with pytest.raises(ValueError) as exc_info:
    UserModel(name="")  # ValueError
assert "name" in str(exc_info.value)  # exc_info może być unbound!

# ✅ FIX — zadeklaruj przed pytest.raises
exc_info: pytest.ExceptionInfo[ValueError]
with pytest.raises(ValueError) as exc_info:
    UserModel(name="")
assert "name" in str(exc_info.value)  # Pylance OK
```

### 10.3 Workflow

1. Napisz / edytuj test
2. `get_errors` na pliku → napraw WSZYSTKO
3. `uv run ruff check` + `uv run ruff format`
4. `uv run pytest` → dopiero wtedy commituj

---

## 11. Egzekucja ruff

### 11.1 Reguły

| Ruff | Nazwa | Co łapie |
|------|-------|----------|
| `PT001` | pytest-fixture-incorrect-parentheses | `@pytest.fixture()` vs `@pytest.fixture` |
| `PT006` | pytest-parametrize-names-wrong-type | Nazwy parametrów jako string vs tuple |
| `PT007` | pytest-parametrize-values-wrong-type | Values format (list vs tuple) |
| `PT011` | pytest-raises-too-broad | `pytest.raises(Exception)` → specyficzny typ |
| `PT012` | pytest-raises-with-multiple-statements | Zbyt wiele w `with pytest.raises` |
| `PT018` | pytest-composite-assertion | Composite assert → rozbij na osobne |
| `PT023` | pytest-incorrect-mark-parentheses | `@pytest.mark.foo()` vs `@pytest.mark.foo` |
| `S101` | assert-used | `assert` poza testami (w prod code!) |

### 11.2 per-file-ignores

```toml
[tool.ruff.lint.per-file-ignores]
"tests/**" = [
    "S101",    # assert OK w testach
    "PLR2004", # Magic values OK w testach
    "ARG",     # Unused fixtures OK (auto-injected)
]
```

---
## Źródła

> - [pytest docs](https://docs.pytest.org/) — fixtures, markers, parametrize
> - [pytest-asyncio](https://pytest-asyncio.readthedocs.io/) — async test support
> - [pytest-cov](https://pytest-cov.readthedocs.io/) — coverage integration
> - [Ruff PT rules](https://docs.astral.sh/ruff/rules/#flake8-pytest-style-pt) — pytest style enforcement
> - [Real Python — pytest](https://realpython.com/pytest-python-testing/) — tutorial
> - `07-class-protocol-design.md` — Protocol definitions
> - `09-design-patterns.md` — Strategy pattern (Fakes)
