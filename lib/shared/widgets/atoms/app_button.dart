import 'package:flutter/material.dart';

import '../../../core/utils/index.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final Color? color;
  final bool isFullWidth;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.elevated,
    this.icon,
    this.color,
    this.isFullWidth = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = switch (variant) {
      ButtonVariant.elevated =>
        icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                label: Text(label),
                icon: Icon(icon),
              ).withLoading(loading)
            : ElevatedButton(
                onPressed: onPressed,
                child: Text(label),
              ).withLoading(loading),

      ButtonVariant.outlined =>
        icon != null
            ? OutlinedButton.icon(
                onPressed: onPressed,
                label: Text(label),
                icon: Icon(icon),
              ).withLoading(loading)
            : OutlinedButton(
                onPressed: onPressed,
                child: Text(label),
              ).withLoading(loading),

      ButtonVariant.text =>
        icon != null
            ? TextButton.icon(
                onPressed: onPressed,
                label: Text(label),
                icon: Icon(icon),
              ).withLoading(loading)
            : TextButton(
                onPressed: onPressed,
                child: Text(label),
              ).withLoading(loading),
    };

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
