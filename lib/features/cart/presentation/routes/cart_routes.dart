import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/cart_page.dart';
import 'cart_route_paths.dart';

abstract final class CartRoutes {
  static List<GoRoute> get routes => [
    GoRoute(
      path: CartRoute.cart.path,
      name: CartRoute.cart.routeName,
      builder: (BuildContext context, GoRouterState state) => const CartPage(),
    ),
  ];
}
