# Spring Boot Hexagonal Architecture

## Purpose

Use hexagonal architecture to protect Java application and domain code from HTTP, database, messaging, and vendor-specific details. Ports describe what the application needs; adapters translate Spring and external systems into those ports.

## When to Use

- The system has multiple inbound paths such as REST, messaging, schedulers, CLI jobs, or batch imports.
- The same use case must work with different databases, vendors, queues, or payment providers.
- Tests need to run application workflows without Spring infrastructure.
- Vendor DTOs or JPA entities are leaking into domain/application code.

## Java/Spring-Specific Rules

- Inbound adapters: REST controllers, message listeners, scheduled jobs, GraphQL controllers, command-line runners.
- Outbound adapters: Spring Data/JPA repositories, WebClient/Feign clients, Kafka/Rabbit publishers, mail senders, storage clients, payment SDK wrappers.
- Application services implement use cases and depend on outbound ports.
- Domain model contains invariants and state transitions without Spring annotations.
- Persistence adapter maps between domain models and JPA entities or database records.
- External API adapter maps between domain/application types and vendor request/response models.
- Ports must be named by capability: `LoadAccountPort`, `SaveInvoicePort`, `ChargeCardPort`, `SendPasswordResetPort`.
- Testing ports means substituting a fake or mock port at the application boundary and verifying behavior, not mocking internals.

## Bad Practices

- Naming ports after technologies, such as `JpaOrderPort`, `StripePort`, or `KafkaPort`, unless the port is intentionally technology-specific.
- Letting outbound adapters return Feign response objects, JPA entities, `Pageable`, or vendor exceptions.
- Putting authorization, transaction, or domain decisions inside adapters.
- Creating one large port for all persistence operations of a feature.
- Calling adapters from domain entities.
- Treating every Spring bean as an adapter without checking direction.

## Better Alternatives

- Use inbound adapters to translate transport-specific input into commands or queries.
- Keep application service methods stable across transports.
- Split outbound ports by use case needs: load for command, save aggregate, check uniqueness, publish event.
- Convert vendor exceptions into application-specific failure types at the adapter boundary.
- Keep transactions in the application layer while adapters perform persistence details.
- Use package structure such as `orders.application`, `orders.domain`, `orders.adapter.in.web`, `orders.adapter.out.persistence`.

## Review Checklist

- [ ] Are inbound adapters free of business workflow decisions?
- [ ] Are outbound adapters free of domain policy decisions?
- [ ] Do application services depend only on ports and domain types?
- [ ] Are port names capability-focused rather than vendor-focused?
- [ ] Do adapters map exceptions and DTOs before crossing into application code?
- [ ] Can use cases be tested without a Spring context?
- [ ] Are transaction and event delivery rules explicit?

## Common Mistakes

- Creating an interface next to every class and calling it a port.
- Returning JPA entities through a port because it is convenient for persistence.
- Using Spring `ApplicationEventPublisher` directly in domain objects.
- Leaking retry annotations or circuit breaker annotations into application services when they describe adapter behavior.
- Ignoring read models; query use cases may use dedicated projections without forcing aggregate loading.

## Agent Instructions

For a hexagonal review, draw the path from inbound adapter to use case to outbound port to adapter. Flag every framework, persistence, or vendor type that crosses inward. Recommend ports only where they protect a real Java/Spring boundary.
