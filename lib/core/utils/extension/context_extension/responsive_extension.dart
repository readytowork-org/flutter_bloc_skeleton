import 'package:flutter/material.dart';

extension BuildContextExtension<T> on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  Size get size => MediaQuery.of(this).size;

  bool get isMobile => width <= 500.0;

  bool get isTablet => width < 1024.0 && width >= 650.0;

  bool get isSmallTablet => width < 650.0 && width > 500.0;

  bool get isDesktop => width >= 1024.0;

  bool get isSmall => width < 850.0 && width >= 560.0;
}
