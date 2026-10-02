import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:go_router/go_router.dart';

import '../../../../../shared/bloc/base_pagination_bloc.dart'
    show PaginationState;
import '../../../../../shared/widgets/organisms/bloc_pagination_view.dart';
import '../../../domain/entities/product_entity.dart';
import '../../routes/product_route_paths.dart';
import '../../state_management/get_all_products_bloc/product_pagination_bloc.dart';

import '../molecules/product_card.dart';
import '../molecules/product_category.dart';
import '../molecules/product_count_banner.dart';
import '../molecules/product_search_bar.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: .all(8),
          margin: .only(bottom: 10),
          color: Colors.white,
          child: Column(
            spacing: 10,
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              BlocBuilder<
                ProductPaginationBloc,
                PaginationState<ProductEntity>
              >(
                builder: (context, state) {
                  return ProductCountBanner(
                    message: 'Products: ${state.data.length}',
                  );
                },
              ),

              ProductSearchBar(),
              ProductCategory(),
            ],
          ),
        ),
        Expanded(
          child: BlocPaginationView<ProductEntity, ProductPaginationBloc>(
            padding: const EdgeInsets.symmetric(horizontal: 8),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.59,
            ),
            showDivider: false,
            onPageLoaded: (page, data) {
              debugPrint("Page $page loaded with ${data.length} items");
            },
            itemBuilder: (context, data) {
              return ProductCard(
                product: data,
                onTap: () {
                  context.go(ProductRoute.productDetail.path, extra: data.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
