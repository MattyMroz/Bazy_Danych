---
description: "Kickoff implementacji W0 — merge git, inject configs, baseline snapshot. Wklej w nową sesję."
---

# 🚀 MangaShift — W0 Implementation Kickoff

## KONTEKST

Projekt MangaShift (Python manga translation pipeline) przeszedł 13 rund planowania ("kuźni").
Plan jest gotowy (8/10), czas na implementację.

### Pliki do przeczytania ZANIM zaczniesz:

**OBOWIĄZKOWE — przeczytaj W CAŁOŚCI przed jakąkolwiek akcją:**

1. `temp/brain_storm/re/MASTER_SUMMARY.md` — **TWOJA MAPA.** Synteza 13 kuźni, 81 tasków, 55 decyzji, ~120 reguł.

**13 kuźni brainstormowych — przeczytaj WSZYSTKIE SUMMARY (minimum) + pełne BRAINSTORM gdy pracujesz nad danym obszarem:**

| # | Folder | SUMMARY | BRAINSTORM | Temat |
|---|--------|---------|------------|-------|
| 01 | `temp/brain_storm/re/01_project_structure/` | `BRAINSTORM_SUMMARY.md` | `BRAINSTORM.md` | Struktura projektu, __all__, nesting |
| 02 | `temp/brain_storm/re/02_service_architecture/` | `BRAINSTORM_SUMMARY.md` | `BRAINSTORM.md` | Protocol pattern, blueprint, portability, ZEI |
| 03 | `temp/brain_storm/re/03_error_handling/` | `BRAINSTORM_SUMMARY.md` | `BRAINSTORM.md` | 3-level hierarchy, tenacity, ErrorCode |
| 04 | `temp/brain_storm/re/04_logging/` | `BRAINSTORM_SUMMARY.md` | `BRAINSTORM.md` | loguru, InterceptHandler, structured logging |
| 05 | `temp/brain_storm/re/05_type_system_linting/` | `BRAINSTORM_SUMMARY.md` | `BRAINSTORM.md` | mypy strict, ruff ~30 categories, Protocol |
| 06 | `temp/brain_storm/re/06_testing/` | `BRAINSTORM_SUMMARY.md` | `BRAINSTORM.md` | FakeEngine, coverage ratchet, pytest markers |
| 07 | `temp/brain_storm/re/07_code_style_docs/` | `BRAINSTORM_SUMMARY.md` | `BRAINSTORM.md` | Google docstrings, magic numbers, DRY |
| 08 | `temp/brain_storm/re/08_model_management/` | `BRAINSTORM_SUMMARY.md` | `BRAINSTORM.md` | ModelSpec, ensure_model(), VRAM, registry |
| 09 | `temp/brain_storm/re/09_project_management/` | `BRAINSTORM_SUMMARY.md` | `BRAINSTORM.md` | MoSCoW, hybrid branching, Walking Skeleton |
| 10 | `temp/brain_storm/re/10_refactoring_plan/` | `BRAINSTORM_SUMMARY.md` | `BRAINSTORM.md` | Service playbook, replication order, interleaved |
| 11 | `temp/brain_storm/re/11_milestone_2_report/` | — | `RAPORT_TECHNICZNY_KM2.md` | Raport kamienia milowego 2 |
| 12 | `temp/brain_storm/re/12_koharu_analysis/` | `BRAINSTORM_KOHARU_IDEAS_SUMMARY.md` | `BRAINSTORM_KOHARU_IDEAS.md` + `KOHARU_DEEP_ANALYSIS.md` | Competitive analysis Koharu, K1-K8 patterns |
| 13 | `temp/brain_storm/re/13_meta_audit/` | `BRAINSTORM_META_AUDIT_SUMMARY.md` | `BRAINSTORM_META_AUDIT.md` | Meta-audyt: 16 luk, 12 poprawek, async doctrine |

> ⚠️ **NIE IGNORUJ brainstormów.** Te 35 plików to setki godzin analizy. Gdy pracujesz nad np. error handling → przeczytaj PEŁNY `03_error_handling/BRAINSTORM.md`, nie tylko summary. Summary to skrót, BRAINSTORM to pełna analiza z uzasadnieniami, alternatywami i trade-offami.

### Stan repo (2026-03-31):

- **Git:** branch `detection` ma 148 commits ahead of `main`. MUSI być zmergowany JAKO PIERWSZY krok.
- **Kod:** 271 .py files, 53 ML models (~23 GB), brak unified architecture.
- **Problemy:** 14 hardcoded model paths, 38 broad `except Exception:`, 0% meaningful test coverage, brak CI.
- **Tooling:** `uv` do package management. NIGDY nie edytuj ręcznie pyproject.toml deps — ZAWSZE `uv add <pkg>`.

---

## CEL SESJI

Zaimplementuj **WARSTWĘ 0: Config & Tooling + Git** z MASTER_SUMMARY.

### Taski W0 (w kolejności):

| # | Task | Effort | Opis |
|---|------|--------|------|
| 0.1 | **Merge `detection` → `main`** | 10 min | Regular merge (NIE squash — 148 commits to historia). `git checkout main; git merge detection` |
| 0.2 | **Tag `v0.3.0`** | 5 min | `git tag -a v0.3.0 -m "Pre-refactor baseline"` + delete old detection branch |
| 0.3 | **Commit convention** | 15 min | `feat/fix/refactor/docs/chore` prefixes od teraz |
| 0.4 | **Inject ruff config** | 30 min | Skopiuj gotowy config z MASTER_SUMMARY → `pyproject.toml` (~30 kategorii) |
| 0.5 | **Inject mypy config** | 30 min | Skopiuj z MASTER_SUMMARY → `pyproject.toml` (strict + plugins + overrides) |
| 0.6 | **Inject pytest config** | 20 min | Skopiuj z MASTER_SUMMARY → `pyproject.toml` (markers + coverage + asyncio_mode) |
| 0.7 | **Baseline snapshot** | 15 min | `uv run ruff check --statistics` + `uv run mypy mangashift/ \| wc` → zapisz output |
| 0.8 | **ruff --fix** | 1h | `uv run ruff check --fix` → auto-fix ~250-350 issues |
| 0.9 | **ruff FA --fix** | 15 min | `uv run ruff check --select FA --fix` → `__future__ import annotations` everywhere |
| 0.10 | **ruff UP --fix** | 15 min | `uv run ruff check --select UP --fix` → modern syntax (X\|None, list[], etc.) |
| 0.11 | **uv add tenacity** | 5 min | `uv add tenacity` |
| 0.12 | **loguru setup** | 2h | `setup_mode()` + `InterceptHandler` centralization |
| 0.13 | **CI setup** | 30 min | `.github/workflows/ci.yml` — ruff + mypy + pytest |
| 0.14 | **MoSCoW labeling** | 30 min | GitHub labels + priorytetyzacja 50 tasków |
| 0.15 | **Calendar alarm** | 1 min | "Pt 16:30 — weekly planning" |

**Łączny estimated effort:** ~7h optimistic, ~10h realistic.

---

## CONSTRAINTS

### Architektura (z 13 kuźni):
- **Protocol > ABC** (PEP 544) — nigdy abstract class
- **Async/Sync Doctrine:** Engine=sync (`__enter__`/`__exit__`), Service=async wrapper (`asyncio.to_thread()`), API=async native
- **Config Architecture:** `AppConfig` = JEDYNY `BaseSettings` (env prefix `MANGASHIFT_`), per-service config = `BaseModel`
- **Error Architecture:** `mangashift/errors.py` (NIE `_base_errors.py`), `ErrorCode(StrEnum)` + `ErrorContext`
- **Model Management:** `mangashift/models/registry.py` z `MODEL_REGISTRY` + `ModelSpec(frozen dataclass)` + `ensure_model()` atomic

### Coding standards:
- Type hints everywhere, DRY, SOLID, no magic numbers
- Python: PEP 8, ruff, mypy strict, Google-style docstrings
- `uv` do WSZYSTKIEGO (`uv add`, `uv run`, `uv sync`)
- `from __future__ import annotations` w KAŻDYM pliku

### Testing:
- FakeEngine per service (Protocol-compliant test double)
- Coverage ratchet: 50→60→70
- Targets: 100 unit + 8 integration + 5 smoke
- pytest markers: `gpu`, `model`, `slow`, `integration`, `smoke`

---

## WORKFLOW

1. **Przeczytaj MASTER_SUMMARY.md w całości** — to twoje source of truth
2. **Załaduj todo list** — `manage_todo_list` z taskami W0 (0.1-0.15)
3. **Implementuj task po tasku** — mark in-progress → execute → mark completed
4. **Po każdym ważnym kroku:** HITL ankieta (`vscode_askQuestions`)
5. **Po W0:** podsumowanie + snapshot + HITL: co dalej?

---

## UWAGI

- User: Mateusz Mróz, komunikacja po polsku z angielskimi terminami tech
- Ma dysleksję — literówki ignoruj, liczy się intencja
- Jest bezpośredni — nie owijaj w bawełnę, PO PROSTU RÓB
- HITL ankiety na końcu złożonych kroków — ZAWSZE `vscode_askQuestions`, NIGDY markdownowe listy
- Agent NIE kończy sesji sam — tylko user wybiera "kończymy"

---

## GOTOWY? Zacznij od: `git status` + przeczytaj MASTER_SUMMARY.md → załaduj todo → GO.
