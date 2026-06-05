# Java Review Examples

## Purpose

Use these examples to rewrite weak Java/Spring findings into review comments that a maintainer can act on. Each acceptable example names evidence, the Java or Spring mechanism, the risk, the required correction, and a verification step.

## When to Use

- A draft review says a class is large, unsafe, untested, slow, or poorly structured without proving it.
- A finding could apply to any programming language.
- The agent needs a compact model for review comments before using `java-agent-output-format.md`.

## Java/Spring-Specific Rules

- Name the endpoint, class, method, package, query, annotation, DTO, entity, or configuration property involved.
- Name the Java/Spring mechanism that creates the risk: MVC binding, Bean Validation, `@Transactional`, JPA lazy loading, Spring Data query, Security filter chain, method security, `Optional`, `BigDecimal`, `Clock`, immutable collections, or checked exceptions.
- Pair every required correction with a verification step: unit test, application service test, MVC slice, repository integration test, security test, migration check, or manual command.
- Keep optional cleanup separate from required fixes.

## Bad Practices

- "Controller is doing too much."
- "Entity leakage is bad."
- "Authorization is missing."
- "Transaction boundary is wrong."
- "Cover this better."
- "This looks unsafe."
- "Architecture is unclear."

## Better Alternatives

- State the evidence first, then the risk, then the correction.
- Use the smallest Java/Spring target that fixes the issue: controller mapping, use case class, domain policy, repository port, persistence adapter, response DTO, security policy, or test slice.
- Include a verification step that proves the behavior, not only the implementation shape.

## Review Checklist

- [ ] Does the finding name a file/class/method, endpoint, package, query, annotation, or configuration path?
- [ ] Does it name the Java/Spring mechanism that makes the issue real?
- [ ] Does it explain user, data, security, deployment, test, or maintenance impact?
- [ ] Does it separate the required correction from optional cleanup?
- [ ] Does it include a concrete verification step?

## Common Mistakes

- Treating a generic smell label as a review finding.
- Asking for a new interface without naming the application-owned port and infrastructure implementation.
- Requesting more tests without naming the behavior and the correct Java/Spring test level.
- Reporting a security issue without actor, asset, entry point, and missing check.
- Reporting a JPA performance issue without naming fetch shape, pagination, query cardinality, or transaction scope.

## Agent Instructions

Before finalizing a review, compare each finding against the acceptable examples below. If a finding lacks evidence, mechanism, risk, correction, or verification, rewrite it or remove it.

## Examples

### Fat Controller Review

Weak:

> `OrderController` is doing too much.

Acceptable:

> `OrderController.placeOrder` maps the HTTP request, checks inventory, opens order state transitions, writes through `OrderRepository`, and sends email from the controller path. Keep MVC binding and response mapping in the controller, move workflow into `PlaceOrderUseCase`, and move order state decisions into the domain model because this mixes web, transaction, persistence, and domain ownership. Verify with an MVC slice test for request/response mapping and an application service test for inventory failure.

### JPA Entity Leakage

Weak:

> Do not return entities from the API.

Acceptable:

> `CustomerController.getCustomer` returns `CustomerEntity`, so Jackson can serialize lazy `roles` and internal audit columns when the persistence shape changes. Return a `CustomerResponse` DTO mapped at the web/application boundary and keep `CustomerEntity` inside the persistence adapter. Verify with an MVC serialization test that excludes roles, password hash, audit fields, and tenant-internal columns.

### Object-Level Authorization

Weak:

> Authorization is missing.

Acceptable:

> `GET /invoices/{invoiceId}` loads `InvoiceEntity` by request ID and returns it after `isAuthenticated()`, but it never checks tenant or owner. An authenticated user can request another invoice ID. Constrain the repository query by tenant or call `invoicePermission.canView(principal, invoice)` in the application service. Verify with a security test where user A receives `403` or `404` for user B's invoice.

### Wrong Transaction Boundary

Weak:

> The transaction boundary is wrong.

Acceptable:

> `PaymentService.captureAndCreateOrder` calls `paymentClient.capture` inside the same `@Transactional` method that persists `OrderEntity`. A database rollback after the remote capture can leave a charged payment without an order. Persist the order intent in one transaction, call the payment port outside that transaction, and record the result with idempotency or an outbox flow. Verify with an application service test for payment success and failure plus a transaction-focused integration test for rollback behavior.

### Weak Test Plan

Weak:

> Cover renewal better.

Acceptable:

> `SubscriptionRenewalService.renew` now branches on expired cards, grace period, and duplicate renewal requests. Add plain Java tests for grace-period policy, application service tests with a fake `ChargePaymentPort` for declined and duplicate payment attempts, and a repository integration test for the unique renewal idempotency key. Verify the duplicate command does not create a second invoice row.

### Unsupported Security Claim

Weak:

> This endpoint looks unsafe.

Acceptable:

> `POST /admin/users/{id}/roles` accepts `roleNames` from the request and only checks authentication. The asset is role assignment, the actor is any authenticated user, and the missing check is admin authorization before mutating roles. Add method security or an application-level admin policy before role updates and verify with a security test that a non-admin principal receives `403`.

### Architecture Finding Without Evidence

Weak:

> The architecture is unclear.

Acceptable:

> `billing.domain.Invoice` imports `org.springframework.data.domain.Page` and `InvoiceJpaRepository`, so the domain package depends on Spring Data and persistence details. Move paging/query behavior to an application query service and expose a domain-neutral repository port for aggregate loading. Verify with an architecture check or import scan that `billing.domain` no longer imports `org.springframework` or `jakarta.persistence`.
