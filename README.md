# Solid Skills

Professional software engineering skills for AI coding agents. Transforms code into senior-engineer quality software through SOLID principles, TDD, clean code practices, and professional software design.

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

### java-enterprise-engineering

Java/Spring guidance for SOLID, Java readability, design patterns, refactoring, TDD, Spring Boot architecture, DDD, security review, and enterprise code review.

**Use when:**

- Reviewing Java or Spring Boot pull requests
- Designing Spring controllers, use cases, domain models, repositories, ports, and adapters
- Refactoring JPA-heavy services, legacy transaction scripts, or annotation-heavy modules
- Planning tests for domain rules, Spring MVC endpoints, repositories, security, and external clients
- Checking authentication, authorization, validation, secrets, logging, and object-level access

**Core principles:**

| Principle | Focus |
|-----------|-------|
| Java SOLID | Class responsibility, interface width, substitution risk, dependency inversion across application/domain/infrastructure |
| Spring Architecture | Controller thickness, dependency direction, transaction boundaries, DTO/entity separation, framework isolation |
| Testing | Plain Java domain tests, Spring test slices, repository integration tests, external service fakes and mocks |
| Security | Authentication, object-level authorization, input validation, output exposure, secrets, tokens, Spring Security boundaries |
| Refactoring | Characterization tests, small behavior-preserving moves, rollback planning for legacy Java code |

**Reference documentation included:**

- `java-agent-review-workflow.md` - Task routing, evidence rules, severity logic, and pre-output self-review gates for Java/Spring agents
- `java-review-examples.md` - Weak vs acceptable Java/Spring review comments with evidence, risk, correction, and verification
- `java-solid.md` - Java class and Spring boundary review using SOLID
- `java-clean-code.md` - Java naming, nulls, exceptions, immutability, collections, logging, and configuration
- `java-design-patterns.md` - Strategy, Factory Method, Adapter, Decorator, Builder, Template Method, Observer/Event, and Repository patterns
- `java-refactoring.md` - Safe refactoring order for Java/Spring services, entities, repositories, and controllers
- `java-tdd.md` - Java unit tests, Spring Boot test slices, database tests, external service tests, and regression tests
- `spring-boot-clean-architecture.md` - Controller/application/domain/infrastructure separation for Spring Boot
- `spring-boot-hexagonal-architecture.md` - Ports, adapters, use cases, persistence adapters, and external API adapters
- `java-ddd.md` - Entities, value objects, aggregates, repositories, domain services, domain events, and bounded contexts
- `java-security-review.md` - Java/Spring security review for APIs, tokens, logs, secrets, and authorization
- `java-code-smells.md` - Java code smells and targeted fixes for enterprise services
- `java-review-checklist.md` - Strict review checklist grouped by architecture, correctness, testing, security, data, and deployment risk
- `java-agent-output-format.md` - Reusable output formats for reviews, refactoring plans, architecture reviews, test plans, security reviews, PR reviews, and bug investigations

**Key features:**

- Forces Java/Spring reviews to report architecture, SOLID, Spring Boot, testing, security, refactoring, patch, verification, and final decision sections
- Checks package boundaries, dependency direction, layer ownership, domain logic placement, transaction scope, DTO/entity separation, and JPA leakage
- Separates required changes from optional cleanup during enterprise Java code review
- Gives agents concrete stop conditions before broad refactors, security changes, transaction changes, migrations, and public API changes
- Includes `scripts/quality-gate.sh` to validate Java skill links, required sections, local artifacts, vague phrases, and whitespace

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
├── solid/
│   ├── SKILL.md           # Main skill instructions
│   └── references/        # Supporting documentation
│       ├── solid-principles.md
│       ├── tdd.md
│       ├── testing.md
│       ├── clean-code.md
│       ├── code-smells.md
│       ├── design-patterns.md
│       ├── architecture.md
│       ├── object-design.md
│       └── complexity.md
└── java-enterprise-engineering/
    ├── SKILL.md
    └── references/
        ├── java-agent-review-workflow.md
        ├── java-review-examples.md
        ├── java-solid.md
        ├── java-clean-code.md
        ├── java-design-patterns.md
        ├── java-refactoring.md
        ├── java-tdd.md
        ├── spring-boot-clean-architecture.md
        ├── spring-boot-hexagonal-architecture.md
        ├── java-ddd.md
        ├── java-security-review.md
        ├── java-code-smells.md
        ├── java-review-checklist.md
        └── java-agent-output-format.md
```

## License

MIT
