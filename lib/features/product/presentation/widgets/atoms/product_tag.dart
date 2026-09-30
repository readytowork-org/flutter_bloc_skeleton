import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/extension/context_extension/theme_extension.dart'
    show BuildContextExtension;

class ProductTag extends StatelessWidget {
  final String tag;
  final Color? decorationColor;
  final double? fontSize;
  const ProductTag({
    super.key,
    required this.tag,
    this.decorationColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: decorationColor ?? AppColors.primary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag.toUpperCase(),
        style: context.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
