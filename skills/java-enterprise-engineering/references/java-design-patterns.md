# Java Design Patterns

## Purpose

Use patterns to remove concrete Java/Spring pain: repeated conditional rules, vendor coupling, constructor overloads, cross-cutting decoration, template workflows, event fan-out, and persistence boundaries.

## When to Use

- A rule varies by tenant, product, country, channel, payment method, or feature flag.
- A vendor SDK leaks into application or domain code.
- Object construction has required fields, optional fields, and invariants.
- Multiple use cases share an algorithm but differ in one step.
- A persistence implementation must be hidden behind a domain/application contract.

## Java/Spring-Specific Rules

- Strategy: use for replaceable rules such as tax calculation, discount eligibility, fraud scoring, or notification routing.
- Factory Method: use when object creation must enforce invariants or choose implementations from request/domain context.
- Adapter: wrap Feign clients, REST templates, WebClient clients, generated SDKs, message brokers, and storage clients behind application-owned ports.
- Decorator: add retries, metrics, tracing, caching, or idempotency around a port without changing domain workflow code.
- Builder: use for test fixtures or complex immutable objects; do not bypass constructor validation.
- Template Method: use sparingly for stable workflow skeletons; prefer composition when Spring injection or testing becomes awkward.
- Observer/Event pattern: publish domain or integration events after state changes; use outbox when database state and event delivery must stay consistent.
- Repository pattern: expose domain verbs and aggregate loading; keep JPA query mechanics in infrastructure.

## Bad Practices

- Adding a strategy for a rule with one implementation and no confirmed variation.
- Naming every class `Factory`, `Manager`, `Handler`, or `Processor` without a domain capability.
- Passing JPA entities to adapters that call external systems.
- Using decorators that swallow exceptions or change transaction semantics.
- Using builders that allow invalid domain objects.
- Using inheritance templates that require subclasses to know transaction or repository details.

## Better Alternatives

- Start with a direct method, then extract `TaxPolicy` or `DiscountPolicy` when real variants appear.
- Keep adapter input/output as application/domain models, not vendor DTOs.
- Make decorators explicit Spring beans around ports: `MeteredPaymentGateway`, `RetryingInvoiceClient`.
- Create fixture builders in test sources; keep production builders strict.
- Publish events from application services after aggregate state changes and before/after commit based on delivery needs.
- Define repository ports around aggregate operations: `loadForUpdate`, `save`, `existsByEmail`, `nextOrderNumber`.

## Review Checklist

- [ ] Does the pattern solve a repeated Java/Spring change pressure?
- [ ] Is the abstraction owned by the application or domain layer?
- [ ] Are vendor classes, generated models, and framework annotations kept in adapters?
- [ ] Does the pattern preserve transaction boundaries and exception behavior?
- [ ] Can tests substitute the port without mocking pure domain behavior?
- [ ] Are class names tied to domain capabilities?
- [ ] Is there a simpler package-private helper that would be enough?

## Common Mistakes

- Applying GoF names before understanding the domain rule.
- Using Spring's bean discovery as a substitute for explicit strategy selection.
- Creating a repository per table instead of per aggregate or query boundary.
- Decorating a Spring Data repository directly and leaking persistence concerns inward.
- Creating observer side effects that run inside a transaction and call remote systems.

## Agent Instructions

Recommend a pattern only when you can identify the variation point, the caller, the owned interface, and the implementation boundary. Include one sentence explaining why a simpler method or package-private class is not enough.
