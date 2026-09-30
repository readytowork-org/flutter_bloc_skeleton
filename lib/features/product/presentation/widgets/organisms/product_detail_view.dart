import 'package:flutter/material.dart';

import '../../../../../shared/widgets/molecules/bloc_state_builder.dart';
import '../../state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';
import '../molecules/product_detail_card.dart';

class ProductDetailView extends StatelessWidget {
  final String id;
  const ProductDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<GetProductByIdBloc, GetProductByIdState>(
      onLoaded: (context, state) {
        final product = (state as ProductLoaded).res;
        return ProductDetailCard(product: product);
      },
      onRetry: (bloc) =>
          bloc.add(GetProductByIdEvent.getProductByIdRequested(id: id)),
    );
  }
}
