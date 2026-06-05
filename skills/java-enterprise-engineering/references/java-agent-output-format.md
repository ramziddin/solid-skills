# Java Agent Output Formats

## Purpose

Use these formats to make Java/Spring agent output reviewable. Each format forces concrete evidence, risk, required changes, and verification steps.

## When to Use

- Producing Java code review output.
- Planning a Java refactor.
- Reviewing Spring Boot architecture.
- Creating a test plan.
- Reviewing security-sensitive Java/Spring changes.
- Writing a pull request review.
- Investigating a Java/Spring bug.

## Java/Spring-Specific Rules

- Mention Spring mechanisms by name when they matter: MVC binding, Bean Validation, Security filter chain, method security, transaction proxy, JPA fetch, configuration binding, event listener, scheduler, async executor.
- Mention Java mechanisms by name when they matter: nullability, generics, checked exceptions, immutable collections, records, sealed types, concurrency primitives, `Optional`, `BigDecimal`, `Clock`.
- Include file/class/method references for findings.
- Separate patch suggestions from verification commands.
- Use final decisions only when the user asks for review or PR judgment.

## Bad Practices

- Returning a broad essay that does not identify affected classes.
- Saying a change needs tests without naming the Java behavior and test level.
- Recommending architecture changes without naming dependency direction.
- Reporting security risk without actor, asset, entry point, and missing check.
- Mixing optional refactors with merge-blocking issues.

## Better Alternatives

- Tie each concern to a Java/Spring behavior: "The `@Transactional` method calls `paymentClient.charge` before commit, so a database rollback can leave a captured payment without an order."
- Describe the patch shape: "Introduce `ChargePaymentPort` in application, implement it in `adapter.out.payment`, and call it after order validation."
- Describe verification: "Add an application service test for declined payment and a repository integration test for duplicate order number."

## Review Checklist

- [ ] Does the output name the changed Java/Spring component?
- [ ] Does each finding include impact and required correction?
- [ ] Are tests tied to behavior and level?
- [ ] Are security findings structured by actor, asset, entry point, missing check, and impact?
- [ ] Are optional improvements clearly separated?
- [ ] Is the final decision one of the allowed values when used?

## Common Mistakes

- Using one format for every task and losing the bug, security, or refactor-specific evidence.
- Calling a patch "safe" without mentioning transaction, migration, or API compatibility.
- Omitting assumptions about repository conventions.
- Giving code snippets that introduce package names or dependencies not present in the repository.

## Agent Instructions

Choose the smallest format that matches the task. Keep every heading even if the answer is short; write `None found` only after checking the relevant Java/Spring path.

## Format: Java Code Review

```text
Summary:
Risk level:
Architecture findings:
SOLID/Clean Code findings:
Spring Boot findings:
Testing gaps:
Security risks:
Refactoring plan:
Required changes:
Suggested patch:
Verification steps:
Final decision:
```

Final decision values:

- APPROVE
- APPROVE WITH MINOR CHANGES
- REQUEST CHANGES
- BLOCK

## Format: Java Refactoring Plan

```text
Goal:
Current behavior to preserve:
Characterization tests:
Refactoring sequence:
Java/Spring risks:
Rollback plan:
Patch boundaries:
Verification steps:
Out of scope:
```

## Format: Spring Boot Architecture Review

```text
Architecture detected:
Dependency direction:
Controller boundary:
Application service boundary:
Domain boundary:
Infrastructure boundary:
Transaction boundary:
DTO/entity boundary:
Package cycles:
Required changes:
Verification steps:
Decision:
```

## Format: Test Plan

```text
Behavior under change:
Unit tests:
Application service tests:
Spring slice tests:
Repository/database tests:
External integration tests:
Security tests:
Regression tests:
Fixtures/test data:
Commands to run:
Remaining risk:
```

## Format: Security Review

```text
Entry points:
Assets:
Actors:
Authentication findings:
Authorization findings:
Input validation findings:
Output exposure findings:
Secrets/logging findings:
Token/session findings:
Required changes:
Security tests:
Final decision:
```

## Format: Pull Request Review

```text
Summary:
Blocking findings:
Requested changes:
Minor comments:
Tests reviewed:
Checks to run:
Decision:
```

Decision values:

- APPROVE
- APPROVE WITH MINOR CHANGES
- REQUEST CHANGES
- BLOCK

## Format: Bug Investigation

```text
Observed behavior:
Expected behavior:
Likely Java/Spring path:
Evidence:
Root cause hypothesis:
Reproduction test:
Fix plan:
Regression tests:
Verification steps:
Open questions:
```
