# 08 — .gitignore

> **Cel:** Co ignorować, wzorce, per-language templates, narzędzia.
> **Scope:** Przenośny — wzorce `.gitignore` działają na każdym systemie.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [Czym jest .gitignore](#1-czym-jest-gitignore)
3. [Syntax](#2-syntax)
4. [Co NIGDY nie powinno trafić do repo](#3-co-nigdy-nie-powinno-trafić-do-repo)
5. [Template Python](#4-template-python)
6. [Template Node/TypeScript](#5-template-nodetypescript)
7. [Template uniwersalny](#6-template-uniwersalny)
8. [Narzędzia i diagnostyka](#7-narzędzia-i-diagnostyka)

> **Security scanning** → patrz `11-security-signing.md`
> **Pre-commit security hooks** → patrz `06-git-hooks.md`

---

## 📋 Quick Reference

```bash
# Sprawdź czy plik jest ignorowany
git check-ignore -v path/to/file

# Lista ignorowanych plików
git status --ignored

# Wymuszenie dodania ignorowanego pliku
git add -f path/to/file

# Usuń plik z tracking (ale zostaw na dysku)
git rm --cached path/to/file

# Usuń folder z tracking
git rm -r --cached path/to/folder/

# Globalny gitignore (per user)
git config --global core.excludesfile ~/.gitignore_global
```

---

## 1. Czym jest .gitignore

Plik `.gitignore` mówi Gitowi, które pliki/foldery ignorować w tracking.

```
.gitignore          ← root repo (główny)
src/.gitignore      ← per-directory (override)
~/.gitignore_global ← per-user (nie commitowany)
.git/info/exclude   ← per-repo (nie commitowany)
```

### Priorytet (od najwyższego)

1. Wzorce z command line (`git add -f`)
2. `.gitignore` w bieżącym directory
3. `.gitignore` w parent directories (aż do root repo)
4. `$GIT_DIR/info/exclude`
5. `core.excludesfile` (global config)

---

## 2. Syntax

| Wzorzec | Znaczenie | Przykład |
|---------|-----------|---------|
| `file.txt` | Ignoruj konkretny plik (wszędzie) | `debug.log` |
| `*.log` | Wildcard — wszystkie pliki .log | `*.log` |
| `dir/` | Ignoruj cały directory | `node_modules/` |
| `!important.log` | Negacja — NIE ignoruj | `!.gitkeep` |
| `**/logs` | Dowolna głębokość | `**/build/` |
| `doc/*.txt` | Wzorzec w dir | `doc/notes.txt` (nie `doc/a/b.txt`) |
| `doc/**/*.txt` | Recursive w dir | `doc/a/b/c.txt` |
| `#` | Komentarz | `# IDE files` |
| `\#` | Escape (literalny #) | `\#backup#` |

### Ważne nuance'y

```gitignore
# Ignoruj folder (z trailing slash)
build/

# Ignoruj plik LUB folder o nazwie 'build' (bez trailing slash)
build

# Ignoruj .env ale nie .env.example
.env
!.env.example

# Ignoruj wszystko w dir ale zachowaj dir (empty dir trick)
logs/*
!logs/.gitkeep
```

---

## 3. Co NIGDY nie powinno trafić do repo

### ⛔ ABSOLUTNE HARD RULES

| Kategoria | Przykłady | Dlaczego |
|-----------|-----------|----------|
| 🔴 **Secrets** | `.env`, API keys, tokens, passwords | Security breach |
| 🔴 **Private keys** | `*.pem`, `*.key`, `id_rsa` | Security breach |
| 🔴 **Database files** | `*.db`, `*.sqlite3` (z danymi) | PII/data leak |
| 🔴 **Auth tokens** | `*.token`, service accounts JSON | Security breach |
| 🟡 **Dependencies** | `node_modules/`, `.venv/`, `__pycache__/` | Zbyt duże, reproducible |
| 🟡 **Build artifacts** | `dist/`, `build/`, `*.pyc`, `*.o` | Reproducible from source |
| 🟡 **IDE config** | `.idea/`, `.vscode/settings.json` | Per-developer |
| 🟡 **OS files** | `.DS_Store`, `Thumbs.db`, `desktop.ini` | System noise |
| 🟡 **Logs** | `*.log`, `logs/` | Ephemeral |
| 🟡 **Cache** | `.cache/`, `.pytest_cache/` | Ephemeral |

### Co jest OK do commitowania

| Plik | Dlaczego |
|------|----------|
| `.env.example` | Template (bez wartości!) |
| `.vscode/extensions.json` | Rekomendowane extensions |
| `.vscode/launch.json` | Shared debug config (bez secrets) |
| `docker-compose.yml` | Infrastructure as code |
| Lock files (`uv.lock`, `package-lock.json`) | Reproducible builds |

---

## 4. Template Python

```gitignore
# ── Python ──
__pycache__/
*.py[cod]
*$py.class
*.so
*.egg-info/
*.egg
dist/
build/
sdist/
wheels/
*.whl

# ── Virtual environments ──
.venv/
venv/
ENV/
env/

# ── Type checking ──
.mypy_cache/
.pytype/

# ── Testing ──
.pytest_cache/
.coverage
htmlcov/
.tox/
.nox/

# ── Linting ──
.ruff_cache/

# ── Jupyter ──
.ipynb_checkpoints/

# ── Distribution ──
*.manifest
*.spec
pip-log.txt
pip-delete-this-directory.txt

# ── Environment ──
.env
.env.local
.env.*.local
!.env.example

# ── IDE ──
.idea/
.vscode/settings.json
*.swp
*.swo
*~

# ── OS ──
.DS_Store
Thumbs.db
desktop.ini

# ── Logs ──
*.log
logs/

# ── Database ──
*.db
*.sqlite3
```

---

## 5. Template Node/TypeScript

```gitignore
# ── Dependencies ──
node_modules/
.pnp/
.pnp.js
.yarn/install-state.gz

# ── Build ──
dist/
build/
.next/
out/

# ── Testing ──
coverage/
.nyc_output/

# ── Cache ──
.cache/
.turbo/
.eslintcache
*.tsbuildinfo

# ── Environment ──
.env
.env.local
.env.*.local
!.env.example

# ── IDE ──
.idea/
.vscode/settings.json
*.swp
*.swo

# ── OS ──
.DS_Store
Thumbs.db
desktop.ini

# ── Logs ──
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# ── Misc ──
*.tgz
.npmrc
```

---

## 6. Template uniwersalny

```gitignore
# ── Secrets (ABSOLUTNY MUST) ──
.env
.env.local
.env.*.local
!.env.example
*.pem
*.key
*.p12
*.pfx
*.jks
*.keystore

# ── OS ──
.DS_Store
Thumbs.db
desktop.ini
ehthumbs.db
[Dd]esktop.ini
$RECYCLE.BIN/

# ── IDE ──
.idea/
.vscode/settings.json
*.swp
*.swo
*~
*.sublime-workspace
*.sublime-project

# ── Logs ──
*.log
logs/

# ── Temporary ──
tmp/
temp/
*.tmp
*.bak
*.backup
*.orig
```

---

## 7. Narzędzia i diagnostyka

### gitignore.io

```bash
# Generuj .gitignore z templates
curl -sL https://www.toptal.com/developers/gitignore/api/python,node,vscode > .gitignore

# Albo: https://www.toptal.com/developers/gitignore
```

### Diagnostyka

```bash
# Dlaczego plik jest/nie jest ignorowany?
git check-ignore -v path/to/file
# .gitignore:5:*.log    path/to/file.log

# Czy plik jest tracked?
git ls-files path/to/file

# Usuń plik z tracking (ale zachowaj na dysku)
git rm --cached path/to/file
git commit -m "chore: remove tracked file from repo"

# Usuń cały folder z tracking
git rm -r --cached node_modules/
git commit -m "chore: remove node_modules from tracking"
```

### ⚠️ Pułapka: plik już jest tracked

```bash
# .gitignore NIE działa na pliki ALREADY tracked!
# Musisz najpierw usunąć z tracking:

echo "secrets.json" >> .gitignore
git rm --cached secrets.json
git commit -m "chore: stop tracking secrets.json"

# DOPIERO TERAZ .gitignore ignoruje ten plik
```

### ⛔ HARD RULES gitignore

- 🔴 **Zawsze `.gitignore` PRZED pierwszym commitem** — łatwiej zapobiec niż usuwać z historii.
- 🔴 **Secrets NIGDY w repo** — nawet na 1 sekundę. Raz w historii = compromised.
- 🔴 **Jeśli secret wyciekł** → rotate keys NATYCHMIAST (usunięcie z repo NIE wystarczy — historia git!).
- 🟡 **Plik tracked + dodany do .gitignore = dalej tracked** — potrzebny `git rm --cached`.
- 🟡 **Lock files COMMITUJ** — `uv.lock`, `package-lock.json` (reproducible builds).
