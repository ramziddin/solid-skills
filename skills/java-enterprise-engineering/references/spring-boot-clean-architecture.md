# Spring Boot Clean Architecture

## Purpose

Use this guide to keep Spring Boot applications from turning every use case into controller-to-service-to-repository transaction scripts. The goal is clear ownership between web adapters, application use cases, domain rules, and infrastructure adapters.

## When to Use

- Controllers contain business decisions or database calls.
- Application services depend directly on Spring Data, Feign, WebClient, JPA entities, or generated SDK models.
- Domain logic is hidden in mappers, repositories, entity listeners, or controller branches.
- DTOs and entities are reused across web, persistence, and domain boundaries.

## Java/Spring-Specific Rules

- Controller layer: HTTP method, path, request model, authentication principal extraction, syntactic validation, response mapping.
- Application layer: use case orchestration, transaction boundary, authorization handoff, loading/saving aggregates, calling ports, publishing events.
- Domain layer: entities, value objects, aggregates, policies, invariants, state transitions, domain events.
- Infrastructure layer: Spring Data repositories, JPA entities when separated from domain, adapters for HTTP clients, messaging, storage, mail, payment, and identity.
- Use case classes should be named by command or query intent: `PlaceOrderUseCase`, `CancelSubscriptionUseCase`, `GetInvoiceDetailsQuery`.
- Dependency direction points inward. Infrastructure can depend on application/domain; domain must not import Spring, JPA, Jackson, or transport classes.
- DTO/entity separation is mandatory for public APIs and recommended for internal APIs when lazy loading, hidden fields, or persistence shape can leak.
- Transaction boundaries usually belong on application service methods that perform one business use case.

## Bad Practices

- `@RestController` methods that open transactions, call multiple repositories, and decide state transitions.
- Domain objects annotated with Spring stereotypes or depending on application services.
- Returning JPA entities from controllers and relying on Jackson to traverse lazy associations.
- Calling remote APIs inside a database transaction without an outbox, retry, idempotency, or compensation strategy.
- Using one `CommonService` to coordinate unrelated features.
- Letting MapStruct or mapper classes contain business decisions.

## Better Alternatives

- Map request DTOs to commands at the web boundary and pass commands to use cases.
- Put `@Transactional` on the application method that changes persistent state.
- Create repository ports for aggregate operations, then implement them with Spring Data/JPA in infrastructure.
- Keep framework annotations out of domain classes unless the repository intentionally uses an active record or entity-as-domain model and the team accepts that coupling.
- Map domain exceptions to API errors in `@ControllerAdvice`.
- Keep validation split: Bean Validation for request shape, domain validation for state and policy.

## Review Checklist

- [ ] Do packages show web, application, domain, and infrastructure ownership?
- [ ] Does dependency direction avoid inward imports from Spring MVC, JPA, messaging, SDK, or cloud libraries?
- [ ] Are controllers thin enough to review as HTTP adapters?
- [ ] Are use cases named by business action rather than generic service nouns?
- [ ] Are transaction boundaries placed around use cases and not remote calls?
- [ ] Are request/response DTOs separated from JPA entities?
- [ ] Are exceptions translated at the boundary with stable client-facing codes?

## Common Mistakes

- Treating `@Service` as the application layer even when the class contains persistence and web mapping.
- Putting `@Transactional(readOnly = true)` on controllers and depending on lazy serialization.
- Allowing `Page<Entity>` or `Specification<Entity>` to become application/domain contract types.
- Moving all classes into layer packages and losing feature ownership.
- Assuming clean architecture requires many interfaces before real boundaries exist.

## Agent Instructions

When reviewing Spring Boot architecture, include a dependency-direction trace. Name the package or class that owns each responsibility today, the package or class that should own it, and the smallest move that improves the boundary.
