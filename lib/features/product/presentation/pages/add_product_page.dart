import 'package:flutter/material.dart';

import '../widgets/organisms/add_product_view.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: const AddProductView(),
    );
  }
}
