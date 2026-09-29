Here is the single, complete docs/knowledge/ARCHITECTURE.md document tailored specifically for your Flutter + BLoC + Clean Architecture setup.

docs/knowledge/ARCHITECTURE.md

# Architecture Guidelines & Layer Boundaries

This document defines the core principles, layer responsibilities, and structural boundaries for building features in this application.

---

## 1. Core Principles

1. **Inward Dependencies Only:** Dependencies flow strictly inward toward the core. Domain logic knows nothing about Data, Infrastructure, UI, or State Management.
2. **Pure Domain Layer:** `lib/features/[feature]/domain/` MUST remain pure Dart. Zero imports from `package:flutter`, `flutter_bloc`, `dio`, or the `data/` layer.
3. **Explicit Functional Error Handling:** Operations that can fail must return `Future<Either<Failure, T>>` using `fpdart` (or `dartz`). Throwing raw, untyped runtime exceptions into the UI layer is prohibited.
4. **Immutability Standard:** Domain Entities, BLoC States, and Events must be immutable (`Equatable` or `@freezed`).

---

## 2. Layer Separation & Contracts



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
┌───────────────────┴────────────────────┘
│                DATA                    │
│   (Models, Repositories Impl, DataSrc) │
└────────────────────────────────────────┘


### A. Domain Layer (`lib/features/[feature]/domain/`)
The core business logic of the application.

- **Entities:** Pure business models extending `Equatable` or using `@freezed`.
- **Repository Contracts:** Pure abstract interfaces defining data access methods without implementation details. Must return `Either<Failure, T>`.
- **Use Cases:** Executable units of single business actions implementing a callable `UseCase<Type, Params>` base interface.

---

### B. Data Layer (`lib/features/[feature]/data/`)
Translates external inputs (API, local DB, hardware) into domain-understandable constructs.

- **Models (DTOs):** Data Transfer Objects extending or mapping to Domain Entities. Must include `fromJson`/`toJson` and explicit `toEntity()` / `fromEntity()` mappers.
- **Data Sources:** Direct interactions with remote services (`Dio`) or local storage (`Hive`/`SharedPreferences`). Throws typed exceptions (`ServerException`, `CacheException`).
- **Repository Implementations:** Implements Domain Repository interfaces. Wraps DataSource calls in try-catch blocks and maps low-level exceptions into Domain `Failure` instances.

---

### C. Presentation Layer (`lib/features/[feature]/presentation/`)
Handles user interaction, state management, and visual layouts.

- **BLoC / Cubit:** Manages UI states using immutable Events and States. Business logic inside BLoC is strictly limited to invoking Domain Use Cases.
- **Pages:** Top-level screen components responsible for initializing `BlocProvider` and defining layout skeletons.
- **Widgets:** Reusable, modular visual components consuming state strictly via `BlocBuilder`, `BlocListener`, or `BlocConsumer`.

---

## 3. Mandatory Layer Interaction Rules

- **DO NOT** import `package:flutter` or Data models inside Domain entities, repository interfaces, or use cases.
- **DO NOT** write raw HTTP requests (`Dio`) or database calls inside BLoC or UI Widgets.
- **DO NOT** pass raw JSON maps into the Domain or Presentation layers; always parse via Data Models first.
- **DO NOT** edit generated `*.g.dart` or `*.freezed.dart` files manually.