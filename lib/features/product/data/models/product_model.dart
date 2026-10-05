import '../../../../core/utils/strings/index.dart';
import '../../../../core/utils/typedf/index.dart';
import '../../domain/entities/product_entity.dart';

class ProductResponseM {
  final List<ProductM> data;
  final int count;

  ProductResponseM({required this.data, required this.count});

  factory ProductResponseM.fromJson(JsonMap json) {
    return ProductResponseM(
      data: ProductM.parseList(json['products']),
      count: json['total'],
    );
  }
}

class ProductM {
  final int id;
  final String title;
  final String description;
  final double price;
  final String brand;
  final String category;
  final double rating;
  final String thumbnail;

  ProductM({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.price,
    required this.brand,
    required this.category,
    required this.rating,
  });

  factory ProductM.fromJson(JsonMap json) {
    return ProductM(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      price: json['price'],
      brand: json['brand'] ?? emptyString,
      category: json['category'],
      rating: json['rating'],
    );
  }

  JsonMap toJson() {
    return {
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'price': price,
      'brand': brand,
      'category': category,
      'rating': rating,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      description: description,
      thumbnail: thumbnail,
      price: price,
      brand: brand,
      category: category,
      rating: rating,
    );
  }

  static List<ProductM> parseList(Iterable data) =>
      List<ProductM>.from(data.map((res) => ProductM.fromJson(res)));
}
