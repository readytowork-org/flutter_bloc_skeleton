import 'package:flutter/widgets.dart';

class ProductCountBanner extends StatelessWidget {
  final String message;

  const ProductCountBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
