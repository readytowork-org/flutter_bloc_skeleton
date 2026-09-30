import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/login_page.dart';
import '../pages/register_page.dart';
import 'auth_route_paths.dart';

/// Declares all GoRouter routes owned by the auth feature.
abstract final class AuthRoutes {
  static List<GoRoute> get routes => [
    GoRoute(
      path: AuthRoute.login.path,
      name: AuthRoute.login.routeName,
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
    GoRoute(
      path: AuthRoute.register.path,
      name: AuthRoute.register.routeName,
      builder: (BuildContext context, GoRouterState state) =>
          const RegisterPage(),
    ),
  ];
}
