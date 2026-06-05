# Java Code Smells and Fixes

## Purpose

Use this guide to identify Java/Spring code that will be expensive to change because responsibilities, dependencies, framework behavior, or data ownership are blurred.

## When to Use

- Reviewing a PR with large services, controller branches, broad repositories, DTO churn, package cycles, or annotation-heavy domain classes.
- Planning refactors for legacy Java code.
- Explaining why a Spring Boot change feels risky even when it compiles.

## Java/Spring-Specific Rules

- God service: split by use case, domain policy, port, mapper, and adapter responsibilities.
- Fat controller: move workflow and domain decisions into application/domain code.
- Anemic domain model: move invariants and state transitions into entities, aggregates, or policies.
- Transaction script abuse: avoid one service method that directly scripts every repository and remote call.
- Repository leakage: keep Spring Data, JPA queries, `Pageable`, and entities out of application/domain ports when architecture requires separation.
- DTO explosion: create request/response models by API purpose, not by copying every entity variation.
- Cyclic package dependencies: break cycles by moving shared contracts inward or splitting feature dependencies.
- Boolean flag arguments: replace with separate methods, commands, or policies when flags change behavior.
- Primitive obsession: wrap domain primitives that carry validation or behavior.
- Excessive inheritance: prefer composition for policies, adapters, and workflows.
- Static utility abuse: replace stateful or policy-based utilities with injectable collaborators.
- Hidden side effects: make events, remote calls, cache writes, and database mutations visible in application services.
- Temporal coupling: do not require callers to call methods in a fragile order; use constructors, factories, or aggregate methods.
- Shotgun surgery: move related behavior into one feature boundary.
- Overuse of annotations: annotations should configure framework integration, not hide domain decisions.

## Bad Practices

- `OrderService` with twenty injected dependencies and methods for every order lifecycle phase.
- `CustomerController` deciding whether a customer can upgrade a plan.
- `UserDto` reused for registration, profile update, admin response, and persistence projection.
- `boolean notifyCustomer` flags changing persistence and messaging behavior.
- `SecurityUtils.currentUser()` static calls deep inside domain code.
- `@Transactional`, `@Async`, `@Cacheable`, and retry annotations stacked on methods without tests for proxy behavior.

## Better Alternatives

- Create use cases per workflow and policies per variable rule.
- Pass authenticated context into application services and keep static security access at the edge.
- Split DTOs by caller contract: `CreateUserRequest`, `UpdateProfileRequest`, `AdminUserResponse`.
- Replace behavior flags with explicit commands: `PlaceOrderCommand`, `PlaceOrderAndNotifyCommand`, or notification policies.
- Move remote calls behind outbound ports and expose failures as application-level results.
- Add architecture tests or package rules when cycles keep returning.

## Review Checklist

- [ ] Does any class combine web, workflow, domain, persistence, and integration concerns?
- [ ] Are entity, DTO, and domain models crossing boundaries without translation?
- [ ] Are package cycles visible between features or layers?
- [ ] Do boolean flags or enum switches hide separate business flows?
- [ ] Are static calls used for time, IDs, security, configuration, or external systems?
- [ ] Are annotations changing runtime behavior without tests?
- [ ] Would a small requirement change force edits in many unrelated files?

## Common Mistakes

- Fixing a smell by introducing a broad abstraction instead of moving the misplaced responsibility.
- Splitting classes by technical method count rather than domain ownership.
- Removing DTOs and returning entities to reduce files.
- Moving duplicated code into a shared package that creates feature coupling.
- Treating annotation count as harmless because the class still has few lines.

## Agent Instructions

When naming a smell, include the maintenance consequence and the narrow correction. Avoid smell labels by themselves. For example: "fat controller" must be followed by which decisions move to which application or domain class.
