import 'package:flutter_bloc_skeleton/core/error/failures.dart';
import 'package:flutter_bloc_skeleton/core/network/api_result.dart';
import 'package:flutter_bloc_skeleton/features/product/domain/entities/product_entity.dart';
import 'package:flutter_bloc_skeleton/features/product/domain/repository/product_repository.dart';
import 'package:flutter_bloc_skeleton/features/product/domain/usecases/get_all_product_usecase.dart';
import 'package:flutter_bloc_skeleton/shared/models/pagination_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetAllProductsUseCase usecase;
  late MockProductRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(PaginationParams(page: 1, pageSize: 20));
  });

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = GetAllProductsUseCase(repository: mockRepository);
  });

  final tPaginationParams = PaginationParams(page: 1, pageSize: 20);
  final tProductResponseEntity = ProductResponseEntity(
    products: [
      ProductEntity(
        id: 1,
        title: 'Test Product',
        description: 'Description',
        price: 100.0,
        thumbnail: '',
        brand: 'Brand',
        category: 'Electronics',
        rating: 4.5,
      ),
    ],
    total: 1,
  );

  test('should get products from the repository', () async {
    // arrange
    when(() => mockRepository.getAllProducts(any()))
        .thenAnswer((_) async => ApiResult.success(tProductResponseEntity));

    // act
    final result = await usecase.call(tPaginationParams);

    // assert
    expect(result, ApiResult.success(tProductResponseEntity));
    verify(() => mockRepository.getAllProducts(tPaginationParams)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    const tFailure = ServerFailure('Server Error');
    when(() => mockRepository.getAllProducts(any()))
        .thenAnswer((_) async => const ApiResult.failure(tFailure));

    // act
    final result = await usecase.call(tPaginationParams);

    // assert
    expect(result, const ApiResult<ProductResponseEntity>.failure(tFailure));
    verify(() => mockRepository.getAllProducts(tPaginationParams)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
