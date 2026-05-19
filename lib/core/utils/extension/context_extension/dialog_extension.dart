import 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        ScaffoldFeatureController,
        ScaffoldMessenger,
        SnackBar,
        SnackBarBehavior,
        SnackBarClosedReason,
        Text,
        Widget,
        Wrap,
        showModalBottomSheet;

extension BuildContextExtension<T> on BuildContext {
  Future<T?> showBottomSheet(
    Widget child, {
    bool isScrollControlled = true,
    Color? backgroundColor,
    Color? barrierColor,
  }) {
    return showModalBottomSheet(
      context: this,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: (context) => Wrap(children: [child]),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message,
  ) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
