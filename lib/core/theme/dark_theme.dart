import 'package:flutter/material.dart' show Brightness, ThemeData;

import 'typography.dart';

base class DarkTheme extends Typography {
  DarkTheme._() : super(isDarkMode: true);
  static DarkTheme get instance => DarkTheme._();
  ThemeData get dark {
    return ThemeData(useMaterial3: true, brightness: Brightness.dark);
  }
}
