import 'dart:async' show FutureOr;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:go_router/go_router.dart' show GoRouterState;

import '../../features/auth/presentation/routes/auth_route_paths.dart'
    show AuthRoute;

import '../../features/product/presentation/routes/product_route_paths.dart'
    show ProductRoute;

class AppRouterRedirect {
  static final authPages = {AuthRoute.login.path, AuthRoute.register.path};

  static FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    final isAuthPage = authPages.contains(location);

    // 1. Check Firebase SDK directly for current authentication state
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final bool isFirebaseAuthenticated = firebaseUser != null;

    // 2. Not authenticated and trying to access a protected page -> Force Login
    if (!isFirebaseAuthenticated && !isAuthPage) {
      return AuthRoute.login.path;
    }

    // 3. Authenticated and trying to access an auth page (like login/register) -> Redirect to Home
    if (isFirebaseAuthenticated && isAuthPage) {
      return ProductRoute.product.path;
    }

    // No redirection needed
    return null;
  }
}
