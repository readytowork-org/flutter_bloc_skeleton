import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';

import '../widgets/organisms/product_detail_view.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;
  const ProductDetailPage({super.key, required this.id});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    final bloc = context.read<GetProductByIdBloc>();
    bloc.add(GetProductByIdRequested(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: ProductDetailView(id: widget.id),
    );
  }
}
