# Java TDD and Test Strategy

## Purpose

Use tests to pin down Java behavior before changing it and to select the right Spring test level for the risk: domain rule, application workflow, web binding, repository query, transaction, security, or external integration.

## When to Use

- Adding or changing domain rules, service workflows, controllers, repositories, security checks, schedulers, or external clients.
- Fixing a bug in Java/Spring code.
- Refactoring code with unclear behavior.
- Reviewing whether a PR has enough evidence for the behavior it changes.

## Java/Spring-Specific Rules

- Unit tests: use plain JUnit for value objects, domain entities, policies, validators, mappers, and application services with ports replaced by fakes or mocks.
- Integration tests: use Spring context only when testing wiring, configuration properties, transactions, JPA, messaging, security filters, or serialization.
- Spring Boot test slices: use `@WebMvcTest` for MVC binding and security behavior, `@DataJpaTest` for repositories, `@JsonTest` for JSON contracts, and full `@SpringBootTest` for cross-component behavior.
- Test doubles: mocks for remote systems and interaction checks; fakes for in-memory repositories or gateways when workflow behavior matters; stubs for fixed clock, UUID, or config values.
- Do not mock value objects, domain methods, Java collections, DTOs, mappers that are pure functions, or the class under test.
- Database tests must cover constraints, custom queries, pagination, locks, cascade behavior, fetch plans, and migrations when those are changed.
- External service tests must cover timeouts, retryable failures, non-retryable failures, auth headers, payload mapping, and idempotency keys.
- Regression tests must fail before the bug fix and pass after the fix.

## Bad Practices

- Using `@SpringBootTest` for every class and hiding slow, brittle tests behind a full context.
- Mocking repositories in a test whose risk is a JPQL query, database constraint, or transaction boundary.
- Verifying only that a mocked method was called while ignoring persisted state or returned behavior.
- Sharing mutable fixture objects across tests.
- Testing private methods instead of public behavior.
- Ignoring security tests for endpoints that load tenant-owned or user-owned resources.

## Better Alternatives

- Test domain invariants with plain JUnit and no Spring annotations.
- Test application services with fake ports for scenario clarity.
- Test controllers with MVC slices for validation, principal extraction, status codes, and error bodies.
- Test repositories with real database behavior, preferably the same engine class used in deployment when query behavior matters.
- Use builders for test data that show domain intent: `anActiveCustomer()`, `anExpiredSubscription()`, `aPaidInvoice()`.
- Add edge cases for null-equivalent inputs, empty collections, duplicate commands, timezone boundaries, large values, and concurrent updates.

## Review Checklist

- [ ] Does each changed domain rule have a plain Java test?
- [ ] Does each workflow branch have an application service test?
- [ ] Are MVC validation, serialization, and security decisions tested at the web boundary?
- [ ] Are repository queries and constraints tested against a database?
- [ ] Are remote failure modes represented by fakes, stubs, mocks, contract tests, or recorded fixtures?
- [ ] Are tests named by scenario and expected outcome?
- [ ] Is the slowest Spring context test justified by wiring or integration risk?

## Common Mistakes

- Treating line coverage as proof that authorization, transaction, or database behavior was checked.
- Mocking `SecurityContextHolder` in many tests instead of passing a principal or policy input.
- Using random IDs and dates that make failures hard to reproduce.
- Letting test fixtures depend on production repositories for setup unless the test is intentionally integration-level.
- Missing negative tests for forbidden object access, duplicate submissions, and invalid state transitions.

## Agent Instructions

When proposing tests, name the test level, the class or endpoint, the scenario, and the assertion. Separate tests required for confidence from optional coverage. If a Spring context is needed, state which framework behavior it verifies.
