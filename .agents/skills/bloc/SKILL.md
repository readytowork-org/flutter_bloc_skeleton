---
name: bloc
description: Implement Flutter BLoC events, immutable states, transitions, and bloc_test coverage while delegating business work to use cases.
---

# Skill Playbook: /bloc

Use this playbook for feature state-management changes. Read the affected BLoC, use case, page, and nearby tests first. BLoCs delegate to domain use cases; never call Dio, Firebase, or storage directly.

## 1. Events and states — `lib/features/<feature>/presentation/state_management/`

Define events for user intent, such as a fetch or submit request. Use immutable Freezed unions or Equatable states, matching the existing BLoC. Represent initial, loading, success, failure, and empty states only where behavior needs them. Keep success data and failure messages in state payloads.

## 2. Transitions

Register event handlers with `on<EventType>`. Emit loading, call the injected use case, and handle both branches of `ApiResult<T>` with `result.when(success: ..., failure: ...)`. Emit domain data on success and a useful failure state on failure. Guard duplicate or stale responses when relevant. Close owned subscriptions/controllers and never mutate emitted state collections.

## 3. Tests and generation

Use `blocTest<BlocType, StateType>` with Mocktail use-case mocks under `test/unit/features/<feature>/presentation/state_management/`. Assert meaningful event-to-state sequences and failure behavior, not just method calls. Run `make generate` after Freezed event/state edits; review `*.freezed.dart`. Run focused tests, formatting, and `flutter analyze`.
