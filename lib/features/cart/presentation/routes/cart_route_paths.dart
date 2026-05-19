/// Cart feature route segments and names.
enum CartRoute {
  cart;

  String get path => switch (this) {
    CartRoute.cart => '/cart',
  };

  String get routeName => switch (this) {
    CartRoute.cart => 'Cart',
  };
}
