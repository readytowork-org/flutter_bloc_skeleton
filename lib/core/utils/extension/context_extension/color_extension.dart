import 'package:flutter/material.dart';

extension BuildContextExtension<T> on BuildContext {
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorScheme => themeData.colorScheme;

  Color get primaryColor => themeData.primaryColor;

  Color get primaryColorDark => themeData.primaryColorDark;

  Color get primaryColorLight => themeData.primaryColorLight;

  Color get cardColor => themeData.cardColor;

  Color get primary => colorScheme.primary;

  Color get onPrimary => colorScheme.onPrimary;

  Color get secondary => colorScheme.secondary;

  Color get onSecondary => colorScheme.onSecondary;

  Color get errorColor => colorScheme.error;

  Color get background => colorScheme.surface;
}
