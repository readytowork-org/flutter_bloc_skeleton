---
name: api
description: Implement or update Dio API endpoints, DTO serialization, data sources, repository entity mapping, and failure handling in this Flutter app.
---

# Skill Playbook: /api

Use this playbook for API contract changes. Read the affected feature, `lib/core/network/api_endpoints.dart`, and the API specification when supplied. Confirm method, path, authentication, request body, response shape, and expected errors before editing. API responses become data models first, then domain entities via `toEntity()`. Keep Dio and DTOs out of BLoCs and new domain code.

## 1. DTO models — `lib/features/<feature>/data/models/`

Use the neighboring feature's `@freezed`, `@JsonSerializable`, or manual model style. Implement `fromJson`/`toJson` as needed and explicit `toEntity()`/`fromEntity()` mappings for used directions. Do not make domain entities parse raw JSON.

## 2. Data sources — `lib/features/<feature>/data/datasources/`

Define a contract and concrete implementation using the existing `DioClient` and `ApiEndpoints`. Decode responses into models. A data source may throw Dio or the existing `ServerException`, `UnauthorizedException`, or `NetworkException`; choose one boundary consistently with the feature's repository.

## 3. Repository implementation — `lib/features/<feature>/data/repository/` or `repositories/`

Implement the domain interface returning `Future<ApiResult<T>>`, not `Either`. Catch expected transport or app exceptions at this boundary and map them to the existing `Failure` types. For Dio, use `handleDioError` from `lib/core/error/failures.dart`; return `ApiResult.failure(...)`. Return `ApiResult.success(model.toEntity())` after successful decoding. Never let raw `DioException` escape to presentation.

## 4. Generation and validation

Run `make generate` when Freezed/JSON inputs change and review generated files. Add focused tests for JSON fixtures, request mapping, entity conversion, and failure mapping. Run affected tests, formatting, and `flutter analyze`. For a Swagger-driven change, use `make swagger-gen TAG=<tag> FILE=<swagger.json>` only after checking the tag and output location.
