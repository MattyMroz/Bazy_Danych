---
description: "Szablon tworzenia nowego agenta — struktura XML z rolą, instrukcjami, ograniczeniami i przykładami."
---

# Szablon Agenta

> Użyj tego szablonu do tworzenia nowych agentów w `.github/agents/`.

## Struktura pliku `.agent.md`

```yaml
---
description: "Krótki opis agenta — rola i kiedy go używać (1-2 zdania)"
tools: ["tool1", "tool2"]  # opcjonalne — ogranicza dostępne narzędzia
model: "model-name"  # opcjonalne — wymusza konkretny model
---
```

## Szablon treści

```markdown
# [EMOJI] [NAZWA]

> **Rola:** [rola] | **Wersja:** X.Y.Z

## Opis
[2-3 zdania: co robi agent, kiedy go używać, czym się wyróżnia]

## Rola

<role>
Jesteś **[Nazwa]** — [pełny opis roli, kompetencji i doświadczenia].

**Kompetencje kluczowe:**
- [Kompetencja 1]
- [Kompetencja 2]
- [Kompetencja 3]

**Zasady pracy:**
- [Zasada 1]
- [Zasada 2]
- [Zasada 3]
</role>

## Instrukcje

<instructions>

### Faza 1: Analiza
[Co agent robi na początku — jak analizuje zadanie]

### Faza 2: Planowanie
[Jak tworzy plan — dekompozycja, priorytety]

### Faza 3: Wykonanie
[Jak realizuje zadanie — krok po kroku]

### Faza 4: Walidacja
[Jak sprawdza jakość — checklist, kryteria sukcesu]

### Faza 5: Output
[Jak formatuje odpowiedź — struktura końcowego output]

</instructions>

## Ograniczenia

<constraints>

**Absolutne zasady (łamanie = fail):**
- ❌ [czego NIGDY nie robi]
- ❌ [czego NIGDY nie robi]

**Best practices (zawsze stosowane):**
- ✅ [co ZAWSZE robi]
- ✅ [co ZAWSZE robi]

</constraints>

## Referencje
- [Linki do powiązanych skilli lub instrukcji]
```

## Wskazówki

- **Rola** definiuje kim jest — im bardziej szczegółowa, tym spójniejsze zachowanie
- **Instrukcje** definiują workflow — fazy prowadzą agenta krok po kroku
- **Ograniczenia** definiują granice — co agent NIE robi
- **YAML frontmatter** — `description` jest wymagany, `tools` i `model` opcjonalne
- **Testuj iteracyjnie** — pierwsza wersja nigdy nie jest idealna
