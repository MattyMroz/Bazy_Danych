# 00 — Workflow Models

> **Cel:** Porównanie modeli branchowania Git — GitHub Flow, Git-flow, Trunk-Based Development.
> **Scope:** Przenośny — pasuje do dowolnego projektu. Wybierz model pod swój kontekst, nie na odwrót.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [GitHub Flow](#1-github-flow)
3. [Git-flow](#2-git-flow)
4. [Trunk-Based Development](#3-trunk-based-development)
5. [Porównanie i tabela decyzyjna](#4-porównanie-i-tabela-decyzyjna)
6. [Rekomendacja domyślna](#5-rekomendacja-domyślna)

> **Branching conventions** → patrz `01-branching.md`
> **Merge strategies** → patrz `03-pull-requests.md`

---

## 📋 Quick Reference

| Model | Branche stałe | Branche tymczasowe | Deploy | Złożoność |
|-------|--------------|-------------------|--------|-----------|
| **GitHub Flow** | `main` | `feature/*`, `bugfix/*` | Z `main` po merge PR | 🟢 Niska |
| **Git-flow** | `main` + `develop` | `feature/*`, `release/*`, `hotfix/*` | Z `main` po release merge | 🔴 Wysoka |
| **Trunk-Based** | `main` (trunk) | Krótkotrwałe (< 1 dzień) | Z `main`, ciągle | 🟡 Średnia |

**Szybka decyzja:**

```
Czy dostarczasz ciągle (CI/CD, web app)?
├── TAK → GitHub Flow lub Trunk-Based
│   └── Zespół > 20 osób z feature toggles? → Trunk-Based
│   └── Zespół ≤ 20, PR-centric? → GitHub Flow
└── NIE → Utrzymujesz wiele wersji jednocześnie?
    ├── TAK → Git-flow
    └── NIE → GitHub Flow
```

---

## 1. GitHub Flow

### Czym jest?

Najprostszy model branchowania. Jeden stały branch (`main`), wszystkie zmiany przez Pull Requests. Każdy merge do `main` = potencjalny deploy.

### Workflow krok po kroku

```bash
# 1. Utwórz branch z opisową nazwą
git checkout -b feature/user-authentication

# 2. Rób logiczne commity
git add .
git commit -m "feat(auth): add login form component"
git commit -m "feat(auth): implement JWT token validation"

# 3. Push i otwórz PR
git push -u origin feature/user-authentication
gh pr create --title "feat(auth): user authentication" --body "Closes #42"

# 4. Code review + CI muszą przejść
# 5. Squash merge do main
gh pr merge --squash

# 6. Usuń branch
git branch -d feature/user-authentication
```

### Diagram

```
main:     ─●──●──●──────────●──●──●──────── (deploy)
               \            /
feature:        ●──●──●──●─┘   (PR → squash merge → delete branch)
```

### Kiedy stosować

| ✅ Dobre dla | ❌ Złe dla |
|-------------|-----------|
| Web apps, SaaS, API | Software z wieloma wersjami (np. mobile SDK) |
| CI/CD z auto-deploy | Projekty bez CI/CD pipeline |
| Zespoły ≤ 20 osób | Bardzo duże zespoły (100+) bez feature flags |
| Szybkie iteracje (startup) | Regulowane branże (fintech compliance releases) |

### ⛔ HARD RULES

- 🔴 **`main` zawsze deployowalny** — nigdy nie pushuj broken code.
- 🔴 **Każda zmiana przez PR** — zero direct push na `main`.
- 🔴 **CI musi być green** przed merge.
- 🟡 **Branch < 1 tydzień** — im dłużej żyje, tym więcej konfliktów.
- 🟡 **Squash merge** jako default (→ patrz `03-pull-requests.md`).

---

## 2. Git-flow

### Czym jest?

Model branchowania autorstwa Vincenta Driessena (2010). Dwa stałe branche (`main` + `develop`) z trzema typami branchy tymczasowych (`feature/*`, `release/*`, `hotfix/*`).

### Struktura branchy

```
main:       ─●────────────●──────────●──── (produkcja, tagi)
              \          / \        /
release/*:     \  ●──●──●   ●──●──┘
                \  /              \
develop:    ─●──●──●──●──●──●──●──●──●──── (integration)
              \  /        \  /
feature/*:     ●──●──●     ●──●           (development)
```

| Branch | Źródło | Cel merge | Lifetime |
|--------|--------|-----------|----------|
| `main` | — | — | ♾️ Stały |
| `develop` | `main` (init) | — | ♾️ Stały |
| `feature/*` | `develop` | `develop` | Tymczasowy |
| `release/*` | `develop` | `main` + `develop` | Tymczasowy |
| `hotfix/*` | `main` | `main` + `develop` | Tymczasowy |

### Workflow: Feature

```bash
# Start feature
git checkout develop
git checkout -b feature/payment-gateway

# ... praca ...
git commit -m "feat(payment): add Stripe integration"

# Merge back (--no-ff zachowuje historię feature branch)
git checkout develop
git merge --no-ff feature/payment-gateway
git branch -d feature/payment-gateway
```

### Workflow: Release

```bash
# Start release z develop
git checkout develop
git checkout -b release/1.2.0

# Bump version, fix bugs, finalize
git commit -m "chore: bump version to 1.2.0"

# Merge do main + tag
git checkout main
git merge --no-ff release/1.2.0
git tag -a v1.2.0 -m "Release 1.2.0"

# Merge back do develop
git checkout develop
git merge --no-ff release/1.2.0
git branch -d release/1.2.0
```

### Workflow: Hotfix

```bash
# Urgent fix z main
git checkout main
git checkout -b hotfix/1.2.1

# Fix + bump
git commit -m "fix(auth): patch critical XSS vulnerability"
git commit -m "chore: bump version to 1.2.1"

# Merge do main + tag
git checkout main
git merge --no-ff hotfix/1.2.1
git tag -a v1.2.1 -m "Hotfix 1.2.1"

# Merge do develop (lub release branch jeśli istnieje)
git checkout develop
git merge --no-ff hotfix/1.2.1
git branch -d hotfix/1.2.1
```

### Kiedy stosować

| ✅ Dobre dla | ❌ Złe dla |
|-------------|-----------|
| Software z wieloma wersjami | Web apps z CI/CD |
| Regularne release cykle (co 2-4 tygodnie) | Startups potrzebujące szybkich iteracji |
| Duże zespoły z clear ownership | Solo developer / mały team |
| Desktop apps, mobile SDK, biblioteki | Projekty bez formalnych releaseów |

### ⛔ HARD RULES

- 🔴 **`--no-ff` przy merge** — zawsze zachowuj historię branchy.
- 🔴 **`main` = tylko release merges i hotfixy** — zero bezpośrednich commitów.
- 🔴 **Tagi na `main`** — każdy merge do main = tag z wersją.
- 🟡 **Features NIGDY nie mergują do `main`** — zawsze do `develop`.
- 🟡 **Hotfix merguj do `main` AND `develop`** — żaden fix nie ginie.

---

## 3. Trunk-Based Development

### Czym jest?

Model gdzie cały zespół pracuje na jednym branchu (`main`/trunk). Feature branches żyją < 1 dzień. Incomplete features = feature toggles/flags, nie długotrwałe branche.

### Workflow

```bash
# Krótkotrwały branch (godziny, max 1 dzień)
git checkout -b user/add-dark-mode

# Praca + commit
git add .
git commit -m "feat(ui): add dark mode toggle behind feature flag"

# Push + PR (fast review)
git push -u origin user/add-dark-mode
gh pr create

# Fast-forward merge (liniowa historia)
gh pr merge --rebase

# Cleanup
git branch -d user/add-dark-mode
```

### Feature Flags / Toggles

```python
# ✅ Feature za flagą — merguje do main nawet gdy niedokończony
if feature_flags.is_enabled("dark_mode"):
    render_dark_theme()
else:
    render_light_theme()

# ❌ Długotrwały branch zamiast feature flaga
# git checkout -b feature/dark-mode  ← żyje 3 tygodnie, merge hell
```

### Kiedy stosować

| ✅ Dobre dla | ❌ Złe dla |
|-------------|-----------|
| Large-scale teams (Google, Meta) | Brak robustnego CI (każdy commit musi przejść) |
| High-frequency deploys (10+/dzień) | Zespoły bez doświadczenia w feature flags |
| Monorepo z wieloma services | Projekty z długim cyklem release |
| Wymagania na fast defect detection | Solo dev (overkill) |

### ⛔ HARD RULES

- 🔴 **Branch < 1 dzień** — merge daily lub częściej.
- 🔴 **Robust CI** — każdy commit na trunk musi przejść full test suite.
- 🔴 **Feature flags** — incomplete code za togglem, nie w branchu.
- 🟡 **No long-lived branches** — wyjątek: release branches odcięte z trunk.
- 🟢 **Pair programming** — redukuje potrzebę PR review.

---

## 4. Porównanie i tabela decyzyjna

### Matryca porównawcza

| Kryterium | GitHub Flow | Git-flow | Trunk-Based |
|-----------|-------------|----------|-------------|
| **Prostota** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| **CI/CD fit** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Multi-version** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Malé zespoły** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Duże zespoły** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Merge conflicts** | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Onboarding** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| **Release control** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

### Tabela decyzyjna

| Sytuacja | Rekomendacja | Dlaczego |
|----------|-------------|----------|
| Solo developer | GitHub Flow | Najprostsze, zero overhead |
| Startup < 10 osób | GitHub Flow | Szybkie iteracje, PR-centric |
| Team 10-50, CI/CD | GitHub Flow | Proven, wystarczające |
| Team 50+, daily deploys | Trunk-Based | Minimalizuje merge conflicts |
| Biblioteka/SDK z wieloma wersjami | Git-flow | Potrzeba `release/*` i `hotfix/*` |
| Mobile app z App Store releases | Git-flow | Jasne release cykle |
| Open source z contributors | GitHub Flow | Prosta konwencja dla zewnętrznych |

---

## 5. Rekomendacja domyślna

> 💡 **Dla większości projektów: GitHub Flow.**

GitHub Flow jest domyślnym wyborem, chyba że masz **konkretny** powód na Git-flow (wielowersyjność) lub Trunk-Based (masywna skala). Nie stosuj Git-flow "bo brzmi profesjonalnie" — prostota > ceremonia.

### ✅ Checklist: czy GitHub Flow wystarczy?

- [ ] Projekt ma jeden deploy target (web, API, service)?
- [ ] Nie utrzymujesz starych wersji równolegle?
- [ ] Zespół < 50 osób?
- [ ] Masz CI/CD pipeline?

Jeśli **wszystkie TAK** → GitHub Flow. W przeciwnym razie → rozważ alternatywy.
