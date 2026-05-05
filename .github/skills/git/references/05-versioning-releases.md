# 05 — Versioning & Releases

> **Cel:** Semantic Versioning, Git tagi, GitHub Releases, Keep a Changelog, auto-generation.
> **Scope:** Przenośny — SemVer 2.0.0 i Keep a Changelog to otwarte standardy.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [Semantic Versioning 2.0.0](#1-semantic-versioning-200)
3. [Git Tags](#2-git-tags)
4. [Keep a Changelog](#3-keep-a-changelog)
5. [GitHub Releases](#4-github-releases)
6. [Automatyzacja](#5-automatyzacja)

> **Conventional Commits → SemVer mapping** → patrz `02-conventional-commits.md`
> **Release branches** → patrz `00-workflow-models.md`

---

## 📋 Quick Reference

**SemVer format:** `MAJOR.MINOR.PATCH[-prerelease][+build]`

| Bump | Kiedy | Przykład |
|------|-------|---------|
| **MAJOR** | Breaking change | `1.0.0` → `2.0.0` |
| **MINOR** | Nowa feature (backward-compatible) | `1.0.0` → `1.1.0` |
| **PATCH** | Bug fix (backward-compatible) | `1.0.0` → `1.0.1` |

**Conventional Commits → SemVer:**

| Commit type | Bump |
|-------------|------|
| `feat` | MINOR |
| `fix` | PATCH |
| `perf` | PATCH |
| BREAKING CHANGE (`!` lub footer) | MAJOR |
| `docs`, `refactor`, `test`, `chore`, `ci` | Brak bump |

**Komendy:**

```bash
# Tag release
git tag -a v1.2.0 -m "Release 1.2.0: new features"
git push origin v1.2.0

# GitHub Release (CLI)
gh release create v1.2.0 --title "Release 1.2.0" --notes-file RELEASE_NOTES.md
```

---

## 1. Semantic Versioning 2.0.0

### Format

```
MAJOR.MINOR.PATCH[-prerelease][+build]
```

| Element | Opis | Przykład |
|---------|------|---------|
| MAJOR | Incompatible API changes | `2.0.0` |
| MINOR | Backward-compatible additions | `1.1.0` |
| PATCH | Backward-compatible bug fixes | `1.0.1` |
| prerelease | Pre-release identifier | `1.0.0-alpha`, `1.0.0-rc.1` |
| build | Build metadata (ignorowane w precedence) | `1.0.0+20240101` |

### Precedence (sortowanie)

```
0.1.0 < 0.2.0 < 0.9.0 < 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-beta
< 1.0.0-beta.2 < 1.0.0-rc.1 < 1.0.0 < 1.0.1 < 1.1.0 < 2.0.0
```

### Initial Development (0.y.z)

```
0.1.0  → initial development, anything may change
0.2.0  → new features (unstable API)
0.9.0  → approaching stable
1.0.0  → first stable public API
```

- 🔴 **0.y.z = unstable** — wszystko może się zmienić.
- 🔴 **1.0.0 = public API commitment** — od teraz SemVer obowiązuje.
- 🟡 **Nie bój się 0.y.z** — lepiej niż fałszywe 1.0.0 bez stable API.

### Kiedy bumpować co?

| Zmieniłem... | Bump | Przykład |
|-------------|------|---------|
| Usunąłem publiczną funkcję | MAJOR | `remove_user()` deleted |
| Zmiana sygnatury (breaking) | MAJOR | `get_user(id)` → `get_user(id, tenant_id)` (required) |
| Zmiana return type | MAJOR | `get_users() → List[User]` → `Dict` |
| Nowy endpoint / feature | MINOR | `POST /api/preferences` added |
| Nowy opcjonalny parametr | MINOR | `get_user(id, fields=None)` |
| Fix buga bez zmiany API | PATCH | `fix divide by zero` |
| Performance improvement | PATCH | `optimize query` |
| Dependency update (non-breaking) | PATCH | `upgrade requests 2.31 → 2.32` |

### ⛔ HARD RULES SemVer

- 🔴 **Breaking change = MAJOR bump** — zawsze, bez wyjątków.
- 🔴 **Opublikowana wersja jest immutable** — `1.2.0` nie zmienia się.
- 🔴 **Pre-release < release** — `1.0.0-rc.1` < `1.0.0`.
- 🟡 **Nie bumpuj MAJOR za refactor** — jeśli public API się nie zmieniło = nie breaking.

---

## 2. Git Tags

### Annotated vs Lightweight

```bash
# ✅ Annotated (rekomendowane) — przechowuje autora, datę, message
git tag -a v1.2.0 -m "Release 1.2.0: new API endpoints"

# ❌ Lightweight (pointer) — brak metadata
git tag v1.2.0
```

### Zarządzanie tagami

```bash
# Lista tagów
git tag -l
git tag -l "v1.*"

# Info o tagu
git show v1.2.0

# Push tagi
git push origin v1.2.0    # push jeden
git push origin --tags     # push wszystkie

# Usuń tag
git tag -d v1.2.0                    # lokalnie
git push origin --delete v1.2.0      # remote

# Tag na konkretnym commicie
git tag -a v1.2.0 a1b2c3 -m "Release 1.2.0"

# Checkout taga
git checkout v1.2.0              # detached HEAD
git checkout -b hotfix/v1.2.1 v1.2.0  # nowy branch z taga
```

### Konwencja nazewnictwa tagów

| Konwencja | Przykład | Kiedy |
|-----------|---------|-------|
| `v` prefix | `v1.2.0` | Standard (rekomendowane) |
| Bez prefix | `1.2.0` | Alternatywne (rzadziej) |
| Pre-release | `v1.2.0-rc.1` | Release candidate |
| Build metadata | `v1.2.0+build.123` | CI build tracking |

### ⛔ HARD RULES tagi

- 🔴 **Annotated tags** — zawsze `-a` (metadata = kto, kiedy, dlaczego).
- 🔴 **Tag = immutable** — nigdy nie przesuwaj taga. Nowy fix = nowy tag.
- 🟡 **`v` prefix** — `v1.2.0` (convention, rozpoznawalne).
- 🟡 **Podpisuj tagi** — `git tag -s v1.2.0` (→ patrz `11-security-signing.md`).

---

## 3. Keep a Changelog

### Format

Plik `CHANGELOG.md` w root repo:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- New dashboard widget for analytics

### Changed
- Improved database query performance by 30%

## [1.4.0] - 2024-11-15

### Added
- Dark mode support
- API endpoint for user preferences

### Fixed
- Login button overflow on mobile devices

### Security
- Fixed XSS vulnerability in markdown parser

## [1.3.0] - 2024-10-20

### Added
- Export data to CSV format

### Deprecated
- Legacy authentication method (use OAuth 2.0 instead)
```

### Sekcje zmian

| Sekcja | Kiedy | Priorytet |
|--------|-------|-----------|
| `Added` | Nowe features | 🟢 |
| `Changed` | Zmiany w istniejącej funkcjonalności | 🟡 |
| `Deprecated` | Oznaczone do usunięcia w przyszłości | 🟡 |
| `Removed` | Usunięte features | 🔴 |
| `Fixed` | Bug fixes | 🔴 |
| `Security` | Vulnerability fixes | 🔴 KRYTYCZNE |

### Best Practices

| ✅ Dobrze | ❌ Źle |
|----------|--------|
| Czytelne dla ludzi, nie maszyn | Auto-dump z `git log` |
| `[Unreleased]` section na top | Brak tracking WIP |
| ISO 8601 daty: `2024-11-15` | `Nov 15, 2024` (niejednoznaczne) |
| Linkowane wersje do tagów | Plain text bez linków |
| Mention breaking changes wyraźnie | Breaking change ukryty w "Changed" |

### ⛔ HARD RULES changelog

- 🔴 **`[Unreleased]` zawsze na top** — zbieraj zmiany na next release.
- 🔴 **Nie auto-generuj z git log** — commity ≠ user-facing changes.
- 🟡 **Każdy wpis opisuje co się zmienia z perspektywy usera** — nie impl details.
- 🟡 **Security changes na top** — najważniejsze pierwsze.

---

## 4. GitHub Releases

### Tworzenie (CLI)

```bash
# Prosty release
gh release create v1.2.0 --title "Release 1.2.0" --notes "New features and bug fixes"

# Release z CHANGELOG
gh release create v1.2.0 --title "Release 1.2.0" --notes-file CHANGELOG_EXCERPT.md

# Pre-release
gh release create v1.3.0-rc.1 --prerelease --title "Release 1.3.0 RC1"

# Draft
gh release create v1.3.0 --draft --title "Release 1.3.0"

# Z załącznikami (binaries)
gh release create v1.2.0 ./dist/myapp-1.2.0.tar.gz --title "Release 1.2.0"

# Auto-generate notes z PR titles
gh release create v1.2.0 --generate-notes
```

### Tworzenie (UI)

1. Repo → Releases → Draft a new release
2. Choose tag: `v1.2.0`
3. Title: `Release 1.2.0`
4. Description: kopiuj z CHANGELOG.md (sekcja dla tej wersji)
5. Attach binaries jeśli relevant
6. Pre-release: ✅ jeśli `rc`, `alpha`, `beta`
7. Publish release

### Auto-generate Release Notes

GitHub automatycznie generuje notes z PR titles:

```yaml
# .github/release.yml — konfiguracja auto-notes
changelog:
  categories:
    - title: "🚀 Features"
      labels: ["feature", "enhancement"]
    - title: "🐛 Bug Fixes"
      labels: ["bug", "bugfix"]
    - title: "📖 Documentation"
      labels: ["documentation"]
    - title: "🔧 Maintenance"
      labels: ["chore", "dependencies"]
```

---

## 5. Automatyzacja

### Commitizen (Python)

```bash
# Install
pip install commitizen
# OR
uv add --dev commitizen

# Interaktywny commit
cz commit

# Auto-bump version z commitów
cz bump
# Analizuje commity od ostatniego taga:
# feat → MINOR, fix → PATCH, BREAKING → MAJOR

# Generuj CHANGELOG
cz changelog
```

**`pyproject.toml`:**
```toml
[tool.commitizen]
name = "cz_conventional_commits"
version = "1.2.0"
tag_format = "v$version"
version_files = [
    "pyproject.toml:^version",
    "src/__init__.py:^__version__",
]
```

### Python Semantic Release (GitHub Actions)

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    branches: [main]

permissions:
  contents: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Python Semantic Release
        uses: python-semantic-release/python-semantic-release@master
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Release workflow recommendation

```
Merge PR → CI green → Auto-calculate version bump
→ Update CHANGELOG → Create tag → Create GitHub Release
```

Całość automatycznie — zero manual steps po merge.
