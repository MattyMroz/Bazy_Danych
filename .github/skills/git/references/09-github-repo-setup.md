# 09 — GitHub Repository Setup

> **Cel:** Community health files, templates, ustawienia repo, README best practices.
> **Scope:** Przenośny — GitHub docs i Open Source conventions.

---

## Spis treści

1. [Quick Reference](#-quick-reference)
2. [README.md](#1-readmemd)
3. [CONTRIBUTING.md](#2-contributingmd)
4. [CODE_OF_CONDUCT.md](#3-code_of_conductmd)
5. [SECURITY.md](#4-securitymd)
6. [Issue Templates](#5-issue-templates)
7. [PR Template](#6-pr-template)
8. [Repository Settings](#7-repository-settings)
9. [License](#8-license)

> **Branch protection** → patrz `04-branch-protection.md`
> **CI/CD** → patrz `10-ci-cd-actions.md`
> **.gitignore** → patrz `08-gitignore.md`

---

## 📋 Quick Reference

**Struktura community health files:**

```
repo/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml
│   │   ├── feature_request.yml
│   │   └── config.yml
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── FUNDING.yml
│   └── CODEOWNERS
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
└── SECURITY.md
```

**Gdzie umieszczać:**

| Plik | Lokalizacja | Fallback |
|------|-------------|----------|
| `README.md` | root | `.github/` lub `docs/` |
| `CONTRIBUTING.md` | root | `.github/` lub `docs/` |
| `CODE_OF_CONDUCT.md` | root | `.github/` lub `docs/` |
| `SECURITY.md` | root | `.github/` |
| `LICENSE` | root | — |
| Issue templates | `.github/ISSUE_TEMPLATE/` | — |
| PR template | `.github/PULL_REQUEST_TEMPLATE.md` | root |
| `CODEOWNERS` | `.github/` | root lub `docs/` |
| `FUNDING.yml` | `.github/` | — |

---

## 1. README.md

### Struktura

```markdown
# Project Name

> One-liner: co to robi i dla kogo.

[![CI](badge-url)](workflow-url)
[![License](badge-url)](LICENSE)
[![Version](badge-url)](releases)

## Features

- Feature 1
- Feature 2
- Feature 3

## Quick Start

### Prerequisites

- Python ≥3.10
- uv

### Installation

\```bash
uv sync
\```

### Usage

\```bash
uv run python main.py
\```

## Documentation

Link do pełnej dokumentacji.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © Author Name
```

### Best Practices

| ✅ Dobrze | ❌ Źle |
|----------|--------|
| Badges na top (CI, version, license) | Brak statusu projektu |
| Quick Start < 5 minut do "running" | Wielostronicowa instrukcja na start |
| Screenshots/GIF jeśli visual | Tylko tekst dla UI project |
| Jasny one-liner na pierwszym zdaniu | "This is a project that..." (fluff) |
| Prerequisites listed explicitly | "Install dependencies" bez detali |
| Contributing section z linkiem | Brak info jak kontrybuować |

---

## 2. CONTRIBUTING.md

### Template

```markdown
# Contributing to [Project Name]

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/amazing-feature`)
3. Commit changes using [Conventional Commits](https://www.conventionalcommits.org/)
4. Push to your branch (`git push origin feat/amazing-feature`)
5. Open a Pull Request

## Development Setup

\```bash
# Clone
git clone https://github.com/user/repo.git
cd repo

# Install dependencies
uv sync

# Run tests
uv run pytest

# Run linter
uv run ruff check .
\```

## Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation
- `refactor:` — code refactor
- `test:` — tests
- `chore:` — maintenance

## Code Style

- Python: PEP 8, enforced by ruff
- Type hints required
- Google-style docstrings

## Pull Request Process

1. Update README.md if needed
2. Ensure all tests pass
3. Get at least 1 code review approval
4. Squash merge to main

## Reporting Bugs

Use [GitHub Issues](link) with the bug report template.
```

---

## 3. CODE_OF_CONDUCT.md

### Rekomendacja

Użyj **Contributor Covenant** — industry standard:

```bash
# Via GitHub UI: Settings → Code and automation → Community health
# Lub: skopiuj z https://www.contributor-covenant.org/version/2/1/code_of_conduct/
```

Alternatywnie przez GitHub CLI:

```bash
# GitHub automatycznie rozpoznaje CODE_OF_CONDUCT.md w root
```

### Kluczowe elementy

- Scope (gdzie obowiązuje)
- Expected behavior
- Unacceptable behavior
- Enforcement (konsekwencje)
- Contact (jak zgłaszać)

---

## 4. SECURITY.md

### Template

```markdown
# Security Policy

## Supported Versions

| Version | Supported |
| ------- | --------- |
| 1.x.x  | ✅        |
| 0.x.x  | ❌        |

## Reporting a Vulnerability

**Do NOT open a public issue for security vulnerabilities.**

Please report via:
1. GitHub Security Advisory: [Create advisory](link)
2. Email: security@example.com

### What to include

- Description of the vulnerability
- Steps to reproduce
- Impact assessment
- Suggested fix (if any)

### Response Timeline

- Acknowledgment: within 48 hours
- Assessment: within 7 days
- Fix: depends on severity (critical: ASAP, others: next release)

## Disclosure Policy

We follow [Coordinated Disclosure](link). We ask that you:
- Allow us reasonable time to fix before public disclosure
- Do not exploit the vulnerability beyond what's needed for demonstration
```

---

## 5. Issue Templates

### Bug Report (YAML form)

```yaml
# .github/ISSUE_TEMPLATE/bug_report.yml
name: 🐛 Bug Report
description: Report a bug or unexpected behavior
labels: ["bug", "triage"]
body:
  - type: markdown
    attributes:
      value: |
        Thanks for reporting! Please fill in the details below.

  - type: textarea
    id: description
    attributes:
      label: Description
      description: Clear description of the bug
    validations:
      required: true

  - type: textarea
    id: steps
    attributes:
      label: Steps to Reproduce
      description: Minimal steps to reproduce
      placeholder: |
        1. Go to '...'
        2. Click on '...'
        3. See error
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What should happen?
    validations:
      required: true

  - type: textarea
    id: actual
    attributes:
      label: Actual Behavior
      description: What actually happens?
    validations:
      required: true

  - type: dropdown
    id: severity
    attributes:
      label: Severity
      options:
        - Critical (app crashes / data loss)
        - Major (feature broken)
        - Minor (cosmetic / workaround exists)
    validations:
      required: true

  - type: textarea
    id: environment
    attributes:
      label: Environment
      description: OS, Python version, browser, etc.
      placeholder: |
        - OS: Windows 11
        - Python: 3.12
        - Browser: Chrome 120
```

### Feature Request (YAML form)

```yaml
# .github/ISSUE_TEMPLATE/feature_request.yml
name: 💡 Feature Request
description: Suggest an idea or improvement
labels: ["enhancement"]
body:
  - type: textarea
    id: problem
    attributes:
      label: Problem
      description: What problem does this solve?
    validations:
      required: true

  - type: textarea
    id: solution
    attributes:
      label: Proposed Solution
      description: How would you solve it?
    validations:
      required: true

  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives Considered
      description: Other approaches you've thought about

  - type: textarea
    id: context
    attributes:
      label: Additional Context
      description: Screenshots, links, examples
```

### Config (link zewnętrzny + blank issue)

```yaml
# .github/ISSUE_TEMPLATE/config.yml
blank_issues_enabled: true
contact_links:
  - name: 💬 Discussion
    url: https://github.com/user/repo/discussions
    about: Ask questions and discuss ideas
  - name: 📖 Documentation
    url: https://docs.example.com
    about: Check documentation first
```

---

## 6. PR Template

```markdown
<!-- .github/PULL_REQUEST_TEMPLATE.md -->

## Description

<!-- What does this PR do? Link to related issue if applicable. -->

Closes #

## Changes

- [ ] Change 1
- [ ] Change 2

## Type of Change

- [ ] 🐛 Bug fix (non-breaking change fixing an issue)
- [ ] ✨ New feature (non-breaking change adding functionality)
- [ ] 💥 Breaking change (fix/feature causing existing functionality to change)
- [ ] 📖 Documentation update
- [ ] 🔧 Refactoring (no functional change)
- [ ] ✅ Tests

## Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review performed
- [ ] Tests added/updated
- [ ] Documentation updated (if needed)
- [ ] No new warnings/errors introduced
```

---

## 7. Repository Settings

### GitHub Settings Checklist

| Setting | Rekomendacja | Gdzie |
|---------|-------------|-------|
| Default branch | `main` | Settings → Branches |
| Branch protection | Enable on `main` | Settings → Branches → Rules |
| Merge strategies | Squash merge (default) | Settings → General → Pull Requests |
| Auto-delete branches | ✅ Enable | Settings → General → Pull Requests |
| Issues | ✅ Enable | Settings → General → Features |
| Discussions | ✅ Enable (jeśli community) | Settings → General → Features |
| Wiki | Disable (use docs/) | Settings → General → Features |
| Projects | Enable (jeśli tracking) | Settings → General → Features |
| Topics | Dodaj 3-5 relevantnych | Repo → About → Topics |
| Description | Jasny one-liner | Repo → About |
| Website | Link do docs/demo | Repo → About |
| Social preview | Custom image 1280×640px | Settings → General |

### GitHub Labels (recommended)

```bash
# Via gh CLI
gh label create "bug" --color "#d73a4a" --description "Something isn't working"
gh label create "enhancement" --color "#a2eeef" --description "New feature or request"
gh label create "documentation" --color "#0075ca" --description "Improvements to docs"
gh label create "good first issue" --color "#7057ff" --description "Good for newcomers"
gh label create "help wanted" --color "#008672" --description "Extra attention needed"
gh label create "priority: critical" --color "#b60205" --description "Must fix ASAP"
gh label create "priority: high" --color "#d93f0b" --description "Important"
gh label create "priority: low" --color "#0e8a16" --description "Nice to have"
gh label create "wontfix" --color "#ffffff" --description "Not planned"
gh label create "duplicate" --color "#cfd3d7" --description "Already exists"
```

---

## 8. License

### Popularne licencje

| Licencja | Permissive? | Patent grant? | Kiedy |
|---------|-------------|--------------|-------|
| **MIT** | ✅ Bardzo | ❌ | Default — prosta, popularna |
| **Apache 2.0** | ✅ | ✅ | Enterprise, patent protection |
| **GPL 3.0** | ❌ Copyleft | ✅ | Wymusza open source derivatives |
| **BSD 2-Clause** | ✅ Bardzo | ❌ | Jak MIT, jeszcze krótsze |
| **Unlicense** | ✅ Public domain | — | Zero ograniczeń |
| **No License** | ❌ ZAMKNIĘTE | — | Domyślnie: all rights reserved! |

### ⛔ HARD RULES license

- 🔴 **Brak licencji = all rights reserved** — nikt nie ma prawa kopiować/używać.
- 🔴 **Wybierz licencję PRZED pierwszym commitem** — dodawanie później jest skomplikowane.
- 🟡 **MIT** to safe default dla większości projektów.
- 🟡 **Sprawdź licencje dependencji** — GPL w dependency = twój projekt musi być GPL.
