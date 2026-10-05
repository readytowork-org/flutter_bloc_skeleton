import 'dart:async' show FutureOr;

import 'package:flutter/material.dart' show BuildContext;
import 'package:go_router/go_router.dart' show GoRouterState;

import '../../features/auth/presentation/routes/auth_route_paths.dart'
    show AuthRoute;
import '../../features/auth/presentation/state_management/auth_bloc.dart'
    show AuthBloc, AuthInitial, AuthLoading, Authenticated;
import '../../features/product/presentation/routes/product_route_paths.dart'
    show ProductRoute;
import '../di/service_locator.dart' show sl;
import '../storage/token_storage.dart' show TokenStorage;

class AppRouterRedirect {
  static final authPages = {
    AuthRoute.login.path,
    AuthRoute.register.path,
    AuthRoute.forgotPassword.path,
  };

  static FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final authState = sl<AuthBloc>().state;
    final location = state.matchedLocation;

    final isAuthPage = authPages.contains(location);

    final loggingIn = location == AuthRoute.login.path;

    final bool isAuthenticated = authState is Authenticated;

    final token = sl<TokenStorage>().accessToken;

    /// App booting or loading
    if (authState is AuthInitial || authState is AuthLoading) {
      if (token == null &&
          !authPages.contains(location) &&
          location != AuthRoute.login.path) {
        return AuthRoute.login.path;
      }
      return null;
    }

    /// Not authenticated and trying to access a protected page
    if (!isAuthenticated && !isAuthPage) {
      return AuthRoute.login.path;
    }

    /// Authenticated and trying to access an auth page (like login)
    if (isAuthenticated && loggingIn) {
      return ProductRoute.product.path;
    }

    return null;
  }
}
