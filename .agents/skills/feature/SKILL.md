---
name: feature
description: Use when explicitly invoked as /feature to implement a complete Flutter BLoC feature through domain, data, presentation, dependency injection, routing, and verification.
---

# Skill Playbook: /feature

Use this playbook when explicitly invoked as `/feature` or named as the `feature` skill (`$feature` in Codex). Read `AGENTS.md` and a comparable feature, define the requested user flow, then work in order: **Domain → Data → Presentation → DI and routing → Testing**. Dependencies point inward. New domain code must not directly import Flutter, BLoC, Dio, GetIt, or data/presentation code. The existing `ApiResult`/`Failure` contract has transitive Dio coupling; do not extend it. Preserve unrelated behavior and public contracts.

## 1. Domain — `lib/features/<feature>/domain/`

- Create immutable entities with `Equatable` or Freezed, following the neighboring feature. Keep DTO parsing out of new entities.
- Define abstract repository contracts returning `Future<ApiResult<T>>`; this project's success/failure union replaces the sample's `Either<Failure, T>`.
- Add callable use-case classes with `call()` and constructor-injected repository interfaces. There is no shared `UseCase<Type, Params>` base class.

## 2. Data — `lib/features/<feature>/data/`

- Create DTOs with `fromJson`/`toJson` where the API needs them; map explicitly with `toEntity()` and `fromEntity()` when the direction is used.
- Define abstract and concrete remote or local data sources for required I/O.
- Implement the domain repository contract. Map expected Dio/storage exceptions to `Failure` and return `ApiResult.success(entity)` or `ApiResult.failure(failure)`. Do not expose DTOs or raw transport exceptions to presentation.

## 3. Presentation — `lib/features/<feature>/presentation/`

- Add explicit events and immutable initial/loading/success/failure states as the flow requires under `presentation/state_management/`. BLoCs call use cases and handle both `ApiResult` branches.
- Build a page with focused widgets. Place `BlocProvider` at the page or route boundary, matching neighboring code; use `BlocBuilder` or `BlocConsumer` for state-driven UI.

## 4. DI and routing

- Register data sources, repositories, use cases, and BLoCs with GetIt in the feature's `*_di.dart`; call its initializer from `lib/core/di/service_locator.dart`. This project does not use `injectable`.
- Define feature paths and routes in `presentation/routes/`, then compose the route list in `lib/core/routes/app_routes.dart`. Change `app_route_redirect.dart` only when authentication behavior changes.

## 5. Generation and tests

- Follow `/codegen` when generated inputs change; run `make generate`, then review and include `*.freezed.dart` and `*.g.dart`. Run `flutter gen-l10n` for changed ARBs.
- Add use-case unit tests and `blocTest` coverage for meaningful success/failure emissions under `test/unit/features/`. Add widget tests for new interactions under `test/widget/features/`.
- Run focused tests, `dart format --output=none --set-exit-if-changed lib test`, and `flutter analyze`. Report what changed by layer and which checks passed or could not run.
