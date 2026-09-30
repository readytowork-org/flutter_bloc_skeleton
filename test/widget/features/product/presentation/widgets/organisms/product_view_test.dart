import 'package:flutter/material.dart';
import 'package:flutter_bloc_skeleton/features/product/domain/entities/product_entity.dart';
import 'package:flutter_bloc_skeleton/features/product/domain/entities/product_category_entity.dart';
import 'package:flutter_bloc_skeleton/features/product/presentation/state_management/get_product_category_bloc/get_product_category_bloc.dart';
import 'package:flutter_bloc_skeleton/features/product/presentation/widgets/organisms/product_view.dart';
import 'package:flutter_bloc_skeleton/shared/bloc/base_pagination_bloc.dart';
import 'package:flutter_bloc_skeleton/core/utils/enum/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../../../../../helpers/test_helpers.dart';

void main() {
  setUpAll(() {
    registerAuthFallbacks();
  });

  late MockProductPaginationBloc mockProductBloc;
  late MockGetProductCategoryBloc mockCategoryBloc;

  setUp(() {
    mockProductBloc = MockProductPaginationBloc();
    mockCategoryBloc = MockGetProductCategoryBloc();

    when(() => mockProductBloc.state).thenReturn(
      const PaginationState<ProductEntity>(status: PaginationStatus.initial),
    );
    when(() => mockProductBloc.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockCategoryBloc.state).thenReturn(
      const GetProductCategoryState.loaded(
        res: [ProductCategoryEntity(name: 'All')],
      ),
    );
    when(() => mockCategoryBloc.stream)
        .thenAnswer((_) => const Stream.empty());
  });

  group('ProductView', () {
    testWidgets('renders search bar and category list', (tester) async {
      await tester.pumpApp(
        const ProductView(),
        productBloc: mockProductBloc,
        categoryBloc: mockCategoryBloc,
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(TextField), findsWidgets); // Search bar
      expect(find.text('ALL'), findsOneWidget); // Category "ALL"
    });

    testWidgets('shows loading indicator when status is loading', (
      tester,
    ) async {
      when(() => mockProductBloc.state).thenReturn(
        const PaginationState<ProductEntity>(status: PaginationStatus.loading),
      );

      await tester.pumpApp(
        const ProductView(),
        productBloc: mockProductBloc,
        categoryBloc: mockCategoryBloc,
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('renders product cards when status is success', (tester) async {
      final products = [
        ProductEntity(
          id: 1,
          title: 'Test Product',
          description: 'Desc',
          price: 100,
          thumbnail: 'https://example.com/image.png',
          brand: 'Brand',
          category: 'Cat',
          rating: 4,
        ),
      ];

      when(() => mockProductBloc.state).thenReturn(
        PaginationState<ProductEntity>(
          status: PaginationStatus.success,
          data: products,
        ),
      );

      // ProductPaginationBloc is already success in the when block above

      await mockNetworkImages(() async {
        await tester.pumpApp(
          const ProductView(),
          productBloc: mockProductBloc,
          categoryBloc: mockCategoryBloc,
        );
        await tester.pump(const Duration(milliseconds: 100));
      });

      expect(find.text('Test Product'), findsOneWidget);
    });
  });
}
