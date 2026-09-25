part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  const factory AuthEvent.signUpRequested({required JsonMap userMap}) =
      SignUpRequested;
  const factory AuthEvent.loginRequested({required JsonMap userMap}) =
      LoginRequested;
  const factory AuthEvent.logoutRequested() = LogoutRequested;
  const factory AuthEvent.appStarted() = AppStarted;

  @override
  List<Object?> get props => [];
}

final class SignUpRequested extends AuthEvent {
  const SignUpRequested({required this.userMap});

  final JsonMap userMap;

  @override
  List<Object?> get props => [userMap];
}

final class LoginRequested extends AuthEvent {
  const LoginRequested({required this.userMap});

  final JsonMap userMap;

  @override
  List<Object?> get props => [userMap];
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

final class AppStarted extends AuthEvent {
  const AppStarted();
}
