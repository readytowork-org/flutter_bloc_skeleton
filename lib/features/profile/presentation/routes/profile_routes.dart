import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../pages/profile_page.dart' show ProfilePage;
import '../state_management/get_profile_bloc/get_profile_bloc.dart';
import 'profile_route_paths.dart';

/// Declares all GoRouter routes owned by the profile feature.
abstract final class ProfileRoutes {
  static List<GoRoute> get routes => [
    GoRoute(
      path: ProfileRoute.profile.path,
      name: ProfileRoute.profile.routeName,
      builder: (BuildContext context, GoRouterState state) => BlocProvider(
        create: (context) => sl<GetProfileBloc>()..add(GetProfileRequested()),
        child: const ProfilePage(),
      ),
    ),
  ];
}
