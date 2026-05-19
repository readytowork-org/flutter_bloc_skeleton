import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;
  final double aspectRatio;
  final BoxFit fit;
  final double? width;
  final double? height;
  const ImageView({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 1,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.greyLight,
          child: const Icon(
            Icons.broken_image_outlined,
            size: 40,
            color: AppColors.greyDark,
          ),
        ),
      ),
    );
  }
}
