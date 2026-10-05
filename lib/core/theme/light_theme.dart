import 'package:flutter/material.dart'
    show
        AppBarTheme,
        BorderRadius,
        BorderSide,
        Brightness,
        ButtonStyle,
        ColorScheme,
        Colors,
        ElevatedButtonThemeData,
        IconThemeData,
        InputDecorationTheme,
        OutlineInputBorder,
        OutlinedButtonThemeData,
        ProgressIndicatorThemeData,
        RoundedRectangleBorder,
        Size,
        TextStyle,
        TextTheme,
        ThemeData,
        WidgetStatePropertyAll;

import 'app_colors.dart';
import 'typography.dart';

base class LightTheme extends Typography {
  LightTheme._() : super(isDarkMode: false);
  static LightTheme get instance => LightTheme._();
  ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: AppColors.primary,
      scaffoldBackgroundColor: Colors.white.withValues(alpha: 0.97),
      cardColor: AppColors.white,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.white,
        onPrimary: AppColors.primary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.error,
        surface: AppColors.white,
        onSurface: AppColors.black,
      ),
      textTheme: TextTheme(displayLarge: displayLarge),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.black,
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          fixedSize: const WidgetStatePropertyAll(Size.fromHeight(45)),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.black),
          side: WidgetStatePropertyAll(BorderSide(color: AppColors.primary)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ),
    );
  }
}
