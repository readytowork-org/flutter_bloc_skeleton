# Architecture Guidelines & Layer Boundaries

This document defines the core principles, layer responsibilities, and structural boundaries for building features in this application.

---

## 1. Core Principles

1. **Inward Dependencies Only:** Dependencies flow strictly inward toward the core. Domain logic knows nothing about Data, Infrastructure, UI, or State Management.
2. **Pure Domain Layer:** `lib/features/[feature]/domain/` MUST remain pure Dart. Zero imports from `package:flutter`, `flutter_bloc`, `dio`, or the `data/` layer.
3. **Explicit Functional Error Handling:** Operations that can fail must return `Future<ApiResult<T>>` — a Freezed union with `Success<T>` and `Error<T>` variants. Neither `fpdart` nor `dartz` is used. Throwing raw, untyped runtime exceptions into the UI layer is prohibited.
4. **Immutability Standard:** Domain Entities use `Equatable`. BLoC States and Events use `@freezed` unions. All values are immutable.

---

## 2. Layer Separation & Contracts

```
┌────────────────────────────────────────┐
│            PRESENTATION                │
│   (Pages, Widgets, BLoC, Event/State)  │
└───────────────────┬────────────────────┘
                    │ depends on
                    ▼
┌────────────────────────────────────────┐
│               DOMAIN                   │
│   (Entities, Use Cases, Repositories)  │
└───────────────────▲────────────────────┘
                    │ implemented by
                    │
┌───────────────────┴────────────────────┐
│                DATA                    │
│   (Models, Repositories Impl, DataSrc) │
└────────────────────────────────────────┘
```

### A. Domain Layer (`lib/features/[feature]/domain/`)
The core business logic of the application.

- **Entities:** Pure business models extending `Equatable`. Must not import from `data/` or `package:flutter`.
- **Repository Contracts:** Pure abstract interfaces defining data access methods. All methods return `Future<ApiResult<T>>`.
- **Use Cases:** Executable units of single business actions. Constructor-injected with a repository. Expose a `call()` method returning `ApiResult<T>`.

---

### B. Data Layer (`lib/features/[feature]/data/`)
Translates external inputs (API, local storage) into domain-understandable constructs.

- **Models (DTOs):** Data Transfer Objects with `fromJson`/`toJson` and `toEntity()` mappers. Auth uses Freezed (`@freezed`); Product uses manual JSON parsing.
- **Data Sources:** Abstract interfaces with `Impl` suffix implementations. Direct interactions with `DioClient` or `FlutterSecureStorage`. Throw typed exceptions (`ServerException`, `NetworkException`, `StorageException`).
- **Repository Implementations:** Implements Domain Repository interfaces. Wrap DataSource calls in try-catch and map low-level exceptions into `ApiResult.failure(Failure)` via `handleDioError()` or explicit catch blocks.

---

### C. Presentation Layer (`lib/features/[feature]/presentation/`)
Handles user interaction, state management, and visual layouts.

- **BLoC / Cubit:** Manages UI states using Freezed immutable Events and States. Business logic inside BLoC is strictly limited to invoking Domain Use Cases. Consume `ApiResult` via `.when(success: ..., failure: ...)`.
- **Pages:** Top-level screen components responsible for initializing `BlocProvider` and defining layout skeletons.
- **Widgets:** Reusable, modular visual components consuming state via `BlocBuilder`, `BlocListener`, or `BlocConsumer`. Organized using Atomic Design (atoms, molecules, organisms).

---

## 3. Mandatory Layer Interaction Rules

- **DO NOT** import `package:flutter` or Data models inside Domain entities, repository interfaces, or use cases.
- **DO NOT** write raw HTTP requests (`Dio`) or database calls inside BLoC or UI Widgets.
- **DO NOT** pass raw JSON maps into the Domain or Presentation layers; always parse via Data Models first.
- **DO NOT** edit generated `*.g.dart` or `*.freezed.dart` files manually.
- **DO NOT** introduce a second result abstraction (`fpdart`, `dartz`, etc.). `ApiResult<T>` is the single success/failure union.

---

## 4. Cross-Cutting Concerns

### 4.1 Result & Error Handling

`ApiResult<T>` (defined in `lib/core/network/api_result.dart`) is a Freezed union:

```dart
@freezed
class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(Failure failure) = Error<T>;
}
```

**Failure hierarchy** (`lib/core/error/failures.dart`):
- `Failure` — abstract base, extends `Equatable`, has `message` field
- `ServerFailure`, `CacheFailure`, `NetworkFailure` — concrete with default messages
- `UnauthorizedFailure`, `SessionExpiredFailure`, `UnknownFailure` — final classes
- `ValidationFailure` — takes a custom message
- `handleDioError(DioException)` — maps Dio exceptions to Failure types

**Exception hierarchy** (`lib/core/error/exceptions.dart`):
- `AppException` — sealed base class
- `NetworkException`, `ServerException`, `UnauthorizedException`, `RefreshTokenExpiredException`, `StorageException`

### 4.2 Dependency Injection (GetIt)

- Global service locator: `sl = GetIt.instance` in `lib/core/di/service_locator.dart`
- Registration order: external services -> token storage -> core/shared -> features -> router LAST
- Each feature has an `initXxx()` function called from `init()`
- Data sources, repositories, and use cases: `registerLazySingleton`
- Shared blocs: `registerLazySingleton`; page-specific blocs: `registerFactory`

### 4.3 Routing (GoRouter)

- `AppRouter` extends `GoRouter` with `RoutingConfig` / `ConstantRoutingConfig`
- `AppRouterRedirect.redirect()` handles auth-based navigation (checks `AuthBloc` state and `TokenStorage.accessToken`)
- Each feature defines `XxxRoute` enum (paths + names) and `XxxRoutes` class (GoRoute list)
- Product routes use `ShellRoute` with `MultiBlocProvider` for shared blocs

### 4.4 Networking (Dio)

- `DioClient` — wrapper around `Dio` with typed methods (get/post/put/patch/delete/fetch)
- Base URL and timeouts configured from `Config`
- Interceptors: `LogInterceptor`, `DioAuthInterceptor` (legacy), `JwtInterceptor` (single-flight refresh)
- `ApiEndpoints` — static constants for all REST endpoints

### 4.5 Token Storage

- `TokenStorage` — abstract interface (save/get/clear/init)
- `SecureTokenStorage` — implementation using `FlutterSecureStorage`
- Stores access and refresh tokens in platform secure storage with in-memory cache

---

## 5. Feature Structure

### 5.1 Auth Feature

| Layer | Contents |
|-------|----------|
| Domain | `UserEntity`, `TokenEntity` (Equatable), `AuthRepository` (abstract), 5 use cases (Login, Signup, Logout, RefreshToken, Session) |
| Data | `AuthRemoteDataSource` / `Impl`, `UserModel` (Freezed), `AuthRepositoryImpl` |
| Presentation | `AuthBloc` (Freezed events/states), `LoginPage`, `RegisterPage`, atomic widgets |

### 5.2 Product Feature

| Layer | Contents |
|-------|----------|
| Domain | `ProductEntity`, `ProductCategoryEntity` (Equatable), `ProductRepository` (abstract), 5 use cases |
| Data | `ProductRemoteDataSource` / `Impl`, `ProductM` / `ProductResponseM` / `ProductCategoryM` (manual JSON), `ProductRepositoryImpl` |
| Presentation | 4 BLoCs (Pagination, GetById, Category, Add/Edit), 4 pages, full atomic design widgets |

### 5.3 Cart Feature (Stub)

Presentation only — `CartPage` with `CartPageView`. No domain or data layers yet.

### 5.4 Profile Feature

| Layer | Contents |
|-------|----------|
| Domain | `ProfileRepository` (abstract), `ProfileUseCase` — reuses `UserEntity` from auth |
| Data | `ProfileRemoteDataSource` / `Impl`, `ProfileRepositoryImpl` — reuses `UserModel` from auth |
| Presentation | `GetProfileBloc`, `ProfilePage`, atomic widgets. DI at `presentation/profile_di.dart` |

---

## 6. Shared Code (`lib/shared/`)

| Category | Contents |
|----------|----------|
| BLoC | `BasePaginationBloc<T>` — abstract generic BLoC for paginated lists with fetch/refresh/update events |
| Cubit | `LocaleCubit` — manages app locale |
| Models | `PaginationParams` — page, skip, filter, pageSize |
| State | `BaseState` — abstract hierarchy (BaseInitial, BaseLoading, BaseLoaded<T>, BaseFailure, BaseEmpty) |
| Widgets | Atomic design: atoms (buttons, inputs, loading), molecules (state builder, refresh views), organisms (pagination view, page not found) |

---

## 7. Widget Organization (Atomic Design)

All features follow Atomic Design for widget organization:

- **Atoms:** Smallest reusable widgets (buttons, input fields, chips, tags, avatars, rating bars)
- **Molecules:** Composed widgets (cards, page views, search bars, headers, info cards)
- **Organisms:** Complex composed widgets (full page views, pagination views, detail sections)

---

## 8. Known Architectural Debt

- **Product domain imports data models:** `ProductEntity` imports `ProductM`, `ProductCategoryEntity` imports `ProductCategoryM` — violates dependency direction. This is existing debt, not a pattern to replicate.
- **Naming inconsistency:** Auth uses `repositories/` (plural), Product uses `repository/` (singular). Follow the existing convention per feature.
- **Profile DI location:** `profile_di.dart` lives under `presentation/` rather than feature root.
- **Dual interceptors:** Both `DioAuthInterceptor` (legacy) and `JwtInterceptor` (new) are registered — migration in progress.
- **Mixed JSON serialization:** Auth `UserModel` uses Freezed; Product models use manual JSON parsing.
