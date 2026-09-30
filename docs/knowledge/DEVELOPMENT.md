# Development & Troubleshooting Guide

This document outlines environment setup, dependency injection rules, code generation workflows, and common troubleshooting solutions.

---

## 1. Dependency Injection Scopes (GetIt)

Dependencies are registered manually in `lib/core/di/service_locator.dart` using GetIt. No `injectable` code generation is used.

| Layer Component | Scope Strategy | Registration |
| :--- | :--- | :--- |
| **DataSources** | Lazy Singleton | `sl.registerLazySingleton<Interface>(() => Impl(...))` |
| **Repositories** | Lazy Singleton | `sl.registerLazySingleton<Interface>(() => Impl(...))` |
| **Use Cases** | Lazy Singleton | `sl.registerLazySingleton(() => UseCase(sl<Repository>()))` |
| **Shared BLoCs** | Lazy Singleton | `sl.registerLazySingleton(() => Bloc(sl<UseCase>()))` |
| **Page BLoCs** | Factory | `sl.registerFactory(() => Bloc(sl<UseCase>()))` |
| **Router** | Lazy Singleton | Registered LAST after all features |

### Registration Order

1. External services (SharedPreferences, Firebase, OneSignal, FlutterSecureStorage)
2. Token storage (initialized before registration)
3. Dio + DioClient
4. Core/shared (AppTheme, LocaleCubit)
5. Features (`initAuth()`, `initCart()`, `initProduct()`, `initProfile()`)
6. Router (depends on AuthBloc for `refreshListenable`)

---

## 2. Code Generation Workflow

Whenever you add or modify files annotated with `@freezed` or `@JsonSerializable()`:

### Trigger Code Generation
```bash
make generate
```

### Development Watch Mode
```bash
make watch
```

### Clean + Rebuild
```bash
flutter clean && flutter pub get && make generate
```

---

## 3. Environment Setup

### Initial Setup
```bash
make project-setup
```

This runs `flutter clean`, `flutter pub get`, installs Git hooks, and configures skill discovery.

### Environment Configuration
```bash
make set-env-local   # Local development
make set-env-dev     # Development server
make set-env-prod    # Production
```

Each command runs `scripts/set_env.sh` which switches `.env` configuration. Inspect the script and verify all required source files exist before running.

### Firebase Setup
```bash
make setup-firebase
```

---

## 4. Formatting & Analysis

```bash
# Check formatting (CI-style, exits non-zero if changes needed)
dart format --output=none --set-exit-if-changed lib test

# Apply formatting + automated fixes
make flutter-fix

# Static analysis
flutter analyze
```

---

## 5. Testing

```bash
# Run all tests
flutter test

# Unit & BLoC tests only
flutter test test/unit

# Widget tests only
flutter test test/widget

# Integration tests (requires configured device)
flutter test integration_test/app_test.dart
```

See [TESTING.md](../TESTING.md) for detailed testing patterns and examples.

---

## 6. Troubleshooting Matrix

| Issue / Error | Root Cause | Solution |
| :--- | :--- | :--- |
| Missing `*.freezed.dart` or `*.g.dart` | Code generator hasn't run post-annotation edit | Run `make generate` |
| Type error in Domain layer | Illegal import from Data, Flutter, or BLoC | Check Domain file imports; retain pure Dart packages only |
| GetIt object not found | Missing registration in feature DI or `service_locator.dart` | Add registration in the feature's `initXxx()` function |
| BLoC state not triggering rebuild | Missing Equatable or `@freezed` equality | Ensure entities extend `Equatable` and states use `@freezed` |
| Build Runner conflict error | Stale cache files or broken references | Run `flutter clean && flutter pub get && make generate` |
| `ApiResult` pattern match error | Incomplete `.when()` handling | Ensure both `success` and `failure` branches are provided |
| Localization not updating | Generated l10n files are stale | Run `flutter gen-l10n` after editing `.arb` files |

---

## 7. Key Conventions

- **FVM:** Flutter 3.47.1 is pinned via `.fvmrc`. Use `fvm flutter` and `fvm dart` for all SDK commands.
- **Result type:** Always use `ApiResult<T>` (Freezed union). Do not introduce `fpdart`, `dartz`, or other result abstractions.
- **Error handling:** Map exceptions to `Failure` in repository implementations. Return `ApiResult.failure(failure)`. Do not throw raw exceptions into the UI layer.
- **Generated files:** Never hand-edit `*.g.dart` or `*.freezed.dart` files.
- **Naming:** `snake_case.dart` filenames, `PascalCase` types, `lowerCamelCase` members.
