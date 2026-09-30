import 'package:equatable/equatable.dart';
import '../../../../core/utils/typedf/index.dart';
import '../../data/models/product_model.dart';

class ProductResponseEntity extends Equatable {
  final List<ProductEntity> products;
  final int total;

  const ProductResponseEntity({required this.products, required this.total});

  @override
  List<Object?> get props => [products, total];
}

class ProductEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final double price;
  final String brand;
  final String category;
  final double rating;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.price,
    required this.brand,
    required this.category,
    required this.rating,
  });

  JsonMap toRequest() {
    return {'title': title, 'description': description};
  }

  static List<ProductEntity> parseList(List<ProductM> data) =>
      List<ProductEntity>.from(data.map((res) => res.toEntity()));

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    thumbnail,
    price,
    brand,
    category,
    rating,
  ];
}
