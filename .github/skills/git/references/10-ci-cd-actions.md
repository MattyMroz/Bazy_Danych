# 10 — CI/CD z GitHub Actions

> **Cel:** GitHub Actions workflow syntax, patterns, matrix testing, caching, reusable workflows.
> **Scope:** Przenośny — GitHub Actions to standard CI/CD dla GitHub repos.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [Workflow Syntax](#1-workflow-syntax)
3. [Triggery](#2-triggery)
4. [Common Patterns](#3-common-patterns)
5. [Matrix Testing](#4-matrix-testing)
6. [Caching](#5-caching)
7. [Secrets](#6-secrets)
8. [Reusable Workflows](#7-reusable-workflows)
9. [Status Badges](#8-status-badges)

> **Branch protection + required checks** → patrz `04-branch-protection.md`
> **Auto-release** → patrz `05-versioning-releases.md`
> **Pre-commit** → patrz `06-git-hooks.md`

---

## 📋 Quick Reference

**Lokalizacja:** `.github/workflows/*.yml`

```yaml
# Minimalny workflow
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install -e ".[test]"
      - run: pytest
```

**Komendy GitHub CLI:**

```bash
# Lista workflows
gh workflow list

# Status runs
gh run list

# Trigger workflow ręcznie
gh workflow run ci.yml

# Zobacz logi
gh run view <run-id> --log
```

---

## 1. Workflow Syntax

### Struktura

```yaml
name: CI Pipeline           # nazwa workflow

on:                          # trigger(y)
  push:
    branches: [main]
  pull_request:
    branches: [main]

permissions:                 # principle of least privilege
  contents: read

env:                         # zmienne globalne
  PYTHON_VERSION: "3.12"

jobs:
  job-name:                  # identyfikator joba
    name: "Display Name"    # wyświetlana nazwa
    runs-on: ubuntu-latest   # runner

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Run tests
        run: pytest
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

### Kluczowe elementy

| Element | Opis |
|---------|------|
| `name` | Nazwa workflow (widoczna w UI) |
| `on` | Trigger(y) uruchamiające workflow |
| `permissions` | Uprawnienia GITHUB_TOKEN |
| `env` | Zmienne środowiskowe (globalne) |
| `jobs` | Mapa jobów do wykonania |
| `runs-on` | Typ runnera (OS) |
| `steps` | Sekwencja kroków joba |
| `uses` | Zewnętrzna action |
| `run` | Komenda shell |
| `with` | Parametry dla action |
| `if` | Conditional execution |
| `needs` | Zależność między jobami |

---

## 2. Triggery

### Popularne

```yaml
on:
  # Push na konkretne branche
  push:
    branches: [main, develop]
    paths:
      - "src/**"
      - "tests/**"
    paths-ignore:
      - "docs/**"
      - "*.md"

  # Pull Request
  pull_request:
    branches: [main]
    types: [opened, synchronize, reopened]

  # Scheduled (cron)
  schedule:
    - cron: "0 6 * * 1"  # Poniedziałek 6:00 UTC

  # Manual
  workflow_dispatch:
    inputs:
      environment:
        description: "Deploy environment"
        required: true
        type: choice
        options: [staging, production]

  # Release
  release:
    types: [published]

  # Tag push
  push:
    tags:
      - "v*"
```

### Path filtering

```yaml
on:
  push:
    paths:
      - "src/**"          # tylko gdy zmienia się src/
      - "!src/**/*.md"    # ale nie markdown w src/
    paths-ignore:
      - "docs/**"         # ignoruj zmiany w docs/
      - "*.md"            # ignoruj root markdown
```

---

## 3. Common Patterns

### Python CI

```yaml
name: Python CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

permissions:
  contents: read

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v4

      - name: Set up Python
        run: uv python install 3.12

      - name: Install dependencies
        run: uv sync --all-extras

      - name: Ruff check
        run: uv run ruff check .

      - name: Ruff format check
        run: uv run ruff format --check .

      - name: Type check
        run: uv run mypy src/

  test:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v4

      - name: Set up Python
        run: uv python install 3.12

      - name: Install dependencies
        run: uv sync --all-extras

      - name: Run tests
        run: uv run pytest --cov=src/ --cov-report=xml

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          token: ${{ secrets.CODECOV_TOKEN }}
          files: ./coverage.xml
```

### Node.js CI

```yaml
name: Node CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: "npm"
      - run: npm ci
      - run: npm run lint
      - run: npm test
      - run: npm run build
```

### Deploy on tag

```yaml
name: Deploy

on:
  push:
    tags:
      - "v*"

permissions:
  contents: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: make build
      - name: Create Release
        uses: softprops/action-gh-release@v2
        with:
          files: dist/*
          generate_release_notes: true
```

---

## 4. Matrix Testing

### Multi-version

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.10", "3.11", "3.12", "3.13"]
      fail-fast: false  # nie przerywaj na pierwszym failure
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: pip install -e ".[test]"
      - run: pytest
```

### Multi-OS + Multi-version

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest, windows-latest]
    python-version: ["3.11", "3.12"]
    exclude:
      - os: macos-latest
        python-version: "3.11"  # skip macOS + 3.11
    include:
      - os: ubuntu-latest
        python-version: "3.12"
        coverage: true  # extra flag
```

---

## 5. Caching

### uv cache

```yaml
- name: Install uv
  uses: astral-sh/setup-uv@v4
  with:
    enable-cache: true     # auto-cache uv
```

### pip cache

```yaml
- uses: actions/setup-python@v5
  with:
    python-version: "3.12"
    cache: "pip"  # auto-cache pip
```

### npm cache

```yaml
- uses: actions/setup-node@v4
  with:
    node-version: 20
    cache: "npm"  # auto-cache npm
```

### Custom cache

```yaml
- uses: actions/cache@v4
  with:
    path: |
      ~/.cache/pre-commit
      .mypy_cache
    key: ${{ runner.os }}-misc-${{ hashFiles('.pre-commit-config.yaml') }}
    restore-keys: |
      ${{ runner.os }}-misc-
```

---

## 6. Secrets

### Konfiguracja

```
Settings → Secrets and variables → Actions → New repository secret
```

### Użycie

```yaml
steps:
  - name: Deploy
    env:
      API_KEY: ${{ secrets.API_KEY }}
      DATABASE_URL: ${{ secrets.DATABASE_URL }}
    run: ./deploy.sh
```

### Environment secrets

```yaml
jobs:
  deploy:
    environment: production  # wymaga approval
    steps:
      - run: echo ${{ secrets.PROD_API_KEY }}
```

### ⛔ HARD RULES secrets

- 🔴 **NIGDY nie loguj secrets** — `echo $SECRET` w logach = wyciek.
- 🔴 **Secrets NIGDY w kodzie** — zawsze przez `${{ secrets.X }}`.
- 🔴 **Environment protection** — production wymaga manual approval.
- 🟡 **Rotate secrets regularnie** — co 90 dni minimum.
- 🟡 **Least privilege** — minime uprawnienia w `permissions:`.

---

## 7. Reusable Workflows

### Definicja (called workflow)

```yaml
# .github/workflows/reusable-test.yml
name: Reusable Test

on:
  workflow_call:
    inputs:
      python-version:
        required: true
        type: string
    secrets:
      codecov-token:
        required: false

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ inputs.python-version }}
      - run: pip install -e ".[test]"
      - run: pytest --cov
```

### Wywołanie (caller workflow)

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test-312:
    uses: ./.github/workflows/reusable-test.yml
    with:
      python-version: "3.12"
    secrets:
      codecov-token: ${{ secrets.CODECOV_TOKEN }}

  test-311:
    uses: ./.github/workflows/reusable-test.yml
    with:
      python-version: "3.11"
```

---

## 8. Status Badges

### Markdown

```markdown
[![CI](https://github.com/USER/REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/USER/REPO/actions/workflows/ci.yml)
[![CI](https://github.com/USER/REPO/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/USER/REPO/actions/workflows/ci.yml)
```

### W README na top

```markdown
# Project Name

[![CI](badge-ci)](link-ci)
[![Coverage](badge-cov)](link-cov)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Python 3.12](https://img.shields.io/badge/python-3.12-blue.svg)](https://python.org)
```
