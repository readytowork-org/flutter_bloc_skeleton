import '../../domain/entities/product_category_entity.dart';

class ProductCategoryM {
  final String name;

  const ProductCategoryM({required this.name});

  factory ProductCategoryM.fromJson(String json) {
    return ProductCategoryM(name: json);
  }

  static List<ProductCategoryM> parseList(List<dynamic> response) {
    return response.map((e) => ProductCategoryM.fromJson(e as String)).toList();
  }

  ProductCategoryEntity toEntity() {
    return ProductCategoryEntity(name: name);
  }

  @override
  String toString() => name;
}
