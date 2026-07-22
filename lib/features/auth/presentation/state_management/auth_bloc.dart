import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/typedf/index.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({required AuthRepository repository})
    : _repository = repository,
      super(const AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AppStarted>(_onAppStarted);
    add(AppStarted());
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _repository.login(
      event.userMap['username'],
      event.userMap['password'],
    );

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
    final result = await _repository.signUp(
      event.userMap['fullName'],
      event.userMap['email'],
      event.userMap['password'],
    );

    result.when(
      success: (user) => emit(Authenticated(user: user)),
      failure: (failure) => emit(AuthFailure(message: failure.message)),
    );
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _repository.logout();
    result.when(
      success: (message) => emit(Unauthenticated(message: message)),
      failure: (failure) => emit(AuthFailure(message: failure.message)),
    );
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final result = await _repository.getCurrentSession();
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
