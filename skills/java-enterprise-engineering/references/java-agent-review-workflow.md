# Java Agent Review Workflow

## Purpose

Use this workflow before producing Java/Spring review output. It tells the agent which reference files to read, what evidence is required for each claim, how to choose severity, and when to reject its own draft before showing it to the user.

## When to Use

- A user asks for a Java/Spring pull request review, architecture review, refactoring plan, test plan, security review, or bug investigation.
- A task touches controllers, application services, domain objects, repositories, JPA mappings, migrations, Spring Security, external clients, or tests.
- The agent needs to choose between the Java reference files instead of reading every file blindly.

## Java/Spring-Specific Rules

- Start with this workflow, then read only the references required by the task route below.
- Every finding must include evidence: file/class/method, Spring mechanism if relevant, Java mechanism if relevant, behavior, risk, and required correction.
- A Spring mechanism can be MVC binding, Bean Validation, `@Transactional`, JPA fetch behavior, Spring Data query derivation, `@ControllerAdvice`, Security filter chain, method security, configuration binding, event listener, scheduler, cache, or async executor.
- A Java mechanism can be nullability, `Optional`, generics, checked exceptions, immutable collection handling, `BigDecimal`, `Clock`, records, sealed types, synchronization, executor behavior, or value object construction.
- Do not output a severity until you can tie it to user impact: security exposure, data loss, broken behavior, deployment failure, test gap, migration risk, or review-only cleanup.

## Task Routing

Use these routes before writing the final answer:

| Task type | Read first | Then read when relevant | Output format |
|-----------|------------|-------------------------|---------------|
| Pull request review | `java-review-checklist.md` | Architecture, testing, security, smells, output format | Pull Request Review |
| Java code review | `java-review-checklist.md` | SOLID, Java readability, smells, testing, security | Java Code Review |
| Refactoring plan | `java-refactoring.md` | SOLID, smells, architecture, testing | Java Refactoring Plan |
| Spring architecture review | `spring-boot-clean-architecture.md` | Hexagonal, DDD, security, testing | Spring Boot Architecture Review |
| Test plan | `java-tdd.md` | Architecture, security, repository/data checklist | Test Plan |
| Security review | `java-security-review.md` | Architecture, testing, output format | Security Review |
| Bug investigation | `java-agent-output-format.md` | Testing, security, architecture, refactoring as needed | Bug Investigation |

## Evidence Rules

- Architecture finding: name the package or class that owns the behavior today, the Spring/JPA/framework type crossing the wrong boundary, and the target owner.
- Testing finding: name the missing test level, the behavior that can fail, and why a plain unit test, Spring slice, repository integration test, or full integration test is required.
- Security finding: name the actor, asset, entry point, missing authentication/authorization/validation check, and impact.
- JPA/performance finding: name the query path, fetch plan, pagination/limit behavior, transaction scope, or expected N+1/cardinality risk.
- Refactoring finding: name the behavior to preserve, the characterization test needed first, the smallest move, and rollback concern.
- Output claim: do not say a patch is safe unless transaction behavior, security behavior, migration impact, public API shape, and tests were checked or explicitly marked out of scope.

## Severity Rules

- `APPROVE`: no required Java/Spring changes remain; tests or checks cover the changed behavior; only optional cleanup remains.
- `APPROVE WITH MINOR CHANGES`: small naming, message, fixture, or localized test additions remain; no security, data, transaction, migration, or public API risk is unresolved.
- `REQUEST CHANGES`: unresolved behavior, architecture, testing, authorization, transaction, query, DTO/entity leakage, or maintainability risk can reasonably cause a defect or expensive future change.
- `BLOCK`: unresolved issue can expose data, bypass authorization, corrupt data, break deployment, fail compilation, invalidate a migration, remove critical tests, or make rollback unsafe.

## Pre-Output Self-Review Gate

Reject and rewrite the draft if any item is true:

- A finding does not name a Java/Spring file, class, method, endpoint, package, query, annotation, or configuration path.
- A test request does not state the behavior and test level.
- A security claim lacks actor, asset, entry point, missing check, and impact.
- A patch suggestion says to introduce an interface without naming the application-owned port and infrastructure implementation boundary.
- A refactoring suggestion moves logic without preserving behavior through characterization tests or existing test evidence.
- A performance claim does not name JPA fetch shape, query cardinality, pagination, transaction duration, cache behavior, or executor/concurrency mechanism.
- Required changes and optional cleanup are mixed together.
- The final decision is weaker than the highest unresolved risk.

## Bad Practices

- Reading every reference file and returning a long report that ignores the user's task.
- Reporting "controller is too large" without naming the HTTP responsibility that should stay and the workflow/domain behavior that should move.
- Asking for tests without specifying domain unit, application service, MVC slice, repository integration, security, or external client coverage.
- Calling a security issue high risk without proving the reachable endpoint, actor, missing check, and exposed asset.
- Suggesting a port or adapter because the architecture vocabulary sounds right, not because Spring Data, Feign/WebClient, JPA, messaging, or SDK code crosses inward.

## Better Alternatives

- Route the task first, then read only the files needed to produce a focused answer.
- Use one sentence per finding to state evidence, risk, and correction before adding explanation.
- For architecture reviews, trace one request from controller to use case to domain to repository/adapter and back to response mapping.
- For test plans, map each changed behavior to exactly one primary test level and add integration tests only when Spring/JPA/security/runtime behavior is the risk.
- For security reviews, start from the endpoint or message listener and follow principal, tenant, object ownership, request fields, and response fields.

## Review Checklist

- [ ] Did the agent choose the route before reading deeper references?
- [ ] Does each finding include file/class/method or endpoint evidence?
- [ ] Are Spring and Java mechanisms named when they create the risk?
- [ ] Are required changes separated from optional cleanup?
- [ ] Does the final decision match the highest unresolved risk?
- [ ] Does the answer include verification steps tied to the changed behavior?

## Common Mistakes

- Treating missing line coverage as the issue instead of naming the untested behavior.
- Treating every dependency as a dependency-inversion violation without checking the repository's intended architecture.
- Marking a finding as minor when it involves object-level authorization, migration safety, or transaction boundaries.
- Suggesting large package moves before proving current behavior with tests.
- Letting example-heavy output replace a concrete patch or review decision.

## Agent Instructions

Before final output, write a private checklist using the evidence rules and severity rules. If any required evidence is missing, downgrade the claim to an assumption or remove it. Use the format from `java-agent-output-format.md` only after this workflow has selected the task route and severity.

## Compact Examples

Architecture:

- Weak: "Separate the controller from business logic."
- Acceptable: "`InvoiceController.approve` branches on invoice status and calls `invoiceRepository.save` directly. Keep HTTP binding in the controller, move approval workflow into `ApproveInvoiceUseCase`, and keep JPA persistence behind an application-owned repository port because this path currently mixes MVC, transaction, and domain ownership."

Testing:

- Weak: "This needs more tests."
- Acceptable: "`SubscriptionService.renew` changes retry behavior when the payment gateway declines. Add an application service test with a fake `ChargePaymentPort` for decline and retry branches, plus a repository integration test if renewal writes a new invoice row or updates optimistic version fields."

Security:

- Weak: "Secure this endpoint."
- Acceptable: "`GET /accounts/{id}` loads by request ID and returns the account response without checking principal tenant or owner. Add an application-level object permission check or constrain the repository query by tenant because an authenticated user can otherwise request another account ID."

JPA/performance:

- Weak: "Optimize this query."
- Acceptable: "`OrderController.list` serializes `OrderEntity.lines` after loading a page of orders, which can trigger N+1 lazy loads and expose persistence shape. Use a bounded projection or fetch plan for the response model, keep pagination mandatory, and add a repository integration test that exercises line loading."
