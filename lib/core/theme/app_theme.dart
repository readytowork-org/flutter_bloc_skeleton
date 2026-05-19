import 'package:flutter/material.dart' show ThemeData;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

import 'dark_theme.dart';
import 'light_theme.dart';

class AppTheme extends Cubit<ThemeData> {
  AppTheme() : super(LightTheme.instance.light);

  void switchTheme([bool darkMode = false]) {
    emit(darkMode ? DarkTheme.instance.dark : LightTheme.instance.light);
  }
}
