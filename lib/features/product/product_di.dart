import '../../core/di/service_locator.dart';
import 'data/repository/product_repository_impl.dart';
import 'domain/repository/product_repository.dart';
import 'presentation/state_management/add_product_bloc/add_product_bloc.dart';
import 'presentation/state_management/edit_product_bloc/edit_product_bloc.dart';
import 'presentation/state_management/get_all_products_bloc/product_pagination_bloc.dart';
import 'presentation/state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';
import 'presentation/state_management/get_product_category_bloc/get_product_category_bloc.dart';

void initProduct() {
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => ProductPaginationBloc(repository: sl<ProductRepository>()),
  );
  sl.registerLazySingleton(
    () => GetProductByIdBloc(repository: sl<ProductRepository>()),
  );
  sl.registerFactory(() => AddProductBloc(repository: sl<ProductRepository>()));
  sl.registerFactory(
    () => EditProductBloc(repository: sl<ProductRepository>()),
  );
  sl.registerFactory(
    () => GetProductCategoryBloc(repository: sl<ProductRepository>()),
  );
}
