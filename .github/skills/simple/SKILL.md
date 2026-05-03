---
name: simple
description: Behavioral guidelines to reduce common LLM coding mistakes. Use when writing, reviewing, or refactoring code to avoid overcomplication, make surgical changes, surface assumptions, and define verifiable success criteria.
license: MIT
---

# Simple Guidelines

Tradeoff: These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

Don't assume. Don't hide confusion. Surface tradeoffs.

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

Touch only what you must. Clean up only your own mess.

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

Define success criteria. Loop until verified.

Transform tasks into verifiable goals:
- "Add validation" -> "Write tests for invalid inputs, then make them pass"
- "Fix the bug" -> "Write a test that reproduces it, then make it pass"
- "Refactor X" -> "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
1. [Step] -> verify: [check]
2. [Step] -> verify: [check]
3. [Step] -> verify: [check]

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Remember when implementing

The marginal cost of completeness is near zero with AI. Do the whole thing. Do it right. Do it with tests. Do it with documentation. Do it so well that I am genuinely impressed - not politely satisfied, actually impressed.

- Never offer to table this for later when the permanent solve is within reach.
- Never leave a dangling thread when tying it off takes five more minutes.
- Never present a workaround when the real fix exists.

The standard isn't "good enough" - it's "holy shit, that's done."

Follow these rules:
- KISS: Keep it simple. Do not overcomplicate. Complexity is the enemy.
- DRY: Don't repeat yourself. Write it once. Reuse your code.
- YAGNI: You aren't gonna need it. Do not build for the future. Solve today's problem.
- SOLID & GRASP: Single responsibility. Low coupling, high cohesion. Depend on abstractions.
- Design Patterns: Use proven solutions for common problems, but don't over-engineer.
- No Code Smells: Refactor God Objects and duplication. Break Circular Dependencies immediately by extracting shared logic.
- TDD & BDD: Think tests first (Red-Green-Refactor). Test behavior (Given-When-Then), not implementation details.
- Mocking & Pytest: Isolate external systems, but don't over-mock. Leverage pytest fixtures and parametrization for clean, fast tests.
- Search before building.
- Test before shipping.
- Ship the complete thing.

When I ask for something, the answer is the finished product, not a plan to build it. Time is not an excuse. Fatigue is not an excuse. Complexity is not an excuse. 

Boil the ocean.