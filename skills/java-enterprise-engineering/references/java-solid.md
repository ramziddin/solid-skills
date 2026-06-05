# Java SOLID

## Purpose

Use SOLID as a review tool for Java classes, Spring beans, ports, adapters, domain objects, and test seams. Do not cite a principle by name unless you can point to the class, dependency, method, or interface that violates it.

## When to Use

- A Java class has multiple reasons to change.
- A Spring service keeps growing with new branches, injected beans, and transaction cases.
- An interface forces implementers to throw unsupported exceptions.
- Application logic depends directly on JPA repositories, SDK clients, or framework annotations.

## Java/Spring-Specific Rules

- Single Responsibility Principle: a controller owns HTTP mapping; an application service owns workflow; a domain object owns invariants; a persistence adapter owns database translation.
- Open/Closed Principle: add new pricing, notification, tax, or routing behavior through strategies, policies, enum behavior, or Spring-discovered implementations only when those rules vary independently.
- Liskov Substitution Principle: subclasses must preserve method contracts, null behavior, validation rules, transaction expectations, and checked exception meaning.
- Interface Segregation Principle: split service contracts by caller need, such as `CustomerReader`, `CustomerCommandPort`, and `CustomerPermissionChecker`, instead of one wide `CustomerService`.
- Dependency Inversion Principle: application services may depend on ports they own; infrastructure implements those ports and adapts Spring Data, Feign, Kafka, S3, or payment SDK details.
- Constructor injection makes required dependencies visible; field injection hides dependency width and makes unit tests depend on Spring reflection.

## Bad Practices

- A `UserService` that validates HTTP DTOs, checks permissions, changes entities, sends email, writes audit logs, and calls remote APIs.
- A base entity class whose subclasses override behavior by returning `null`, ignoring validation, or widening accepted states.
- A `Repository` interface in the domain that exposes `JpaRepository`, `Pageable`, `Specification`, or `EntityManager`.
- A generic `CrudService<T>` that erases domain verbs such as `activateAccount`, `reserveInventory`, or `approveRefund`.
- A port named `ExternalApiClient` with methods for unrelated vendors and use cases.

## Better Alternatives

- Extract application use cases such as `RegisterCustomerUseCase`, `ApproveRefundUseCase`, or `ReserveInventoryUseCase` when workflows differ.
- Keep domain ports narrow: `LoadCustomerByEmail`, `SaveCustomer`, `ChargePayment`, `PublishOrderPlaced`.
- Replace inheritance-heavy workflows with injected policies when behavior varies by product, tenant, country, or payment method.
- Use package-private helpers inside a feature package before creating public abstractions.
- Keep Spring annotations on adapters and configuration classes; wire domain policies through constructors.

## Review Checklist

- [ ] Does each class have one clear owner: web, application, domain, persistence, integration, security, or configuration?
- [ ] Can a new business rule be added without modifying unrelated branches in a central service?
- [ ] Can every subtype be used through the parent type without changing behavior, exceptions, or null guarantees?
- [ ] Does each interface expose only methods its callers use?
- [ ] Does application/domain code depend on ports instead of Spring Data repositories, HTTP clients, or vendor SDKs?
- [ ] Are Spring beans injected through constructors with final fields?
- [ ] Are abstractions named by domain capability rather than technology?

## Common Mistakes

- Treating every implementation class as evidence that an interface is needed.
- Using inheritance for JPA entity reuse when composition or embeddables would avoid fragile base behavior.
- Putting `@Transactional` on many small private helper paths and expecting Spring proxies to apply it.
- Creating a strategy map before there are multiple stable rule variants.
- Letting a test mock a wide interface because the production dependency is too broad.

## Agent Instructions

When reporting a SOLID finding, include the class, method, dependency, and exact change pressure. Say which caller or future rule is blocked. Recommend the smallest Java/Spring change: split a port, move a dependency outward, extract a policy, narrow an interface, or replace inheritance with composition.
