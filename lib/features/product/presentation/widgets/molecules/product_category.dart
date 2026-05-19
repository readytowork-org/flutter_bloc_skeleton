import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/bloc/base_pagination_bloc.dart';
import '../../../../../shared/widgets/molecules/bloc_state_builder.dart';
import '../../state_management/get_all_products_bloc/product_pagination_bloc.dart';
import '../../state_management/get_product_category_bloc/get_product_category_bloc.dart';
import '../atoms/category_chip.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({super.key});

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  String _selectedCategory = "All";
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });

    final bloc = context.read<ProductPaginationBloc>();
    bloc.params
      ..skip = 0
      ..page = 1
      ..filter = "category/$category";

    bloc.add(const PaginationRefresh());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: BlocStateBuilder<GetProductCategoryBloc, GetProductCategoryState>(
        onLoaded: (context, state) {
          final categories = (state as ProductCategoryLoaded).res;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryChip(
                label: category.name.toUpperCase(),
                isSelected: _selectedCategory == category.name,
                onTap: () => _onCategorySelected(category.name),
              );
            },
          );
        },
        onRetry: (bloc) =>
            bloc.add(GetProductCategoryEvent.getProductCategoryRequested()),
      ),
    );
  }
}
