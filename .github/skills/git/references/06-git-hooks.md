# 06 — Git Hooks

> **Cel:** Automatyzacja quality gates przez Git hooks — pre-commit, commit-msg, pre-push.
> **Scope:** Przenośny — narzędzia (pre-commit, husky) są language-agnostic.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [Czym są Git hooks](#1-czym-są-git-hooks)
3. [Pre-commit framework (Python)](#2-pre-commit-framework-python)
4. [Husky + lint-staged (Node)](#3-husky--lint-staged-node)
5. [Commit-msg validation](#4-commit-msg-validation)
6. [Inne przydatne hooks](#5-inne-przydatne-hooks)
7. [Troubleshooting](#6-troubleshooting)

> **Conventional Commits format** → patrz `02-conventional-commits.md`
> **CI/CD automation** → patrz `10-ci-cd-actions.md`

---

## 📋 Quick Reference

| Hook | Kiedy | Use case | Blocking? |
|------|-------|----------|-----------|
| `pre-commit` | Przed `git commit` | Lint, format, security scan | ✅ TAK |
| `commit-msg` | Przed zapisaniem commit msg | Walidacja Conventional Commits | ✅ TAK |
| `pre-push` | Przed `git push` | Run tests | ✅ TAK |
| `post-merge` | Po `git merge` | Install deps jeśli lock file się zmienił | ❌ NIE |
| `post-checkout` | Po `git checkout` | Cleanup, env setup | ❌ NIE |

**Quick setup (Python):**

```bash
# Install
pip install pre-commit  # lub: uv add --dev pre-commit

# Generate default config
pre-commit sample-config > .pre-commit-config.yaml

# Install hooks
pre-commit install

# Run na wszystkich plikach (test)
pre-commit run --all-files
```

**Quick setup (Node):**

```bash
npm install --save-dev husky lint-staged
npx husky init
echo "npx lint-staged" > .husky/pre-commit
```

---

## 1. Czym są Git hooks

### Mechanizm

Git hooks to skrypty w `.git/hooks/` uruchamiane automatycznie na events:

```
.git/hooks/
├── pre-commit         ← przed commit
├── commit-msg         ← walidacja commit message
├── pre-push           ← przed push
├── post-merge         ← po merge
└── ...
```

### Problem z .git/hooks/

- `.git/` nie jest commitowany → hooki NIE są shared z zespołem.
- Każdy developer musi ręcznie instalować → nikt tego nie robi.

### Rozwiązanie: managed hooks

| Narzędzie | Ekosystem | Jak działa |
|-----------|-----------|------------|
| **pre-commit** | Python (ale universal) | `.pre-commit-config.yaml` w repo |
| **husky** | Node.js | `.husky/` directory w repo |
| **lefthook** | Go (universal) | `lefthook.yml` w repo |

---

## 2. Pre-commit framework (Python)

### Install & Setup

```bash
# Install
pip install pre-commit
# LUB
uv add --dev pre-commit

# Install hooks w repo
pre-commit install                # pre-commit hook
pre-commit install --hook-type commit-msg  # commit-msg hook
pre-commit install --hook-type pre-push    # pre-push hook
```

### Konfiguracja: `.pre-commit-config.yaml`

```yaml
# .pre-commit-config.yaml
repos:
  # ── Ruff (linter + formatter) ──
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.8.0
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format

  # ── Type checking ──
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.13.0
    hooks:
      - id: mypy
        additional_dependencies: [pydantic, types-requests]

  # ── Generic checks ──
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: check-yaml
      - id: check-toml
      - id: check-json
      - id: end-of-file-fixer
      - id: trailing-whitespace
      - id: check-added-large-files
        args: ['--maxkb=500']
      - id: check-merge-conflict
      - id: detect-private-key      # ← security!
      - id: no-commit-to-branch
        args: ['--branch', 'main']  # blokuj direct commit na main

  # ── Commit message validation ──
  - repo: https://github.com/commitizen-tools/commitizen
    rev: v4.1.0
    hooks:
      - id: commitizen
        stages: [commit-msg]

  # ── Markdown ──
  - repo: https://github.com/igorshubovych/markdownlint-cli
    rev: v0.43.0
    hooks:
      - id: markdownlint-fix

  # ── Security scanning ──
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.5.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
```

### Komendy

```bash
# Run na wszystkich plikach
pre-commit run --all-files

# Run konkretny hook
pre-commit run ruff --all-files

# Update hook versions
pre-commit autoupdate

# Skip hooks (emergency only!)
git commit --no-verify -m "hotfix: emergency fix"
# ⚠️ Używaj TYLKO w emergencies, NIGDY jako nawyk!

# Clean cache
pre-commit clean
```

### ⛔ HARD RULES pre-commit

- 🔴 **`.pre-commit-config.yaml` musi być commitowany** — shared z zespołem.
- 🔴 **`detect-private-key` always on** — catch secrets before push.
- 🔴 **`no-commit-to-branch` na `main`** — dodatkowa warstwa ochrony.
- 🟡 **`--no-verify` to emergency exit** — nie nawyk.
- 🟡 **Szybkie hooks** — pre-commit < 10s (przenieś ciężkie testy do CI).

---

## 3. Husky + lint-staged (Node)

### Setup

```bash
# Install
npm install --save-dev husky lint-staged
# OR
npx husky-init && npm install

# Initialize
npx husky init
```

### Pre-commit hook

```bash
# .husky/pre-commit
npx lint-staged
```

### lint-staged config

```json
// package.json lub .lintstagedrc.json
{
  "lint-staged": {
    "*.{js,ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.{css,scss}": ["prettier --write"],
    "*.md": ["markdownlint --fix"],
    "*.py": ["ruff check --fix", "ruff format"],
    "*.{json,yaml,yml}": ["prettier --write"]
  }
}
```

### Commit-msg hook

```bash
# .husky/commit-msg
npx --no -- commitlint --edit $1
```

```js
// .commitlintrc.js
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

---

## 4. Commit-msg validation

### Regex pattern (prosty)

```bash
#!/bin/sh
# .git/hooks/commit-msg (lub .husky/commit-msg)

commit_msg=$(cat "$1")
pattern="^(feat|fix|docs|refactor|perf|test|chore|ci|style|build|revert)(\([a-z0-9-]+\))?(!)?: .{1,72}$"

if ! echo "$commit_msg" | head -1 | grep -qE "$pattern"; then
  echo "❌ Invalid commit message format!"
  echo "Expected: <type>[scope]: <description>"
  echo "Example:  feat(auth): add login endpoint"
  echo ""
  echo "Types: feat|fix|docs|refactor|perf|test|chore|ci|style|build|revert"
  exit 1
fi
```

### Commitizen (Python)

```bash
# Install
pip install commitizen

# W .pre-commit-config.yaml:
- repo: https://github.com/commitizen-tools/commitizen
  rev: v4.1.0
  hooks:
    - id: commitizen
      stages: [commit-msg]
```

### Commitlint (Node)

```bash
npm install --save-dev @commitlint/cli @commitlint/config-conventional
```

---

## 5. Inne przydatne hooks

### Pre-push: run tests

```bash
# .husky/pre-push LUB .git/hooks/pre-push
#!/bin/sh
echo "Running tests before push..."
pytest tests/ -q --tb=line
if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Push aborted."
  exit 1
fi
```

### Post-merge: auto install deps

```bash
#!/bin/sh
# Jeśli lockfile się zmienił → install deps
changed_files=$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD)

if echo "$changed_files" | grep -q "uv.lock"; then
  echo "📦 uv.lock changed, running uv sync..."
  uv sync
fi

if echo "$changed_files" | grep -q "package-lock.json"; then
  echo "📦 package-lock.json changed, running npm install..."
  npm install
fi
```

---

## 6. Troubleshooting

| Problem | Rozwiązanie |
|---------|-------------|
| Hook nie uruchamia się | `pre-commit install` (reinstall) |
| Hook za wolny | Przenieś ciężkie operacje do CI |
| Hook blokuje emergency commit | `git commit --no-verify` (jednorazowo!) |
| Permission denied | `chmod +x .husky/pre-commit` |
| pre-commit cache stary | `pre-commit clean && pre-commit install` |
| Hook łamie na Windows | Sprawdź line endings (LF vs CRLF) |
