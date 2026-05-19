import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_skeleton/core/error/failures.dart';
import 'package:flutter_bloc_skeleton/core/network/api_result.dart';
import 'package:flutter_bloc_skeleton/core/utils/enum/index.dart';
import 'package:flutter_bloc_skeleton/features/product/domain/entities/product_entity.dart';
import 'package:flutter_bloc_skeleton/features/product/domain/usecases/get_all_product_usecase.dart';
import 'package:flutter_bloc_skeleton/features/product/presentation/state_management/get_all_products_bloc/product_pagination_bloc.dart';
import 'package:flutter_bloc_skeleton/shared/bloc/base_pagination_bloc.dart';
import 'package:flutter_bloc_skeleton/shared/models/pagination_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllProductsUseCase extends Mock implements GetAllProductsUseCase {}

void main() {
  late ProductPaginationBloc bloc;
  late MockGetAllProductsUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(PaginationParams(page: 1, pageSize: 20));
  });

  setUp(() {
    mockUseCase = MockGetAllProductsUseCase();
    bloc = ProductPaginationBloc(productUsecase: mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

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
    total: 10,
  );

  test('initial state should be correct', () {
    expect(bloc.state.status, PaginationStatus.initial);
    expect(bloc.state.data, isEmpty);
  });

  blocTest<ProductPaginationBloc, PaginationState<ProductEntity>>(
    'emits [loading, success] when fetchItems succeeds',
    build: () {
      when(() => mockUseCase.call(any()))
          .thenAnswer((_) async => ApiResult.success(tProductResponseEntity));
      return bloc;
    },
    act: (bloc) => bloc.add(const PaginationFetch()),
    expect: () => [
      const PaginationState<ProductEntity>(status: PaginationStatus.loading),
      PaginationState<ProductEntity>(
        status: PaginationStatus.success,
        data: tProductResponseEntity.products,
        hasReachedMax: false,
      ),
    ],
    verify: (_) {
      verify(() => mockUseCase.call(any())).called(1);
    },
  );

  blocTest<ProductPaginationBloc, PaginationState<ProductEntity>>(
    'emits [loading, failure] when fetchItems fails',
    build: () {
      when(() => mockUseCase.call(any()))
          .thenAnswer((_) async => const ApiResult<ProductResponseEntity>.failure(ServerFailure('Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(const PaginationFetch()),
    expect: () => [
      const PaginationState<ProductEntity>(status: PaginationStatus.loading),
      const PaginationState<ProductEntity>(
        status: PaginationStatus.failure,
        error: 'Error',
      ),
    ],
  );
}
