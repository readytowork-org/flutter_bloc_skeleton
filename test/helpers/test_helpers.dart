import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc_skeleton/l10n/s.dart';

import 'package:flutter_bloc_skeleton/features/auth/presentation/state_management/auth_bloc.dart';
import 'package:flutter_bloc_skeleton/features/product/domain/entities/product_entity.dart';
import 'package:flutter_bloc_skeleton/features/product/presentation/state_management/get_all_products_bloc/product_pagination_bloc.dart';
import 'package:flutter_bloc_skeleton/features/product/presentation/state_management/get_product_category_bloc/get_product_category_bloc.dart';
import 'package:flutter_bloc_skeleton/shared/bloc/base_pagination_bloc.dart';

// ─── Mock classes ─────────────────────────────────────────────────────────────

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockProductPaginationBloc
    extends MockBloc<PaginationEvent, PaginationState<ProductEntity>>
    implements ProductPaginationBloc {}

class MockGetProductCategoryBloc
    extends MockBloc<GetProductCategoryEvent, GetProductCategoryState>
    implements GetProductCategoryBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

class FakePaginationEvent extends Fake implements PaginationEvent {}

class FakeProductPaginationState extends Fake
    implements PaginationState<ProductEntity> {}

class FakeGetProductCategoryEvent extends Fake
    implements GetProductCategoryEvent {}

class FakeGetProductCategoryState extends Fake
    implements GetProductCategoryState {}

void registerAuthFallbacks() {
  registerFallbackValue(FakeAuthEvent());
  registerFallbackValue(FakeAuthState());
  registerFallbackValue(FakePaginationEvent());
  registerFallbackValue(FakeProductPaginationState());
  registerFallbackValue(FakeGetProductCategoryEvent());
  registerFallbackValue(FakeGetProductCategoryState());
}

// ─── Shared pump helper ───────────────────────────────────────────────────────

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    MockAuthBloc? authBloc,
    MockProductPaginationBloc? productBloc,
    MockGetProductCategoryBloc? categoryBloc,
  }) async {
    await pumpWidget(
      MultiBlocProvider(
        providers: [
          if (authBloc != null)
            BlocProvider<AuthBloc>.value(value: authBloc)
          else
            BlocProvider<AuthBloc>.value(value: MockAuthBloc()),
          if (productBloc != null)
            BlocProvider<ProductPaginationBloc>.value(value: productBloc),
          if (categoryBloc != null)
            BlocProvider<GetProductCategoryBloc>.value(value: categoryBloc),
        ],
        child: MaterialApp(
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          home: Scaffold(body: widget),
        ),
      ),
    );
  }
}
