import 'package:equatable/equatable.dart';

import '../../data/models/product_category_model.dart';

class ProductCategoryEntity extends Equatable {
  final String name;

  const ProductCategoryEntity({required this.name});

  static List<ProductCategoryEntity> parseList(List<ProductCategoryM> data) =>
      List<ProductCategoryEntity>.from(data.map((res) => res.toEntity()));

  @override
  List<Object?> get props => [name];
}
