# API Specification & Data Integration Standards

This document outlines the contracts, response mappings, exception handling, and Dio client configurations for integrating backend REST endpoints into the application.

---

## 1. DTO to Domain Entity Mapping Pipeline

Raw JSON network responses must **never** leak directly into the Domain or Presentation layers. All network payloads must be deserialized into Data Transfer Objects (DTO Models) in the Data layer and mapped explicitly into Domain Entities.

```
HTTP Response (JSON) ──► DTO Model (fromJson) ──► .toEntity() ──► Domain Entity
```

### Standard Model Rule
- Every Data Model class must live under `lib/features/[feature]/data/models/`.
- Models must provide a `toEntity()` method to convert the DTO to a pure Domain Entity.
- Models must provide a `fromEntity(Entity)` factory or method when sending payloads back to the server.

```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'first_name') required String firstName,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;

  const UserEntity({required this.id, required this.email, required this.firstName});

  @override
  List<Object?> get props => [id, email, firstName];
}

// Mapping
UserEntity toEntity() => UserEntity(id: id, email: email, firstName: firstName);
```

---

## 2. Exception to Failure Translation Matrix

Data Sources throw typed low-level exceptions (`AppException` hierarchy). Repository implementations catch these and wrap them into `ApiResult.failure(Failure)`.

### Exception Hierarchy (`lib/core/error/exceptions.dart`)

| Exception | Description |
| :--- | :--- |
| `NetworkException` | No connectivity or timeout |
| `ServerException` | Server-side error (carries optional `statusCode`) |
| `UnauthorizedException` | 401 from server |
| `RefreshTokenExpiredException` | Refresh token is no longer valid |
| `StorageException` | Secure storage read/write failure |

### Failure Hierarchy (`lib/core/error/failures.dart`)

| Failure | Default Message |
| :--- | :--- |
| `ServerFailure` | "Server failure occurred" |
| `CacheFailure` | "Cache failure occurred" |
| `NetworkFailure` | "Network connection failed" |
| `UnauthorizedFailure` | "Unauthorized. Please log in again." |
| `SessionExpiredFailure` | "Your session has expired. Please log in again." |
| `UnknownFailure` | "An unexpected error occurred." |
| `ValidationFailure` | Custom message from server |

### HTTP Status Mapping (`handleDioError`)

| HTTP Status / Dio Error | Mapped Failure |
| :--- | :--- |
| 200 / 201 | `ApiResult.success(data)` |
| 400 Bad Request | `ValidationFailure(message)` |
| 401 Unauthorized | `ServerFailure('Unauthorized')` |
| 404 Not Found | `ServerFailure('Resource not found')` |
| 500 Internal Server Error | `ServerFailure('Internal server error')` |
| Connection Timeout | `NetworkFailure('Connection timed out')` |
| Connection Error | `NetworkFailure('No internet connection')` |
| SocketException | `NetworkFailure('No internet')` |

---

## 3. Repository Error Handling Standard

Repository implementations enforce the exception-to-failure boundary using `ApiResult<T>` (Freezed union):

```dart
@override
Future<ApiResult<UserEntity>> getUserProfile(String userId) async {
  try {
    final userModel = await remoteDataSource.getUserProfile(userId);
    return ApiResult.success(userModel.toEntity());
  } on ServerException catch (e) {
    return ApiResult.failure(ServerFailure(e.message));
  } on UnauthorizedException {
    return const ApiResult.failure(UnauthorizedFailure());
  } on NetworkException {
    return const ApiResult.failure(NetworkFailure());
  } catch (e) {
    return ApiResult.failure(UnknownFailure());
  }
}
```

### ApiResult Union (`lib/core/network/api_result.dart`)

```dart
@freezed
class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(Failure failure) = Error<T>;
}
```

Consume via pattern matching:
```dart
result.when(
  success: (data) => /* handle data */,
  failure: (failure) => /* handle failure */,
);
```

---

## 4. Dio Client Standards

- **Centralized Client:** All network calls use the shared `DioClient` (registered in GetIt). Never instantiate `Dio` directly in features.
- **Base URL:** Configured from `Config.baseUrl` (environment-specific).
- **Timeouts:** `connectTimeout: 15s`, `receiveTimeout: 15s`.
- **Response Type:** `ResponseType.json`.

### Interceptors

| Interceptor | Purpose |
| :--- | :--- |
| `LogInterceptor` | Logs requests, responses, and errors (debug mode) |
| `DioAuthInterceptor` | Attaches JWT Bearer token to outgoing headers (legacy) |
| `JwtInterceptor` | Single-flight token refresh with request queuing; handles session expiration |

---

## 5. API Endpoints (`lib/core/network/api_endpoints.dart`)

| Constant | Path | Feature |
| :--- | :--- | :--- |
| `login` | `/auth/login` | Auth |
| `profile` | `/auth/me` | Auth |
| `refreshToken` | `/auth/refresh` | Auth |
| `getProducts` | `/products` | Product |
| `addProduct` | `/products/add` | Product |
| `productCategories` | `/products/category-list` | Product |

---

## 6. Swagger / Code Generation

The project includes a `swagger.json` (DummyJSON Todos API) and a Dart-based generator at `generator/swagger_parser.dart`.

```bash
# Generate feature code from Swagger
make swagger-gen TAG=<tag> FILE=<output>
```

Inspect generator output before wiring generated features into DI and routing.
