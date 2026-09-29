part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signUpRequested({required JsonMap userMap}) =
      SignUpRequested;

  const factory AuthEvent.loginRequested({required JsonMap userMap}) =
      LoginRequested;

  const factory AuthEvent.forgotPasswordRequested({required String email}) =
      ForgotPasswordRequested;

  const factory AuthEvent.logoutRequested() = LogoutRequested;

  const factory AuthEvent.appStarted() = AppStarted;
}
