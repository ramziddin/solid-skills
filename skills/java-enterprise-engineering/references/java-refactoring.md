# Java Refactoring

## Purpose

Use this guide to change Java/Spring code without losing current behavior, breaking proxies, widening transactions, changing API contracts, or hiding database migration risk.

## When to Use

- A service, controller, repository, mapper, or entity has accumulated unrelated responsibilities.
- Legacy Java code has no tests and unclear side effects.
- A feature requires moving business logic out of web, persistence, or integration classes.
- A patch touches transactions, JPA mappings, security checks, or external calls.

## Java/Spring-Specific Rules

- Refactor in this order: characterize behavior, isolate pure logic, move mapping, introduce ports, move infrastructure, then rename packages.
- Add characterization tests before changing legacy branches, especially around exceptions, null behavior, database writes, events, and security decisions.
- Extract methods only when the extracted name states a business decision or technical phase.
- Extract classes around ownership: command validator, domain policy, application use case, persistence mapper, adapter, or error mapper.
- Replace conditionals with policies or strategies when rules vary by a stable axis.
- Remove duplication after confirming the duplicated Java paths have the same transaction, authorization, and validation requirements.
- Preserve behavior by keeping API payloads, error codes, event schemas, SQL results, and migration order unchanged unless requested.
- Keep a rollback path: small patches, no broad rename mixed with behavior changes, and explicit verification steps.

## Bad Practices

- Moving code from a service into a domain entity while leaving `@Autowired`, `@Transactional`, or JPA lazy loading assumptions in place.
- Extracting interfaces for every class during cleanup.
- Rewriting controller, service, repository, entity, tests, and migrations in one patch.
- Changing exception types without checking `@ControllerAdvice` mappings.
- Replacing duplicated code with one shared method when each caller needs different authorization or transaction behavior.

## Better Alternatives

- Start with tests around externally visible behavior and domain decisions.
- Move DTO-to-command mapping out of application services before changing business rules.
- Introduce an application-owned port, adapt the existing Spring Data repository behind it, then move callers.
- Keep JPA entities as persistence models until the domain model can be separated with mappers and tests.
- Use package-private classes in the same feature package for extracted policies before creating public APIs.
- Use ArchUnit or existing module tests if the repository already enforces dependency rules.

## Review Checklist

- [ ] Is current behavior protected by unit, slice, integration, or characterization tests?
- [ ] Does each extraction reduce one Java/Spring responsibility?
- [ ] Are transaction annotations still applied through Spring proxies?
- [ ] Are exception mappings and API response shapes unchanged?
- [ ] Are lazy-loaded JPA associations still accessed inside a valid transaction?
- [ ] Are remote calls kept outside long database transactions?
- [ ] Is rollback possible without reverting unrelated changes?

## Common Mistakes

- Calling private `@Transactional` methods and expecting a transaction boundary.
- Moving validation to the domain while still relying on Bean Validation annotations from request DTOs.
- Renaming packages without checking component scanning, entity scanning, mapper scanning, and test fixtures.
- Extracting common code before the third real duplication and creating a shared dependency between features.
- Removing "dead" methods that are used by reflection, Jackson, JPA, MapStruct, or Spring proxies.

## Agent Instructions

For every refactoring plan, state the behavior guard first, then the smallest move. Mention Spring proxy, JPA lazy loading, exception mapping, migration, and public API risks when they apply. Do not propose a broad rewrite when a sequence of narrow Java moves can produce the same result.
