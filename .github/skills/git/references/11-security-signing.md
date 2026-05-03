# 11 — Security & Signing

> **Cel:** GPG/SSH commit signing, secrets management, Dependabot, security advisories.
> **Scope:** Przenośny — Git signing i GitHub security features.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [Commit Signing — GPG](#1-commit-signing--gpg)
3. [Commit Signing — SSH](#2-commit-signing--ssh)
4. [Verified Badge](#3-verified-badge)
5. [Secrets Management](#4-secrets-management)
6. [Dependabot](#5-dependabot)
7. [Security Advisories](#6-security-advisories)
8. [Secret Scanning](#7-secret-scanning)

> **Pre-commit hooks (detect secrets)** → patrz `06-git-hooks.md`
> **SECURITY.md template** → patrz `09-github-repo-setup.md`
> **CI/CD secrets** → patrz `10-ci-cd-actions.md`

---

## 📋 Quick Reference

| Feature | Cel | Setup |
|---------|-----|-------|
| GPG signing | "Verified" badge na commitach | GPG key + Git config |
| SSH signing | Alternatywa do GPG (prostsze) | SSH key + Git config |
| Dependabot | Auto-update dependencies | `.github/dependabot.yml` |
| Secret scanning | Wykrywanie leaked secrets | Settings → Security |
| Code scanning | SAST (static analysis) | GitHub Actions + CodeQL |

**Quick setup (GPG):**

```bash
# Generuj klucz
gpg --full-generate-key

# Lista kluczy
gpg --list-secret-keys --keyid-format=long

# Konfiguruj Git
git config --global user.signingkey <KEY-ID>
git config --global commit.gpgsign true

# Dodaj public key do GitHub
gpg --armor --export <KEY-ID> | clip
# → GitHub → Settings → SSH and GPG keys → New GPG key
```

**Quick setup (SSH):**

```bash
# Konfiguruj Git
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

---

## 1. Commit Signing — GPG

### Generowanie klucza

```bash
# Generuj (RSA 4096 lub ECC)
gpg --full-generate-key
# Wybierz: RSA and RSA → 4096 bits → 0 (no expiry) → name + email

# Lista kluczy
gpg --list-secret-keys --keyid-format=long
# sec   rsa4096/ABC1234567890DEF 2024-01-01 [SC]
#       FULL_KEY_FINGERPRINT
# uid                 [ultimate] Your Name <email@example.com>
# ssb   rsa4096/XYZ0987654321GHI 2024-01-01 [E]

# KEY-ID = ABC1234567890DEF (po rsa4096/)
```

### Konfiguracja Git

```bash
# Ustaw signing key
git config --global user.signingkey ABC1234567890DEF

# Auto-sign wszystkie commity
git config --global commit.gpgsign true

# Auto-sign tagi
git config --global tag.gpgsign true

# Specify GPG program (jeśli nie w PATH)
# Windows:
git config --global gpg.program "C:/Program Files (x86)/GnuPG/bin/gpg.exe"
# macOS:
git config --global gpg.program gpg2
```

### Dodaj do GitHub

```bash
# Eksportuj public key
gpg --armor --export ABC1234567890DEF

# Skopiuj output → GitHub → Settings → SSH and GPG keys → New GPG key
```

### Podpisywanie

```bash
# Commit z podpisem (jeśli gpgsign=true → automatyczne)
git commit -S -m "feat: signed commit"

# Tag z podpisem
git tag -s v1.0.0 -m "Signed release"

# Weryfikacja
git log --show-signature -1
git verify-commit HEAD
git verify-tag v1.0.0
```

---

## 2. Commit Signing — SSH

### Konfiguracja (prostsze niż GPG)

```bash
# Użyj istniejącego SSH key
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

### Dodaj do GitHub

1. Settings → SSH and GPG keys → New SSH key
2. Key type: **Signing Key** (nie Authentication Key!)
3. Wklej public key

### Weryfikacja lokalna

```bash
# Allowed signers file (local verification)
echo "$(git config user.email) $(cat ~/.ssh/id_ed25519.pub)" >> ~/.config/git/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.config/git/allowed_signers
```

### GPG vs SSH — porównanie

| Aspekt | GPG | SSH |
|--------|-----|-----|
| Setup complexity | 🔴 Skomplikowane | 🟢 Proste |
| Expiry management | Wbudowane | Brak |
| Web of Trust | Tak | Nie |
| GitHub Verified | ✅ | ✅ |
| Rekomendacja | Enterprise / advanced | Zwykli devs |

---

## 3. Verified Badge

### Jak działa

GitHub pokazuje "Verified" badge przy commicie gdy:

1. Commit jest podpisany (GPG lub SSH)
2. Public key jest dodany do konta GitHub
3. Email w commicie matchuje email na GitHub

### Statusy

| Badge | Znaczenie |
|-------|-----------|
| ✅ Verified | Podpis zweryfikowany — ten user naprawdę commitował |
| ⚠️ Partially verified | Key expired lub email mismatch |
| ❌ Unverified | Brak podpisu lub nieznany key |

### Vigilant mode

```
GitHub → Settings → SSH and GPG keys → Vigilant mode → Enable
```

Oznacza WSZYSTKIE unsigned commity jako "Unverified" — zachęca do signing.

---

## 4. Secrets Management

### Zasady

| ✅ Dobrze | ❌ Źle |
|----------|--------|
| `.env` w `.gitignore` | `.env` w repo |
| GitHub Secrets w CI/CD | Hardcoded keys w kodzie |
| `.env.example` (bez wartości) | `.env` z prawdziwymi credentials |
| Vault / Secret Manager | Plain text w config |
| Rotate co 90 dni | Nigdy nie zmieniać |

### .env pattern

```bash
# .env.example (COMMITUJ — template)
DATABASE_URL=postgresql://user:pass@host:5432/db
API_KEY=your_api_key_here
SECRET_KEY=change_me

# .env (NIGDY nie commituj — prawdziwe wartości)
DATABASE_URL=postgresql://admin:s3cur3@prod.db.io:5432/myapp
API_KEY=sk-abc123def456...
SECRET_KEY=72f0e1b2c3d4e5f6...
```

### Jeśli secret wyciekł

```bash
# 1. NATYCHMIAST rotate credentials
# 2. Usuń z historii (BFG Repo Cleaner)
bfg --delete-files .env
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 3. Force push (po coordination z zespołem!)
git push --force-with-lease

# ⚠️ UWAGA: jeśli ktoś już sklonował — secret jest skompromitowany
# → ROTATE jest JEDYNYM pewnym rozwiązaniem
```

---

## 5. Dependabot

### Konfiguracja

```yaml
# .github/dependabot.yml
version: 2
updates:
  # Python (pip/uv)
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 10
    reviewers:
      - "username"
    labels:
      - "dependencies"
    commit-message:
      prefix: "chore"
      include: "scope"

  # GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    labels:
      - "ci"
    commit-message:
      prefix: "ci"

  # npm
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    labels:
      - "dependencies"
```

### Grupowanie PRs

```yaml
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    groups:
      development:
        dependency-type: "development"
      production:
        dependency-type: "production"
        update-types:
          - "minor"
          - "patch"
```

---

## 6. Security Advisories

### Czym są?

Prywatne drafty do disclosure i fixowania vulnerabilities:

1. Repo → Security → Advisories → New draft
2. Opisz vulnerability (prywatnie)
3. Opcjonalnie: stwórz private fork do fixa
4. Po fix → publikuj advisory

### GitHub Security Lab

```yaml
# .github/workflows/codeql.yml
name: CodeQL

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: "30 6 * * 1"

jobs:
  analyze:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
    strategy:
      matrix:
        language: [python, javascript]
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: ${{ matrix.language }}
      - uses: github/codeql-action/autobuild@v3
      - uses: github/codeql-action/analyze@v3
```

---

## 7. Secret Scanning

### Włącz

```
Settings → Code security and analysis → Secret scanning → Enable
```

### Push protection

```
Settings → Code security and analysis → Push protection → Enable
```

Blokuje push zawierający wykryty secret (API keys, tokens, etc.).

### Custom patterns

```
Settings → Code security and analysis → Secret scanning → New pattern
```

Definiuj regex dla custom secrets (internal API keys, etc.).

### ⛔ HARD RULES security

- 🔴 **Signing = trust** — bez podpisu nie wiadomo kto commitował.
- 🔴 **Secrets nie istnieją w historii Git** — raz = zawsze. Rotate > delete.
- 🔴 **Dependabot ON** — przestarzałe dependencies = vulnerabilities.
- 🔴 **Push protection ON** — blokuj secrety PRZED push (nie po).
- 🟡 **Vigilant mode** — zachęca całą org do signing.
- 🟡 **CodeQL on schedule** — weekly scan nawet bez zmian.
