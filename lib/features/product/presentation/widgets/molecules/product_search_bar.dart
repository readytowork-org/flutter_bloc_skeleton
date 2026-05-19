import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/bloc/base_pagination_bloc.dart';
import '../../../../../shared/widgets/atoms/search_bar.dart';
import '../../state_management/get_all_products_bloc/product_pagination_bloc.dart';

class ProductSearchBar extends StatefulWidget {
  const ProductSearchBar({super.key});

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final bloc = context.read<ProductPaginationBloc>();
      bloc.params
        ..skip = 0
        ..page = 1
        ..filter = "Search?q=$query";
      bloc.add(const PaginationRefresh());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchInputBar(onChanged: _onSearchChanged);
  }
}
