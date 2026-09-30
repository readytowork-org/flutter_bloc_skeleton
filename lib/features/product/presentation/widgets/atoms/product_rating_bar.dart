import 'package:flutter/material.dart';

class ProductRatingBar extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  const ProductRatingBar({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxStars, (index) {
        final starValue = index + 1;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, color: Colors.amber, size: size);
      }),
    );
  }
}
