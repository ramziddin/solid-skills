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

## Design Patterns

Design patterns are **reusable solutions to common software design problems** — a shared vocabulary for discussing and structuring code. They are grouped into three categories based on their purpose.

> ⚠️ Let patterns emerge from refactoring. Don't force them upfront. A pattern should solve a problem you *have*, not one you *might* have.

---

### Creational Patterns

These patterns deal with **how objects are created**, decoupling creation logic from the code that uses the objects.

| Pattern | Purpose | When to Use |
|---------|---------|-------------|
| **Singleton** | Ensure only one instance exists | Global config, connection pools, logging. *Often overused — prefer dependency injection.* |
| **Factory** | Create objects without specifying the exact class | Creation logic is complex or varies by type |
| **Builder** | Construct complex objects step by step | Objects with many optional parameters; test data creation |
| **Prototype** | Create new objects by cloning existing ones | Object creation is expensive, or you need variations of an existing object |

---

### Structural Patterns

These patterns deal with **how objects and classes are composed** to form larger structures, while keeping them flexible and efficient.

| Pattern | Purpose | When to Use |
|---------|---------|-------------|
| **Adapter** | Make incompatible interfaces work together | Integrating third-party libraries or legacy code |
| **Decorator** | Add behavior to objects dynamically | Adding features without modifying existing code |
| **Proxy** | Control access to an object | Lazy loading, access control, caching, logging |
| **Composite** | Treat individual objects and compositions uniformly | Tree structures and hierarchies (e.g. files/folders, UI components) |

---

### Behavioral Patterns

These patterns deal with **how objects communicate and share responsibilities**.

| Pattern | Purpose | When to Use |
|---------|---------|-------------|
| **Strategy** | Define a family of interchangeable algorithms | Multiple ways to do something, switchable at runtime (e.g. pricing, sorting) |
| **Observer** | Notify multiple objects about state changes | Event systems, pub/sub, reactive updates |
| **Template Method** | Define an algorithm skeleton; let subclasses fill in steps | A common workflow with varying details (e.g. exporters, parsers) |
| **Command** | Encapsulate a request as an object | Undo/redo, action queuing, logging operations |

---

### Anti-Patterns to Avoid

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **God Object** | One class does everything | Split by responsibility (SRP) |
| **Spaghetti Code** | Tangled logic, no structure | Refactor into layers or modules |
| **Golden Hammer** | Applying one pattern to every problem | Match the pattern to the actual problem |
| **Premature Optimization** | Optimizing before it's needed | YAGNI — profile first |
| **Copy-Paste Programming** | Duplication everywhere | Extract shared logic; follow the Rule of Three |

---

## Architecture

Good architecture enables the team to **add, change, remove, test, and deploy features** with minimal friction. It's not about perfection upfront — it's about keeping options open and the codebase easy to reason about.

---

### Key Architectural Principles

#### 1. Organize by Feature (Vertical Slices)

Group code by **feature or domain**, not by technical role. Changes to a feature stay localized within that feature's folder.

```
❌ Layer-first (hard to navigate as the system grows)
src/
  controllers/   UserController, OrderController
  services/      UserService, OrderService
  repositories/  UserRepository, OrderRepository

✅ Feature-first (cohesive, easy to find things)
src/
  users/         UserController, UserService, UserRepository
  orders/        OrderController, OrderService, OrderRepository
```

#### 2. Separate Concerns into Layers (Horizontal Boundaries)

Within each feature, separate code by its role:

```
┌────────────────────────┐
│      Presentation      │  Controllers, HTTP handlers, CLI
├────────────────────────┤
│      Application       │  Use cases, orchestration
├────────────────────────┤
│        Domain          │  Business rules, entities, value objects
├────────────────────────┤
│     Infrastructure     │  Database, APIs, email, file system
└────────────────────────┘
```

#### 3. The Dependency Rule

**Dependencies always point inward.** The domain layer knows nothing about the database or HTTP. Infrastructure depends on domain interfaces — never the other way around.

```
Infrastructure → Application → Domain
     (outer)        (middle)    (inner)
```

This is enforced by defining interfaces in the domain and implementing them in infrastructure.

#### 4. Contracts Between Components

Interfaces define the boundary between layers. This enables swapping implementations (e.g. `StripeGateway` → `PayPalGateway`) and makes testing trivial (inject a `MockGateway`).

#### 5. Cross-Cutting Concerns

Things like logging, authentication, and error handling span multiple features. Handle them via **middleware, interceptors, or decorators** rather than scattering the logic throughout your feature code.

#### 6. Conway's Law

> "Organizations design systems that mirror their communication structure."

Team boundaries tend to become module boundaries. Design your team structure and architecture together, intentionally.

---

### Common Architectural Styles

#### Layered Architecture
The classic approach: Presentation → Business Logic → Persistence. Simple and well-understood, but requires discipline to avoid it becoming a "big ball of mud".

#### Hexagonal Architecture (Ports & Adapters)
The domain sits at the center. **Ports** are interfaces defined by the domain. **Adapters** are external implementations (HTTP, database, email) that plug into those ports. The domain has zero knowledge of adapters.

#### Clean Architecture
Similar to Hexagonal, with four explicit rings:
1. **Entities** — Core enterprise business rules
2. **Use Cases** — Application-specific business rules
3. **Interface Adapters** — Controllers, presenters, gateways
4. **Frameworks & Drivers** — Web frameworks, databases, external tools

---

### Red Flags in Architecture

- Circular dependencies between modules
- Domain code importing from infrastructure
- Framework-specific code inside business logic
- No clear boundaries between features
- Shared mutable state across modules
- "Util" or "Common" packages that grow without limit
- Database schema driving the domain model

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
