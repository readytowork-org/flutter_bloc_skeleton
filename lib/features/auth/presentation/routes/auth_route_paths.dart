/// Auth feature route segments and names. Keeps navigation constants inside the feature.
enum AuthRoute {
  login,
  register;

  String get path => switch (this) {
    AuthRoute.login => '/login',
    AuthRoute.register => '/register',
  };

  String get routeName => switch (this) {
    AuthRoute.login => 'Login',
    AuthRoute.register => 'Register',
  };
}
