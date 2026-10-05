import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../profile/presentation/routes/profile_route_paths.dart';
import '../routes/product_route_paths.dart';

import '../widgets/organisms/product_view.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Page"),
        actions: [
          IconButton(
            onPressed: () async {
              context.push(ProfileRoute.profile.path);
            },
            icon: const Icon(Icons.person_2_outlined),
          ),
        ],
      ),
      body: ProductView(),

      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          context.push(ProductRoute.addProduct.path);
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
