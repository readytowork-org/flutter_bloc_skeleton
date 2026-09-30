part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated({required UserEntity user}) =
      Authenticated;
  const factory AuthState.unauthenticated({String? message}) = Unauthenticated;
  const factory AuthState.failure({required String message}) = AuthFailure;
}
