# Java DDD

## Purpose

Use basic Domain-Driven Design to put business rules in Java types that match the domain, while avoiding ceremony when the problem is simple CRUD.

## When to Use

- Business rules involve state transitions, invariants, approvals, eligibility, pricing, ownership, or lifecycle.
- A Spring service has many branches that describe domain decisions.
- JPA entities are anemic data bags and callers mutate them from many places.
- A feature crosses bounded contexts such as billing, identity, fulfillment, and support.

## Java/Spring-Specific Rules

- Entities have identity and behavior; they protect state transitions such as `activate`, `cancel`, `reserve`, `pay`, or `ship`.
- Value objects are immutable and validate concepts such as `EmailAddress`, `Money`, `DateRange`, `Quantity`, `TenantId`, and `OrderNumber`.
- Aggregates enforce invariants and expose methods that keep child collections consistent.
- Repositories load and save aggregates or dedicated read models; they do not expose arbitrary table access to domain code.
- Domain services hold domain rules that do not naturally belong to one entity, such as pricing across multiple aggregates.
- Application services coordinate transactions, repositories, authorization, and external ports; they should not decide domain policy.
- Domain events describe facts after state changes: `OrderPlaced`, `PaymentCaptured`, `SubscriptionCancelled`.
- Bounded contexts keep language separate; `Customer` in billing may not mean the same thing as `Customer` in support.

## Bad Practices

- Anemic domain model: getters/setters only, with all decisions in `OrderService`.
- Aggregates exposing mutable child collections.
- Domain events named as commands, such as `SendEmailEvent`, instead of business facts.
- One repository per table when aggregates require consistency across several tables.
- Sharing one JPA entity model across multiple bounded contexts.
- Using DDD terminology for simple admin CRUD where request-to-table mapping is enough.

## Better Alternatives

- Move state transitions into aggregate methods that check current state.
- Replace primitive domain values with validated value objects when invalid values cause bugs.
- Keep aggregate boundaries small enough to load and save within one transaction.
- Publish domain events from application services after aggregate methods return facts.
- Use anti-corruption adapters between bounded contexts and vendor systems.
- Keep CRUD endpoints direct when there are no invariants beyond simple validation.

## Review Checklist

- [ ] Are invariants enforced in one aggregate or policy rather than scattered across services?
- [ ] Are value objects immutable and validated at creation?
- [ ] Does each aggregate protect child collection consistency?
- [ ] Do repositories align with aggregate boundaries or explicit read models?
- [ ] Are domain services used only for domain rules that need multiple concepts?
- [ ] Are application services coordinating rather than deciding business policy?
- [ ] Is DDD ceremony justified by domain complexity?

## Common Mistakes

- Making every table an aggregate root.
- Letting JPA lazy loading determine aggregate boundaries.
- Putting `@Transactional` logic inside entities.
- Using domain events for technical side effects without naming the business fact.
- Creating value objects without behavior, validation, or semantic difference.

## Agent Instructions

When recommending DDD changes, identify the invariant or language mismatch first. Suggest the smallest domain type that protects it. Also state when a direct Spring CRUD design is sufficient so the code does not gain unnecessary layers.
