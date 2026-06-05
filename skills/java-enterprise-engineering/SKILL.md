---
name: java-enterprise-engineering
description: Use this skill when reviewing, designing, refactoring, testing, or securing Java and Spring Boot systems. It focuses on enterprise Java boundaries, Spring architecture, domain modeling, test strategy, security review, and agent output discipline.
---

# Java Enterprise Engineering Skills

## Purpose

Use this skill to produce Java and Spring Boot work that a strict enterprise maintainer can review. The agent must reason about package ownership, dependency direction, Spring framework boundaries, persistence leakage, transaction scope, security checks, test evidence, and migration risk before proposing or changing code.

## When to Use This Skill

- Reviewing Java, Kotlin-on-JVM, or Spring Boot pull requests.
- Designing controllers, application services, domain models, repositories, adapters, or integrations.
- Refactoring Java services, JPA-heavy modules, legacy transaction scripts, or annotation-heavy classes.
- Planning tests for domain rules, Spring MVC endpoints, repositories, messaging, schedulers, or external clients.
- Checking authentication, authorization, validation, secrets, logging, token, or object-level access behavior.

## When Not to Use This Skill

- The task is unrelated to JVM or Spring systems.
- The requested output is only syntax help for a small isolated snippet.
- The repository has explicit architecture rules that conflict with this skill; in that case, follow repository rules and call out the conflict.
- The user asks for broad software advice without Java/Spring code, packages, dependencies, or architecture to inspect.

## Required Agent Behavior

1. Start with [Java Agent Review Workflow](references/java-agent-review-workflow.md). Select the task route, evidence requirements, severity rules, and output format before reading deeper references.
2. Inspect the repository first: packages, modules, Gradle/Maven files, Spring configuration, test layout, database migrations, security configuration, and existing naming.
3. Identify the intended architecture before judging code: layered, clean, hexagonal, modular monolith, legacy MVC, or mixed.
4. Trace dependencies from controllers inward and infrastructure outward. Flag domain classes that import Spring, JPA, web, cloud, messaging, SDK, or persistence classes.
5. Separate HTTP concerns, application workflow, domain rules, persistence mapping, and external system adapters.
6. Treat tests as design evidence. Check whether tests cover domain rules, workflow branching, transaction behavior, repository queries, validation, authorization, and serialization.
7. Prefer small patches that preserve behavior. For risky refactors, ask for characterization tests before moving logic.
8. Use [Java Review Examples](references/java-review-examples.md) when a draft finding sounds vague, reusable for non-Java code, or missing evidence.
9. Do not invent framework conventions. Follow the repository's Spring Boot, package, mapper, exception, transaction, and test patterns unless they are the finding.
10. When uncertain, mark the item as an assumption and explain what file or runtime evidence would confirm it.

## Java Engineering Checklist

- Package boundaries: features or layers have clear ownership; `user`, `order`, and `billing` concepts do not reach into each other's internals without an application-level contract.
- Dependency direction: domain code does not depend on `org.springframework`, `jakarta.persistence`, web DTOs, Feign clients, generated SDKs, or database record classes.
- Layer ownership: controllers map HTTP, application services coordinate use cases, domain objects enforce invariants, infrastructure talks to databases and remote systems.
- Service responsibility: a service class does not combine validation, authorization, persistence, messaging, mapping, and business rules in one method.
- Domain logic placement: pricing, eligibility, state transitions, and policy decisions live in domain objects or domain services, not controllers, repositories, mappers, or JPA callbacks.
- DTO/entity separation: request and response models do not expose mutable JPA entities, lazy associations, internal IDs, audit columns, or security-sensitive fields.
- Null handling: public APIs make absence explicit with validation, `Optional` return types for maybe-present results, or domain-specific exceptions; fields are not left nullable without invariant checks.
- Optional usage: `Optional` is not used for entity fields, request fields, parameters, or serialization models; it is acceptable for repository or query return values.
- Collection handling: return immutable views or defensive copies from domain objects; do not expose mutable `List` fields from aggregates.
- Logging quality: logs include correlation keys and business identifiers that are safe to disclose; they do not print tokens, passwords, full payloads, stack traces for expected validation failures, or personal data.
- Configuration safety: timeouts, base URLs, feature flags, credentials, limits, and pool sizes come from typed configuration with validation.
- Mutable shared state: singleton Spring beans do not store per-request state, security context snapshots, mutable accumulators, or non-thread-safe formatters.

## Spring Boot Architecture Checklist

- Controller thickness: controller methods parse request data, invoke validation/security handoff, call one use case, and map responses; they do not open transactions or branch on domain workflows.
- Request/response design: API models match client contracts and do not mirror database tables unless the endpoint is intentionally administrative.
- Validation location: syntactic validation uses Bean Validation on request models; cross-field and business validation runs in application/domain code where repositories and policies are available.
- Exception strategy: domain exceptions map to stable API errors in `@ControllerAdvice`; stack traces and internal class names are not returned to clients.
- Transaction boundaries: transactions wrap application use cases, not controllers, entity constructors, or remote calls; external API calls are outside database transactions unless there is a deliberate outbox/saga.
- Repository abstraction: application/domain code depends on repository ports or narrow query interfaces, not broad Spring Data repositories when using clean or hexagonal architecture.
- JPA leakage: lazy collections, entity proxies, `EntityManager`, and persistence annotations do not escape into API models or domain-only modules.
- Framework leakage: annotations such as `@Service`, `@Transactional`, `@Entity`, `@JsonProperty`, and `@Autowired` stay out of pure domain classes.
- Cyclic dependencies: package cycles between `controller`, `service`, `domain`, `repository`, and feature packages must be removed before adding more behavior.
- Database coupling: SQL shape, fetch plans, cascade rules, and migration order are reviewed when service behavior changes.

## Testing Checklist

- Domain tests cover invariants, state transitions, value object validation, money/date calculations, and edge cases without Spring context startup.
- Application service tests cover workflow branching, authorization handoff, transaction-facing decisions, idempotency, retries, and collaboration with ports.
- Spring MVC tests cover request binding, validation, authentication principal extraction, error mapping, serialization names, and status codes.
- Repository integration tests cover custom queries, constraints, locking, fetch joins, database-specific types, migrations, and transaction rollback behavior.
- External service tests use fakes or contract tests for HTTP clients, messaging, mail, payment, storage, and identity providers.
- Test coverage: changed Java/Spring behavior is covered at the matching level; line coverage alone is not enough for authorization, transaction, serialization, query, or migration changes.
- Test quality: assertions verify returned values, persisted state, emitted events, security decisions, and exception mappings instead of only verifying mock calls.
- Integration test need: require Spring or database-backed tests when the change depends on framework wiring, validation annotations, security filters, transaction proxies, JPA queries, migrations, or serialization.
- Mocking quality: mock remote systems, clocks, UUID generators, mail senders, queues, payment clients, and repositories at application boundaries; do not mock value objects, pure domain methods, or collections.
- Test data uses builders or fixtures that expose business intent; avoid copying full entity graphs into every test.
- Regression tests are added before fixing a reported Java/Spring bug.

## Security Checklist

- Authentication checks: endpoints declare the required authentication mechanism and reject anonymous access unless explicitly public.
- Authorization checks: object-level access is enforced in application services or security policies using the target resource owner, tenant, role, or permission.
- Input validation: validate request size, enum values, IDs, date ranges, uploaded files, sort fields, filters, and nested objects before reaching repositories.
- Output exposure: responses do not include password hashes, reset tokens, internal roles, tenant boundaries, secret-backed config, or fields hidden by business policy.
- Secrets handling: credentials are read from secret stores or environment-backed config, never literals, test fixtures committed with live values, logs, or exception messages.
- Token handling: JWT/session validation checks issuer, audience, expiry, signature, algorithm, tenant, and revocation requirements that apply to the system.
- Spring Security boundaries: security expressions, filters, method security, and CORS/CSRF settings match the endpoint type and deployment model.
- Concurrency risks: review singleton beans, caches, schedulers, async methods, optimistic locking, idempotency keys, and repeated message delivery.

## Refactoring Checklist

- Add characterization tests around current behavior before moving legacy code.
- Move one responsibility at a time: HTTP mapping, validation, workflow, domain rule, persistence mapping, external adapter.
- Preserve public API contracts, database schema, event payloads, and error codes unless the task explicitly changes them.
- Replace conditionals with strategy, policy objects, enum behavior, or map dispatch only when rules vary independently.
- Reduce coupling by introducing ports owned by the application layer before moving infrastructure implementations.
- Keep rollback simple: small commits, no broad renames mixed with behavior changes, and no migration plus refactor in the same patch unless required.

## Code Review Checklist

- Architecture findings include package, layer, dependency, transaction, and framework-boundary evidence.
- SOLID findings name the class responsibility, extension point, substitution risk, interface width, or dependency inversion violation.
- Spring Boot findings mention the exact Spring mechanism involved: MVC binding, validation, transaction proxying, JPA fetching, configuration binding, security filter, or bean lifecycle.
- Testing gaps identify the missing test level and the behavior that can fail.
- Security risks identify asset, actor, missing check, reachable endpoint or method, and impact.
- Migration risk identifies schema compatibility, data backfill, enum changes, non-null columns, index creation, rollback behavior, and deployment order.
- Performance risk includes query count, JPA fetch shape, pagination, transaction duration, blocking calls, cache lifetime, executor bounds, and concurrency mechanism.
- Maintainability risk identifies change amplification across packages, duplicated Spring workflow code, vague service ownership, shared DTO/entity coupling, and annotation-driven behavior that lacks tests.
- Required changes are separated from optional cleanup.

## Required Output Format

Use this format for Java/Spring reviews:

```text
Summary:
Risk level:
Architecture findings:
SOLID/Clean Code findings:
Spring Boot findings:
Testing gaps:
Security risks:
Refactoring plan:
Required changes:
Suggested patch:
Verification steps:
Final decision:
```

Final decision must be one of:

- APPROVE
- APPROVE WITH MINOR CHANGES
- REQUEST CHANGES
- BLOCK

## Examples

Weak generic response:

> This service should use better design and more tests.

Stronger Java/Spring-specific response:

> `OrderService.placeOrder` mixes HTTP DTO mapping, stock checks, payment calls, JPA writes, and email dispatch inside one `@Transactional` method. Move request mapping to `OrderController`, keep the transaction around order creation and inventory reservation, call payment through an outbound port after the domain command is validated, and publish email through an outbox event. Add domain tests for reservation rules, an application service test for payment failure, and a repository integration test for the unique order number constraint.

Why the stronger response is better:

It names the Spring transaction risk, the misplaced responsibilities, the Java/Spring components that should own each behavior, and the exact tests that would catch regressions.

## Stop Conditions

- Stop and request clarification if the target architecture cannot be inferred and the change would move packages or public contracts.
- Stop before broad refactors when characterization tests are missing for legacy behavior.
- Stop before changing security behavior without knowing required roles, tenants, object ownership rules, or public endpoint contracts.
- Stop before changing transactions, JPA mappings, migrations, event schemas, or external API contracts without a verification plan.
- Stop if the requested patch would hide a security issue, remove meaningful tests, or bypass repository conventions.

## References

- [Java Agent Review Workflow](references/java-agent-review-workflow.md)
- [Java Review Examples](references/java-review-examples.md)
- [Java SOLID](references/java-solid.md)
- [Java Clean Code](references/java-clean-code.md)
- [Java Design Patterns](references/java-design-patterns.md)
- [Java Refactoring](references/java-refactoring.md)
- [Java TDD](references/java-tdd.md)
- [Spring Boot Clean Architecture](references/spring-boot-clean-architecture.md)
- [Spring Boot Hexagonal Architecture](references/spring-boot-hexagonal-architecture.md)
- [Java DDD](references/java-ddd.md)
- [Java Security Review](references/java-security-review.md)
- [Java Code Smells](references/java-code-smells.md)
- [Java Review Checklist](references/java-review-checklist.md)
- [Java Agent Output Format](references/java-agent-output-format.md)
