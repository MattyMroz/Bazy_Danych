---
applyTo: "**/*.md"
---

# Markdown Instructions

## Język & ton

- **Polski** z angielskimi terminami technicznymi
- Konkretnie i zwięźle — bullet points > akapity
- Bez corporate-speak i filler words

## Formatowanie

- **Nagłówki hierarchiczne** — H1 > H2 > H3 (nigdy skip level)
- **Listy** — `-` dla unordered, `1.` dla ordered (procedury/kroki)
- **Tabele** — dla porównań, referencji, mappingów
- **Emoji** — umiarkowanie jako marker sekcji (3-5 per dokument)
- **Bold** — dla kluczowych terminów i nazw, nie dla całych zdań
- **Code blocks** — zawsze z językiem: ` ```python `, ` ```tsx `, ` ```bash `
- **Inline code** — `` `nazwy_zmiennych` ``, `` `komendy` ``, `` `ścieżki/plików` ``

## Linki & referencje

- **Relatywne ścieżki** wewnątrz repo — `[docs/README.md](docs/README.md)`
- **Link, don't embed** — nie kopiuj treści z innych plików, linkuj

## YAML frontmatter

- **Wymagany** w plikach `.github/` (`agent.md`, `SKILL.md`, `instructions.md`, `prompt.md`)
- Minimalne pola: `applyTo` (instructions), `mode` (agents)

## Struktura dokumentu

```markdown
# Tytuł (1 per dokument)

Krótki opis — 1-2 zdania.

## Sekcja

- Punkt 1
- Punkt 2

## Kolejna sekcja

| Kolumna | Opis |
|---------|------|
| Wartość | ...  |
```
