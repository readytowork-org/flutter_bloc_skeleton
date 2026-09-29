
# Development & Troubleshooting Guide

This document outlines environment setup, dependency injection rules, code generation workflows, and common troubleshooting solutions.

---

## 1. Dependency Injection Scopes (`get_it` / `injectable`)

Dependencies must be registered according to their layer lifecycle:

| Layer Component | Scope Strategy | Annotation |
| :--- | :--- | :--- |
| **DataSources** | Lazy Singleton | `@lazySingleton` |
| **Repositories** | Lazy Singleton | `@lazySingleton` |
| **Use Cases** | Lazy Singleton / Factory | `@lazySingleton` / `@injectable` |
| **BLoCs / Cubits** | Factory (Recreated per screen) | `@injectable` |

---

## 2. Code Generation Workflow

Whenever you add or modify files annotated with `@freezed`, `@JsonSerializable()`, or `@injectable`:

### Trigger Code Generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Development Watch Mode
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 3. Troubleshooting Matrix

Issue / Error	Root Cause	Solution
Missing *.freezed.dart or *.g.dart	Code generator hasn't run post-annotation edit	Trigger the /codegen skill or execute build_runner.
Type error in Domain layer	Illegal import from Data, Flutter, or BLoC	Check Domain file imports; retain pure Dart packages only.
get_it Object not registered	Missing @injectable or registration call	Annotate class with @injectable and run /codegen to rebuild DI config.
BLoC state not triggering rebuild	Missing Equatable or @freezed equality	Ensure state extends Equatable and overrides props or uses @freezed.
Build Runner conflict error	Stale cache files or broken references	Run flutter pub run build_runner clean then rebuild.
