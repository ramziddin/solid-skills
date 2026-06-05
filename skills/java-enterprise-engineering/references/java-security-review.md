# Java/Spring Security Review

## Purpose

Use this guide to review Java and Spring Boot security behavior at the endpoint, application service, persistence, logging, and configuration boundaries.

## When to Use

- A PR changes controllers, security configuration, authorization policy, object ownership, identity tokens, secrets, logs, validation, exports, or admin behavior.
- A service loads data by ID from a request.
- A new external integration, webhook, file upload, or token flow is introduced.
- API responses expose new fields.

## Java/Spring-Specific Rules

- Authentication: verify the endpoint requires the intended authentication mechanism and rejects anonymous calls.
- Authorization: check object-level permission after loading the target resource or through a query constrained by tenant/owner/role.
- Input validation: validate path IDs, request bodies, nested objects, file metadata, sort fields, filters, date ranges, enum values, and payload size.
- Output exposure: response DTOs must exclude secrets, internal roles, reset tokens, password hashes, audit-only fields, tenant boundaries, and data from unrelated owners.
- Secret handling: use externalized secret-backed configuration; never commit live credentials, private keys, tokens, or webhook secrets.
- Sensitive logging: redact authorization headers, cookies, passwords, tokens, full personal payloads, and payment details.
- Password handling: use approved password encoders, never reversible encryption, never log raw passwords, and never return password state beyond safe flags.
- Token handling: validate issuer, audience, expiry, signature, algorithm, tenant, and revocation requirements.
- Spring Security boundaries: confirm filter order, method security, CORS, CSRF, session behavior, and exception handling match the deployment model.
- Unsafe defaults: deny by default for non-public endpoints and make public routes explicit.

## Bad Practices

- Loading `Invoice` by ID and returning it without checking owner, tenant, or permission.
- Trusting user-controlled role, tenant, price, status, or account ID fields in request DTOs.
- Using `@PreAuthorize("isAuthenticated()")` where object ownership is required.
- Logging full request/response bodies in an interceptor.
- Accepting webhook calls without verifying signature, timestamp, replay window, and event idempotency.
- Returning JPA entities from admin and non-admin endpoints with the same serializer.

## Better Alternatives

- Use authorization methods that include the resource: `invoicePermission.canView(principal, invoice)`.
- Constrain repository queries by principal context: `findByIdAndTenantId`.
- Map request DTOs to commands that exclude server-owned fields such as status, owner ID, roles, and price.
- Use separate response DTOs for public, owner, support, and admin views.
- Configure redaction in logging filters and exception handlers.
- Validate webhook signatures before parsing event effects and store processed event IDs.

## Review Checklist

- [ ] Is each changed endpoint authenticated or explicitly public?
- [ ] Is object-level access checked for IDs, tenant data, exports, and nested resources?
- [ ] Are request-controlled fields prevented from overriding server-owned state?
- [ ] Are responses shaped by caller permission?
- [ ] Are secrets sourced from protected configuration and absent from logs?
- [ ] Are tokens and webhooks validated against issuer/signature/expiry/replay rules?
- [ ] Are security failures mapped without revealing internals?

## Common Mistakes

- Assuming route-level role checks cover tenant or ownership checks.
- Validating DTO syntax but not domain authorization.
- Using `permitAll` for health, docs, or callbacks and accidentally exposing adjacent routes.
- Allowing mass assignment through entity binding.
- Testing only happy-path authentication and missing forbidden cross-user access.

## Agent Instructions

For every security finding, name the asset, actor, entry point, missing check, and impact. Include the Spring mechanism involved, such as filter config, `@PreAuthorize`, controller binding, repository query, DTO mapper, or exception handler.
