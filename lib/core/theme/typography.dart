import 'package:flutter/material.dart'
    show FontStyle, FontWeight, TextLeadingDistribution, TextStyle;

import 'app_colors.dart' show AppColors;

base class Typography {
  final bool isDarkMode;
  Typography({required this.isDarkMode});

  TextStyle get displayLarge => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.w700,
    fontSize: 36,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get displayMedium => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.w400,
    fontSize: 32,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get displaySmall => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.normal,
    fontSize: 28,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get titleLarge => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get titleMedium => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.w400,
    fontSize: 22,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get titleSmall => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.normal,
    fontSize: 20,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get bodyLarge => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get bodyMedium => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get bodySmall => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.normal,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelLarge => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelMedium => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelSmall => TextStyle(
    color: isDarkMode ? AppColors.white : AppColors.black,
    fontWeight: FontWeight.normal,
    fontSize: 10,
    fontStyle: FontStyle.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );
}
