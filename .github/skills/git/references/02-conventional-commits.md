# 02 — Conventional Commits

> **Cel:** Konwencja formatowania commit messages wg Conventional Commits 1.0.0.
> **Scope:** Przenośny — standard niezależny od języka i projektu. Dovetails z SemVer.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [Format](#1-format)
3. [Types](#2-types)
4. [Scope](#3-scope)
5. [Body i Footer](#4-body-i-footer)
6. [Breaking Changes](#5-breaking-changes)
7. [Dobre vs złe commity](#6-dobre-vs-złe-commity)
8. [Atomic Commits](#7-atomic-commits)
9. [Tooling](#8-tooling)

> **SemVer + tagi** → patrz `05-versioning-releases.md`
> **Commit-msg hooks** → patrz `06-git-hooks.md`

---

## 📋 Quick Reference

**Format:**
```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

**Types cheatsheet:**

| Type | Kiedy | SemVer bump |
|------|-------|-------------|
| `feat` | Nowa feature | MINOR |
| `fix` | Bug fix | PATCH |
| `docs` | Dokumentacja | — |
| `refactor` | Restructure (no functional change) | — |
| `perf` | Performance | PATCH |
| `test` | Testy | — |
| `chore` | Deps, build, tooling | — |
| `ci` | CI/CD pipeline | — |
| `style` | Format (whitespace, semicolons) | — |
| `build` | Build system, external deps | — |
| `revert` | Revert commita | Zależy |

**Breaking change:** Dodaj `!` po type/scope LUB `BREAKING CHANGE:` w footer.

---

## 1. Format

### Struktura commit message

```
<type>[scope][!]: <description>
                                    ← pusta linia
[body]
                                    ← pusta linia
[footer(s)]
```

### Reguły

| Reguła | Poziom | Szczegóły |
|--------|--------|-----------|
| Type jest obowiązkowy | 🔴 MUST | `feat:`, `fix:`, `docs:` itd. |
| Scope jest opcjonalny | 🟢 NICE | `feat(auth):`, `fix(db):` |
| `!` przed `:` = breaking change | 🟡 SHOULD | `feat(api)!:` |
| Description po `:` + spacja | 🔴 MUST | `feat: add login` (nie `feat:add login`) |
| Description lowercase | 🟡 SHOULD | `feat: add login` (nie `feat: Add Login`) |
| Description bez kropki na końcu | 🟡 SHOULD | `feat: add login` (nie `feat: add login.`) |
| Description max 72 znaki | 🟡 SHOULD | Krótko i konkretnie |
| Description w trybie rozkazującym | 🟡 SHOULD | `add`, `fix`, `remove` (nie `added`, `fixes`) |
| Body oddzielony pustą linią | 🔴 MUST | Jeśli jest body |
| Footer oddzielony pustą linią | 🔴 MUST | Jeśli jest footer |

---

## 2. Types

### Obowiązkowe (spec)

| Type | Opis | SemVer | Przykład |
|------|------|--------|---------|
| `feat` | Nowa feature dla użytkownika | MINOR | `feat: add dark mode toggle` |
| `fix` | Bug fix | PATCH | `fix: resolve null pointer on empty input` |

### Rozszerzone (Angular convention)

| Type | Opis | Przykład |
|------|------|---------|
| `docs` | Dokumentacja (README, docstrings) | `docs: update API reference` |
| `refactor` | Restructure kodu (bez zmiany zachowania) | `refactor: extract validation logic` |
| `perf` | Performance improvement | `perf: optimize database query with index` |
| `test` | Dodanie/poprawa testów | `test: add unit tests for auth middleware` |
| `chore` | Maintenance (deps, config) | `chore: upgrade numpy to 2.1.0` |
| `ci` | CI/CD pipeline changes | `ci: add Python 3.12 to test matrix` |
| `style` | Formatowanie (whitespace, semicolons) | `style: fix trailing whitespace` |
| `build` | Build system, external deps | `build: switch from setuptools to hatch` |
| `revert` | Revert wcześniejszego commita | `revert: remove broken migration` |

### Tabela decyzyjna: jaki type?

| Zmieniłem... | Type |
|-------------|------|
| Dodałem nową funkcję widoczną dla usera | `feat` |
| Naprawiłem buga | `fix` |
| Zmieniłem strukturę kodu bez zmiany zachowania | `refactor` |
| Poprawiłem performance | `perf` |
| Dodałem/poprawiłem testy | `test` |
| Zaktualizowałem dependency | `chore` |
| Zmiana dotyczy tylko CI/CD | `ci` |
| Zmiana dotyczy build systemu | `build` |
| Zmiana dotyczy tylko dokumentacji | `docs` |
| Zmiana dotyczy tylko formatowania | `style` |
| Cofam wcześniejszy commit | `revert` |

---

## 3. Scope

### Czym jest scope?

Opcjonalny kontekst zmian — moduł, komponent lub obszar kodu.

```bash
# Z scope
feat(auth): add two-factor authentication
fix(api): handle timeout on large payloads
docs(readme): add installation instructions
chore(deps): upgrade pydantic to v2

# Bez scope (mniejsze projekty, oczywisty kontekst)
feat: add dark mode
fix: resolve crash on startup
```

### Konwencje scope

| Scope | Zakres | Przykład |
|-------|--------|---------|
| `auth` | Autentykacja/autoryzacja | `feat(auth): add OAuth provider` |
| `api` | API endpoints | `fix(api): correct status code for 404` |
| `ui` | Frontend / UI | `feat(ui): add loading skeleton` |
| `db` | Baza danych / ORM | `perf(db): add index on user_email` |
| `config` | Konfiguracja | `chore(config): add production settings` |
| `deps` | Dependencies | `chore(deps): upgrade FastAPI` |
| `ci` | CI/CD | `ci(github): add caching step` |

### ⛔ HARD RULES scope

- 🔴 **Scope musi istnieć w projekcie** — nie wymyślaj scope'ów dla jednego commita.
- 🟡 **Konsystentny** — `auth` zawsze, nie raz `auth` raz `authentication`.
- 🟡 **Max 1 słowo** — `api`, nie `api-endpoints`.

---

## 4. Body i Footer

### Body

Opcjonalny. Wyjaśnia **dlaczego**, nie **co** (co widać w kodzie).

```
fix(auth): resolve race condition in token refresh

The previous implementation allowed multiple concurrent refresh
requests which could result in token invalidation. Added a mutex
lock to serialize refresh operations.
```

### Footer

Opcjonalny. Służy do:

| Footer | Cel | Przykład |
|--------|-----|---------|
| `BREAKING CHANGE:` | Breaking change description | `BREAKING CHANGE: remove legacy auth endpoint` |
| `Closes #N` | Zamknięcie issue | `Closes #42` |
| `Refs: #N` | Referencja (bez zamykania) | `Refs: #42, #43` |
| `Reviewed-by:` | Reviewer | `Reviewed-by: Alice` |
| `Co-authored-by:` | Współautor | `Co-authored-by: Bob <bob@example.com>` |

### Pełny przykład

```
feat(api): add user preference endpoints

Implement CRUD endpoints for user preferences:
- GET /api/preferences
- PUT /api/preferences
- DELETE /api/preferences/:key

Preferences are stored in Redis with 24h TTL for performance.
Validated with Pydantic models.

Closes #42
Refs: #38
Reviewed-by: Alice
```

---

## 5. Breaking Changes

### Jak oznaczyć?

**Sposób 1:** `!` po type/scope (krótki)
```
feat(api)!: change response format to JSON:API

BREAKING CHANGE: All API responses now follow JSON:API spec.
Clients must update their parsers.
```

**Sposób 2:** Footer `BREAKING CHANGE:` (szczegółowy)
```
refactor(auth): migrate from sessions to JWT

BREAKING CHANGE: Session-based authentication has been removed.
All clients must use JWT tokens. See migration guide at docs/migration.md.
```

**Sposób 3:** Oba (redundant ale jasny)
```
feat(api)!: drop support for XML responses

BREAKING CHANGE: XML response format has been removed.
Use Accept: application/json header.
```

### ⛔ HARD RULES breaking changes

- 🔴 **BREAKING CHANGE musi być uppercase** — `BREAKING CHANGE:`, nie `breaking change:`.
- 🔴 **Zawsze opisz co się zmienia** — nie tylko "breaking change".
- 🔴 **Dodaj instrukcję migracji** — jak user ma się dostosować.
- 🟡 **`!` + footer razem** — jeśli zmiana materialna, użyj obu.

---

## 6. Dobre vs złe commity

### ✅ Dobre commit messages

```bash
feat(auth): add two-factor authentication via TOTP
fix(api): return 404 instead of 500 for missing resources
docs(contributing): add PR template and review guidelines
refactor(db): extract connection pooling into separate module
perf(search): add full-text index on title column
test(auth): add integration tests for OAuth flow
chore(deps): upgrade fastapi from 0.104 to 0.109
ci(github): enable dependabot for Python dependencies
```

### ❌ Złe commit messages

```bash
fix stuff                      # brak type i opisu
updated code                   # co? gdzie? dlaczego?
WIP                            # commituj skończone rzeczy
asdfghjkl                      # 🤦
feat: Add New Feature.         # uppercase, kropka
fix: Fixed the bug             # past tense, co za bug?
misc changes                   # zero informacji
commit                         # 💀
feat: add login and dashboard and settings and profile  # zbyt wiele zmian
```

---

## 7. Atomic Commits

### Zasada

> **1 commit = 1 logiczna zmiana.** Powinieneś móc revert/cherry-pick bez efektów ubocznych.

### ✅ Atomic

```bash
# Osobne commity per logiczna zmiana
git commit -m "feat(auth): add login endpoint"
git commit -m "feat(auth): add password validation"
git commit -m "test(auth): add tests for login flow"
```

### ❌ Non-atomic

```bash
# Jeden mega-commit z wieloma niezwiązanymi zmianami
git commit -m "feat: add login, fix header, update deps, refactor db"
```

### Jak robić atomic commits

```bash
# Stage konkretne pliki (nie git add .)
git add src/auth/login.py src/auth/validation.py
git commit -m "feat(auth): add login with validation"

# Stage fragmenty pliku (interactive)
git add -p  # patch mode — wybieraj hunki
git add -i  # interactive mode

# Rozdziel commity po fakcie (interactive rebase)
git rebase -i HEAD~3  # edytuj ostatnie 3 commity
# W edytorze: zmień 'pick' na 'edit' przy commicie do rozbicia
```

---

## 8. Tooling

### Commitizen (interaktywny commit helper)

```bash
# Install
pip install commitizen

# Interaktywny commit (prowadzi przez formularz)
cz commit
# ? Select the type of change: feat
# ? Scope: auth
# ? Description: add two-factor authentication
# ? Body: (enter to skip)
# ? Breaking?: No
# → Tworzy: feat(auth): add two-factor authentication

# Auto-bump version na podstawie commitów
cz bump

# Generuj CHANGELOG
cz changelog
```

### Commitlint (walidacja commit messages)

```bash
# Install (Node)
npm install --save-dev @commitlint/cli @commitlint/config-conventional

# .commitlintrc.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'refactor', 'perf',
      'test', 'chore', 'ci', 'style', 'build', 'revert'
    ]],
    'subject-case': [2, 'always', 'lower-case'],
    'subject-full-stop': [2, 'never', '.'],
    'header-max-length': [2, 'always', 72],
  }
};
```

> **Git hooks integration** → patrz `06-git-hooks.md`

### Git commit template

```bash
# Ustaw template
git config --global commit.template ~/.gitmessage

# ~/.gitmessage
# <type>[scope]: <description>
#
# [body]
#
# [footer(s)]
#
# Types: feat|fix|docs|refactor|perf|test|chore|ci|style|build|revert
# Scope: optional, e.g. (auth), (api), (ui)
# Description: imperative, lowercase, no period, max 72 chars
```
