# Solid Skills

Professional software engineering skills for AI coding agents. Transforms code into senior-engineer quality software through SOLID principles, TDD, clean code practices, and professional software design patterns.

Skills follow the [Agent Skills](https://github.com/anthropics/skills) format.

## Available Skills

### solid

Transform junior-level code into senior-engineer quality software. Primarily designed for **TypeScript** and **NestJS** projects, but applicable to any object-oriented codebase.

**Use when:**

- Writing any code (features, fixes, utilities)
- Refactoring existing code
- Planning or designing architecture
- Reviewing code quality
- Debugging issues
- Creating tests
- Making design decisions

**Core principles:**

| Principle | Focus |
|-----------|-------|
| TDD | Red-Green-Refactor cycle, tests before code |
| SOLID | Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion |
| Clean Code | Meaningful names, small functions, no comments needed |
| Design Patterns | Creational, Structural, Behavioral patterns |
| Architecture | Vertical slicing, dependency rule, clean architecture |

---

## SOLID Principles

### S — Single Responsibility Principle (SRP)

> "A class should have one, and only one, reason to change."

A class should focus on a **single responsibility**. If you find yourself describing what a class does using the word "and", it's a sign it should be split into separate classes.

This keeps classes small, focused, and easy to test. Changes to one area of the system (e.g. persistence) won't accidentally affect another (e.g. business logic).

**Red flag:** "This class handles X *and* Y *and* Z."

---

### O — Open/Closed Principle (OCP)

> "Software entities should be open for extension but closed for modification."

Once a class or module is working and tested, you should be able to **add new behavior by adding new code** — not by editing the existing code. This is typically achieved through abstractions (interfaces or base classes) that new implementations can extend.

This prevents regression bugs caused by modifying working code every time requirements change.

**Red flag:** Long `if/else` or `switch` chains that grow whenever a new type is added.

---

### L — Liskov Substitution Principle (LSP)

> "Subtypes must be substitutable for their base types without altering program correctness."

Any subclass or implementation should be **fully interchangeable** with its parent or interface. If calling code needs special-case handling for a specific subtype, the substitution principle is violated.

This is what makes it safe to swap, for example, an `InMemoryUserRepository` for a `PostgresUserRepository` — both honor the same `UserRepository` contract.

**Red flag:** Type-checking in calling code (`instanceof`, `typeof`) to handle specific subtypes differently.

---

### I — Interface Segregation Principle (ISP)

> "Clients should not be forced to depend on methods they do not use."

Large, "fat" interfaces should be split into **smaller, focused interfaces**. A class should only need to implement the methods that are actually relevant to it — not be forced to stub out or throw on methods it doesn't support.

**Red flag:** `throw new Error("Not implemented")` or empty method bodies in a class that implements an interface.

---

### D — Dependency Inversion Principle (DIP)

> "High-level modules should not depend on low-level modules. Both should depend on abstractions."

Business logic (high-level) should **not be coupled to infrastructure details** (low-level) like databases, email providers, or HTTP clients. Instead, both sides should depend on an interface (abstraction). The concrete implementation is injected at runtime.

This makes code easy to test (inject a mock), easy to swap providers, and keeps domain logic free of framework concerns.

```
Infrastructure → Application → Domain
      ↑              ↑            ↑
    (outer)       (middle)     (inner)

Dependencies flow: outer → inner. Never: inner → outer.
```

**Red flag:** `new ConcreteClass()` instantiated directly inside business logic.

---

### Quick Reference

| Principle | One-Liner | Red Flag |
|-----------|-----------|----------|
| SRP | One reason to change | "This class handles X and Y and Z" |
| OCP | Add, don't modify | `if/else` chains for types |
| LSP | Subtypes are substitutable | Type-checking in calling code |
| ISP | Small, focused interfaces | Empty method implementations |
| DIP | Depend on abstractions | `new ConcreteClass()` in business logic |

---

**Reference documentation included:**

- `solid-principles.md` - SOLID principles with TypeScript examples
- `tdd.md` - Test-Driven Development practices
- `testing.md` - Testing strategies and patterns
- `clean-code.md` - Clean code guidelines
- `code-smells.md` - Code smell detection and fixes
- `design-patterns.md` - GoF patterns with examples
- `architecture.md` - Clean architecture principles
- `object-design.md` - Object stereotypes and responsibilities
- `complexity.md` - Managing essential vs accidental complexity

**Key features:**

- Enforces TDD workflow (write failing test first)
- Detects and fixes code smells automatically
- Applies SOLID principles to every class and function
- Uses value objects for domain primitives (IDs, emails, money)
- Follows Law of Demeter and Tell Don't Ask
- Keeps methods under 10 lines, classes under 50 lines

## Installation

```bash
npx skills add ramziddin/solid-skills
```

## Usage

Skills are automatically available once installed. The agent will use them when relevant tasks are detected.

**Examples:**

- "Implement a user registration feature"
- "Refactor this service to follow SOLID principles"
- "Review this code for quality issues"
- "Add tests for this module"
- "Design the architecture for a payment system"

## Skill Structure

```
skills/
└── solid/
    ├── SKILL.md           # Main skill instructions
    └── references/        # Supporting documentation
        ├── solid-principles.md
        ├── tdd.md
        ├── testing.md
        ├── clean-code.md
        ├── code-smells.md
        ├── design-patterns.md
        ├── architecture.md
        ├── object-design.md
        └── complexity.md
```

## License

MIT
