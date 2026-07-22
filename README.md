# Flutter Bloc Skeleton

A feature-first Flutter shopping app demonstrating Bloc, GoRouter, GetIt,
Dio, secure token storage, localization, Firebase, and push notifications.

## Architecture

The app deliberately uses a short request path:

```text
Widget -> Bloc -> Repository -> DioClient -> API
                  |
                  -> Model -> Entity
```

- **Widgets** render state and send events.
- **Blocs** coordinate UI state and call a repository.
- **Repository contracts** describe operations and make Blocs easy to test.
- **Repository implementations** call the API, map models, and convert errors.
- **DioClient** owns shared HTTP configuration and JWT handling.

Use cases and separate remote-data-source interfaces are intentionally omitted.
They can be added later when an operation contains reusable business rules or a
feature needs multiple data sources.

## Project structure

```text
lib/
├── main.dart                 # Startup and platform services
├── app.dart                  # Root providers and MaterialApp
├── core/
│   ├── di/                   # GetIt registrations
│   ├── network/              # Dio, endpoints, JWT, API result
│   ├── routes/               # Root GoRouter configuration
│   ├── storage/              # Token persistence
│   └── theme/                # Application themes
├── features/
│   ├── auth/
│   ├── product/
│   ├── profile/
│   └── cart/
├── shared/                   # Reusable Bloc and widgets
└── l10n/                     # Localization
```

Each substantial feature uses:

```text
feature/
├── data/
│   ├── models/               # API JSON objects
│   └── repositories/         # Repository implementations
├── domain/
│   ├── entities/             # App-facing data objects
│   └── repositories/         # Testable contracts
├── presentation/
│   ├── pages/
│   ├── routes/
│   ├── state_management/
│   └── widgets/
└── feature_di.dart           # Feature dependency registration
```

## Startup flow

1. `main.dart` initializes Flutter and calls the service locator.
2. `service_locator.dart` initializes storage, Firebase, Dio, repositories,
   Blocs, and finally the router.
3. `app.dart` exposes app-wide Blocs with `MultiBlocProvider`.
4. GoRouter chooses login or products from the current authentication state.

GetIt constructs dependencies; BlocProvider makes Blocs available in the
widget tree. They are separate responsibilities.

## Example: login

```text
LoginPageView
  -> LoginRequested
  -> AuthBloc emits AuthLoading
  -> AuthRepository.login
  -> POST /auth/login
  -> token storage
  -> AuthBloc emits Authenticated or AuthFailure
  -> router redirects or UI shows an error
```

## Plain Dart events, states, and models

Bloc events and states are ordinary sealed Dart classes. API models parse JSON
with visible `fromJson` constructors. The project does not use Freezed,
`build_runner`, or hidden generated implementations.

API requests are also explicit repository methods. Nothing generates or sends
an API request automatically.

## Common commands

```sh
flutter test
flutter analyze
make set-env-local
make set-env-dev
make set-env-prod
```

See [TESTING.md](TESTING.md) for the testing conventions.

## Known limitation

The registration UI exists, but `AuthRepositoryImpl.signUp` is not implemented
yet.
