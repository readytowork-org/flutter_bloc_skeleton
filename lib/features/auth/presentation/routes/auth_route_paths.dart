/// Auth feature route segments and names. Keeps navigation constants inside the feature.
enum AuthRoute {
  login,
  register,
  forgotPassword;

  String get path => switch (this) {
    AuthRoute.login => '/login',
    AuthRoute.register => '/register',
    AuthRoute.forgotPassword => '/forgot-password',
  };

  String get routeName => switch (this) {
    AuthRoute.login => 'Login',
    AuthRoute.register => 'Register',
    AuthRoute.forgotPassword => 'ForgotPassword',
  };
}
