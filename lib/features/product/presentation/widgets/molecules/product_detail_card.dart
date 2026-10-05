import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/extension/context_extension/theme_extension.dart'
    show BuildContextExtension;
import '../../../../../shared/widgets/atoms/image_view.dart';
import '../../../domain/entities/product_entity.dart';
import '../../routes/product_route_paths.dart';
import '../atoms/product_rating_bar.dart';
import '../atoms/product_tag.dart';

class ProductDetailCard extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Stack(
            children: [
              ImageView(
                aspectRatio: 1.2,
                imageUrl: product.thumbnail,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              Positioned(
                top: 16,
                right: 16,
                child: ProductTag(tag: product.brand, fontSize: 14),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                ProductTag(
                  tag: product.category,
                  decorationColor: AppColors.black.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 8),
                Text(
                  product.title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                ProductRatingBar(rating: product.rating, size: 20),
                const SizedBox(height: 16),

                Text(
                  'Rs.${product.price.toStringAsFixed(2)}',
                  style: context.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: .w700,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Description",
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: context.bodyLarge?.copyWith(
                    color: AppColors.greyDark,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const .symmetric(horizontal: 20, vertical: 40),
            child: ElevatedButton(
              onPressed: () {
                context.push(ProductRoute.editProduct.path, extra: product);
              },
              child: const Text(
                "Edit Product",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
