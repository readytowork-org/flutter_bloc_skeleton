import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/bloc/base_pagination_bloc.dart' show PaginationFetch;
import '../../domain/entities/product_entity.dart';
import '../pages/add_product_page.dart';
import '../pages/edit_product_page.dart';
import '../pages/product_detail_page.dart';
import '../pages/product_page.dart' show ProductPage;
import '../state_management/add_product_bloc/add_product_bloc.dart';
import '../state_management/edit_product_bloc/edit_product_bloc.dart';
import '../state_management/get_all_products_bloc/product_pagination_bloc.dart'
    show ProductPaginationBloc;
import '../state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';
import '../state_management/get_product_category_bloc/get_product_category_bloc.dart';
import 'product_route_paths.dart';

/// Declares all GoRouter routes owned by the home feature.
abstract final class ProductRoutes {
  static List<RouteBase> get routes => [
    ShellRoute(
      builder: (context, state, child) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<ProductPaginationBloc>()),
          BlocProvider.value(value: sl<GetProductByIdBloc>()),
        ],
        child: child,
      ),
      routes: [
        GoRoute(
          path: ProductRoute.product.path,
          name: ProductRoute.product.routeName,
          builder: (BuildContext context, GoRouterState state) {
            final bloc = context.read<ProductPaginationBloc>();
            bloc.add(const PaginationFetch());
            return BlocProvider(
              create: (context) => sl<GetProductCategoryBloc>()
                ..add(
                  const GetProductCategoryEvent.getProductCategoryRequested(),
                ),
              child: const ProductPage(),
            );
          },
          routes: [
            GoRoute(
              path: ProductRoute.addProduct.path,
              builder: (BuildContext context, GoRouterState state) =>
                  BlocProvider(
                    create: (context) => sl<AddProductBloc>(),
                    child: const AddProductPage(),
                  ),
            ),
            GoRoute(
              path: ProductRoute.editProduct.path,
              builder: (BuildContext context, GoRouterState state) =>
                  BlocProvider(
                    create: (context) => sl<EditProductBloc>(),
                    child: EditProductPage(
                      product: state.extra as ProductEntity,
                    ),
                  ),
            ),
            GoRoute(
              path: ProductRoute.productDetail.path,
              builder: (BuildContext context, GoRouterState state) {
                final id = state.extra as int;
                return ProductDetailPage(id: id.toString());
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
