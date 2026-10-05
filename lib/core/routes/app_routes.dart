import 'package:flutter/material.dart' show GlobalKey, NavigatorState;
import 'package:go_router/go_router.dart' show GoRouter, RoutingConfig;

import '../../features/auth/auth.dart' show AuthRoutes;
import '../../features/cart/cart.dart' show CartRoutes;
import '../../../shared/widgets/organisms/page_not_found.dart'
    show PageNotFoundView;
import '../../features/product/presentation/routes/product_routes.dart'
    show ProductRoutes;
import '../../features/profile/presentation/routes/profile_routes.dart';
import 'app_route_config.dart' show ConstantRoutingConfig;
import 'app_route_redirect.dart' show AppRouterRedirect;

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter extends GoRouter {
  AppRouter({
    super.refreshListenable,
    super.observers,
    super.debugLogDiagnostics,
    super.errorPageBuilder,
    super.extraCodec,
    super.initialExtra,
    super.navigatorKey,
    super.initialLocation,
    super.onException,
    super.overridePlatformDefaultLocation,
    super.requestFocus,
    super.restorationScopeId,
    super.routerNeglect,
  }) : super.routingConfig(
         routingConfig: ConstantRoutingConfig(
           RoutingConfig(
             redirect: AppRouterRedirect.redirect,
             routes: [
               ...AuthRoutes.routes,
               ...ProfileRoutes.routes,
               ...ProductRoutes.routes,
               ...CartRoutes.routes,
             ],
           ),
         ),
         errorBuilder: (context, state) => const PageNotFoundView(),
       );
}
