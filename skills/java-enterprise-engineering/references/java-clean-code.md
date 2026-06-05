# Java Clean Code

## Purpose

Use this guide to review Java readability through concrete language and framework choices: names, methods, exceptions, nulls, immutability, collections, logging, and configuration.

## When to Use

- A method is hard to review because it mixes mapping, branching, persistence, and side effects.
- Names hide domain meaning or duplicate concepts across packages.
- Nulls, mutable collections, checked exceptions, or logging make behavior unclear.
- Spring configuration or runtime values are scattered across literals.

## Java/Spring-Specific Rules

- Names must match domain language and Spring role: `OrderController`, `PlaceOrderService`, `OrderRepositoryAdapter`, `PaymentGatewayPort`.
- Keep methods focused on one decision or transformation; long Java methods often hide transaction, null, and exception paths that tests miss.
- Prefer value objects for domain primitives such as `CustomerId`, `EmailAddress`, `Money`, `TenantId`, and `Sku` when validation or behavior exists.
- Use `Optional<T>` for return values that may be absent; do not use it for entity fields, DTO fields, method parameters, or Jackson-bound request bodies.
- Throw domain-specific exceptions for business rule violations and map them at the web boundary.
- Prefer immutable value objects, final fields, and unmodifiable collections for domain state.
- Log business events with safe identifiers and correlation IDs; never log credentials, tokens, full authorization headers, or raw personal payloads.
- Bind configuration with `@ConfigurationProperties` and validation instead of scattering `@Value` across services.

## Bad Practices

- Method names such as `process`, `handle`, `doStuff`, `validateData`, or `manageUser`.
- Returning `null` from `findById` while callers expect `Optional`.
- Catching `Exception` and returning success, default values, or empty lists.
- Exposing `List<OrderLine>` from an aggregate and letting callers mutate it.
- Logging request bodies that contain passwords, tokens, addresses, or payment data.
- Using static utility classes for domain behavior that needs state, policy, time, or configuration.

## Better Alternatives

- Rename by business action: `calculateCancellationFee`, `reserveStock`, `issueRefund`, `canAccessInvoice`.
- Split Java methods by phase: validate command, load aggregate, apply domain decision, persist, publish event.
- Use factory methods on value objects for validation: `EmailAddress.parse(rawEmail)`.
- Return `Collections.unmodifiableList(lines)` or `List.copyOf(lines)` from domain objects.
- Use `Clock`, `UuidGenerator`, or domain services instead of `LocalDateTime.now()` and `UUID.randomUUID()` inside business rules.
- Configure clients through typed properties: timeouts, retry limits, base URL, pool size, feature flags.

## Review Checklist

- [ ] Are names specific enough to identify the domain behavior being changed?
- [ ] Does each method have one reason to branch?
- [ ] Are nullable values guarded at boundaries and represented consistently?
- [ ] Are exceptions meaningful at the layer where they are thrown?
- [ ] Are collections copied or protected before crossing class boundaries?
- [ ] Are logs safe, searchable, and tied to request or business IDs?
- [ ] Are configuration values typed, validated, and environment-specific?

## Common Mistakes

- Using Lombok `@Data` on mutable entities or command objects where setters break invariants.
- Hiding important behavior in `@PostConstruct`, entity listeners, or mapper hooks.
- Reusing one DTO for create, update, response, and persistence projection.
- Treating checked exceptions as a reason to wrap everything in `RuntimeException` without domain meaning.
- Adding comments to explain tangled logic instead of separating the Java decisions.

## Agent Instructions

When reviewing Java readability, replace vague critique with a concrete rewrite target. Name the confusing symbol, the domain term that should replace it, the nullable or mutable path at risk, and the test that would prove the rewritten method still behaves the same.
