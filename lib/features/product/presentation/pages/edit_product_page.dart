import 'package:flutter/material.dart';

import '../../domain/entities/product_entity.dart';
import '../widgets/organisms/edit_product_view.dart';

class EditProductPage extends StatelessWidget {
  final ProductEntity product;
  const EditProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: EditProductView(initialData: product),
    );
  }
}
