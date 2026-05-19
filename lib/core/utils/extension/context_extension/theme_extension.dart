import 'package:flutter/material.dart';

extension BuildContextExtension<T> on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle? get displayMedium => textTheme.displayMedium;

  TextStyle? get displaySmall => textTheme.displaySmall;

  TextStyle? get headlineLarge => textTheme.headlineLarge;

  TextStyle? get headlineMedium => textTheme.headlineMedium;

  TextStyle? get titleLarge => textTheme.titleLarge;

  TextStyle? get titleMedium => textTheme.titleMedium;

  TextStyle? get titleSmall => textTheme.titleSmall;

  TextStyle? get labelLarge => textTheme.labelLarge;

  TextStyle? get bodySmall => textTheme.bodySmall;

  TextStyle? get bodyLarge => textTheme.bodyLarge;
}
