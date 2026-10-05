enum ProfileRoute {
  profile;

  String get path => switch (this) {
    ProfileRoute.profile => '/profile',
  };

  String get routeName => switch (this) {
    ProfileRoute.profile => 'Profile',
  };
}
