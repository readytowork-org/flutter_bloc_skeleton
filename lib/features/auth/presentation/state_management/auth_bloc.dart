import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/utils/typedf/index.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/session_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final SignupUseCase _signupUseCase;
  final SessionUseCase _sessionUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required SignupUseCase signupUseCase,
    required SessionUseCase sessionUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _signupUseCase = signupUseCase,
       _sessionUseCase = sessionUseCase,
       _logoutUseCase = logoutUseCase,
       super(const AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AppStarted>(_onAppStarted);
    add(AppStarted());
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _forgotPasswordUseCase(event.email);

    result.when(
      success: (message) => emit(PasswordResetRequested(message: message)),
      failure: (failure) => emit(AuthFailure(message: failure.message)),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(event.userMap);

    result.when(
      success: (user) => emit(Authenticated(user: user)),
      failure: (failure) => emit(AuthFailure(message: failure.message)),
    );
  }

  void _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signupUseCase(event.userMap);

    result.when(
      success: (user) => emit(Authenticated(user: user)),
      failure: (failure) => emit(AuthFailure(message: failure.message)),
    );
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _logoutUseCase();
    result.when(
      success: (message) => emit(Unauthenticated(message: message)),
      failure: (failure) => emit(AuthFailure(message: failure.message)),
    );
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final result = await _sessionUseCase();
    result.when(
      success: (token) => emit(
        Authenticated(
          user: UserEntity(
            accessToken: token.accessToken,
            refreshToken: token.refreshToken,
          ),
        ),
      ), // You might want to fetch user details using the token
      failure: (failure) => emit(const Unauthenticated()),
    );
  }
}
