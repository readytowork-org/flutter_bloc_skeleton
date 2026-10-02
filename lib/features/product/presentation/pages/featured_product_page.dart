import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';

class FeaturedProductPage extends StatefulWidget {
  const FeaturedProductPage({super.key});

  @override
  State<FeaturedProductPage> createState() => _FeaturedProductPageState();
}

class _FeaturedProductPageState extends State<FeaturedProductPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<GetProductByIdBloc>();
    bloc.add(
      GetProductByIdRequested(id: '1'),
    ); // Replace '1' with the actual featured product ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Featured Product")),
      body: Center(
        child: BlocBuilder<GetProductByIdBloc, GetProductByIdState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const CircularProgressIndicator();
            } else if (state is ProductInitial) {
              return Text('Loading...');
            } else if (state is ProductFailure) {
              return Text('Error: ${state.message}');
            } else if (state is ProductLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.res.title),
                  Text('\$${state.res.price.toStringAsFixed(2)}'),
                ],
              );
            } else if (state is ProductEmpty) {
              return const Text('No product found');
            }
            return const Text('Unknown state');
          },
        ),
      ),
    );
  }
}
