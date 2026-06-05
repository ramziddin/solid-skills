# Java Review Checklist

## Purpose

Use this checklist to review Java/Spring changes with enough detail to support an approve, request-changes, or block decision.

## When to Use

- Reviewing a pull request that changes Java, Spring Boot, database, security, or test behavior.
- Preparing a refactoring plan.
- Auditing a service before adding a feature.
- Checking whether Java package moves, Spring bean wiring, JPA mapping changes, migrations, or security rules are safe to merge.

## Java/Spring-Specific Rules

- Every finding must identify file, class, method, Java/Spring mechanism, behavior, risk, and required correction.
- Separate required changes from optional cleanup.
- Treat missing tests as a finding only when a behavior, boundary, or regression risk is not covered.
- Treat architecture findings as concrete dependency or ownership problems, not style preference.
- Use `BLOCK` only for security, data loss, migration, compilation, test failure, or severe architecture risk that makes the patch unsafe.

## Bad Practices

- "Looks fine" without checking controller, service, repository, tests, and security paths.
- Reviewing only changed lines when the change depends on package conventions or runtime Spring behavior.
- Asking for broad rewrites unrelated to the PR goal.
- Mixing naming preferences with correctness and security issues.
- Approving a controller change that loads resources by ID without object-level permission tests.

## Better Alternatives

- Trace one changed request from controller through use case, transaction, repository, mapper, and response.
- Trace one failing or edge scenario through exception mapping and tests.
- Compare changed package dependencies against the repository's existing architecture.
- Use focused comments: "Move this JPA entity out of the response DTO because lazy `roles` can serialize internal privileges."
- Recommend a verification command or test class for each required behavior.

## Review Checklist

Architecture:

- [ ] Packages and modules preserve feature/layer ownership such as `orders.application`, `orders.domain`, and `orders.adapter.out.persistence`.
- [ ] Dependencies point inward; domain/application do not import Spring MVC, Spring Data, JPA, Feign/WebClient, messaging, or vendor SDK types.
- [ ] Controllers, use cases, domain objects, Spring Data repositories, persistence mappers, and outbound adapters have distinct responsibilities.
- [ ] No new package cycles are introduced between feature packages, `controller`, `service`, `domain`, `repository`, and adapter packages.
- [ ] `@Transactional` boundaries match one use case and avoid remote calls inside long database transactions.

Correctness:

- [ ] Aggregate/entity state transitions preserve invariants through methods rather than public setters or scattered service branches.
- [ ] Null, empty, duplicate, invalid, and boundary inputs are represented through Bean Validation, domain validation, `Optional`, or domain exceptions consistently.
- [ ] Exception types map through `@ControllerAdvice`, message listeners, schedulers, or caller contracts to the expected response or retry behavior.
- [ ] Idempotency and retry behavior are reviewed for commands, domain events, integration events, and webhooks.
- [ ] Timezone, currency, precision, and rounding behavior use explicit Java types such as `Clock`, `ZoneId`, and `BigDecimal` when relevant.

Maintainability:

- [ ] Names use domain language and avoid vague Spring service nouns such as `Manager`, `Processor`, and `Handler` when a use case or policy name is available.
- [ ] Classes do not combine unrelated Spring roles such as MVC controller, transaction script, repository adapter, mapper, and security policy.
- [ ] DTOs, JPA entities, commands, projections, and domain types are not conflated.
- [ ] Shared Java packages do not create cross-feature coupling or force unrelated modules to depend on persistence/web types.
- [ ] Annotations such as `@Transactional`, `@Async`, `@Cacheable`, `@EventListener`, and `@PreAuthorize` do not hide runtime behavior without tests.

Testing:

- [ ] Domain rules have plain Java tests.
- [ ] Application workflows have tests for branches and port failures.
- [ ] MVC binding, validation, security, and error mapping have slice or integration tests.
- [ ] Repository queries, constraints, and migrations have database-backed tests.
- [ ] External clients cover timeout, auth, mapping, retry, and error scenarios.

Security:

- [ ] Endpoints are authenticated or explicitly public.
- [ ] Object ownership, tenant, role, and permission checks are enforced.
- [ ] Request DTOs cannot set server-owned fields.
- [ ] Responses do not expose secrets or unauthorized fields.
- [ ] Logs, metrics, and exceptions redact sensitive data.

Performance:

- [ ] Pagination and limits are applied to unbounded reads.
- [ ] JPA fetch plans avoid obvious N+1 paths.
- [ ] Transactions are short and avoid blocking remote calls.
- [ ] Caches have safe keys, lifetimes, invalidation, and tenant separation.
- [ ] Async work has bounded executors and failure handling.

Data/Database:

- [ ] Migrations are backward-compatible with the deployed rollout plan.
- [ ] Constraints enforce business-critical uniqueness and relationships.
- [ ] Locking or optimistic versioning covers concurrent updates.
- [ ] Entity cascades and orphan removal are intentional.
- [ ] Query changes are reviewed for indexes and result cardinality.

Deployment Risk:

- [ ] Configuration values are bound through typed `@ConfigurationProperties` or equivalent validated configuration.
- [ ] Feature flags have explicit defaults per Spring profile or deployment environment.
- [ ] Startup behavior, bean creation, component scanning, entity scanning, and profile-specific config are checked.
- [ ] External dependency changes include timeout, retry, circuit breaker, auth header, and failure mapping behavior.
- [ ] Observability covers new critical paths with safe logs, metrics tags, trace IDs, and no sensitive payloads.

## Common Mistakes

- Missing forbidden cross-tenant tests.
- Ignoring migration order for non-null columns or enum changes.
- Adding a repository method without checking index support.
- Approving `@Async` or scheduler changes without bounded executor and duplicate-run behavior.
- Treating generated mapper output as safe without checking field exposure.

## Agent Instructions

Use this checklist as evidence collection, not as a dump into the final answer. Report only items that apply to the changed Java/Spring behavior. Keep the final decision consistent with the highest-risk unresolved issue.
