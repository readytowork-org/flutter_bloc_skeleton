Here is the docs/knowledge/API_SPEC.md document outlining network integration rules, DTO mapping pipelines, exception translation, and network standards for your Flutter + BLoC + Clean Architecture application.

docs/knowledge/API_SPEC.md

# API Specification & Data Integration Standards

This document outlines the contracts, response mappings, exception handling, and Dio client configurations for integrating backend REST endpoints into the application.

---

## 1. DTO to Domain Entity Mapping Pipeline

Raw JSON network responses must **never** leak directly into the Domain or Presentation layers. All network payloads must be deserialized into Data Transfer Objects (DTO Models) in the Data layer and mapped explicitly into Domain Entities.



HTTP Response (JSON) ──► DTO Model (fromJson) ──► .toEntity() ──► Domain Entity


### Standard Model Rule
- Every Data Model class must live under `lib/features/[feature]/data/models/`.
- Models must provide a `toEntity()` method to convert the DTO to a pure Domain Entity.
- Models must provide a `fromEntity(Entity)` factory or method when sending payloads back to the server.

```dart
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        firstName: firstName,
      );
}


2. Exception to Failure Translation Matrix

Data Sources must throw typed low-level exceptions (e.g., ServerException, NetworkException). Repository Implementations catch these exceptions and wrap them into user-safe Domain Failure instances returning Either<Failure, T>.

HTTP Status / Network Event	Data Exception	Mapped Domain Failure
200 / 201	None (Success)	Right(Entity)
400 Bad Request	ServerException(message)	ValidationFailure(message)
401 Unauthorized	UnauthorizedException()	UnauthorizedFailure()
403 Forbidden	ForbiddenException()	ForbiddenFailure()
404 Not Found	NotFoundException()	NotFoundFailure()
500 Internal Server Error	ServerException()	ServerFailure()
Connection Timeout / Offline	NetworkException()	NetworkFailure()
Storage Read/Write Fail	CacheException()	CacheFailure()

3. Repository Error Handling Standard

Repository implementations must enforce the exception-to-failure boundary using functional returns (Either<Failure, T>):

@override
Future<Either<Failure, UserEntity>> getUserProfile(String userId) async {
  try {
    final userModel = await remoteDataSource.getUserProfile(userId);
    return Right(userModel.toEntity());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on UnauthorizedException {
    return const Left(UnauthorizedFailure('Session expired. Please log in again.'));
  } on NetworkException {
    return const Left(NetworkFailure('No internet connection. Please check your network.'));
  } catch (e) {
    return Left(UnexpectedFailure(e.toString()));
  }
}


4. Dio Client Standards

⚬ Centralized Client: All network calls must use the shared Dio instance provided by dependency injection (get_it).
⚬ Interceptors:
  ⚬ AuthInterceptor: Automatically attaches JWT Bearer tokens to outgoing headers.
  ⚬ LoggingInterceptor: Logs requests, responses, and errors in debug mode only.
⚬ Timeouts:
  ⚬ connectTimeout: 10 seconds.
  ⚬ receiveTimeout: 15 seconds.