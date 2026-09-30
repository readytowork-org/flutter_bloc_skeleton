import '../../core/di/service_locator.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/product_remote_datasource_impl.dart';
import 'data/repository/product_repository_impl.dart';
import 'domain/repository/product_repository.dart';
import 'domain/usecases/add_product_usecase.dart';
import 'domain/usecases/edit_product_usecase.dart';
import 'domain/usecases/get_all_product_usecase.dart';
import 'domain/usecases/get_product_by_id_usecase.dart';
import 'domain/usecases/product_category_usecase.dart';
import 'presentation/state_management/add_product_bloc/add_product_bloc.dart';
import 'presentation/state_management/edit_product_bloc/edit_product_bloc.dart';
import 'presentation/state_management/get_all_products_bloc/product_pagination_bloc.dart';
import 'presentation/state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';
import 'presentation/state_management/get_product_category_bloc/get_product_category_bloc.dart';

void initProduct() {
  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );
  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(
    () => GetAllProductsUseCase(repository: sl<ProductRepository>()),
  );
  sl.registerLazySingleton(
    () => GetProductByIdUseCase(repository: sl<ProductRepository>()),
  );
  sl.registerLazySingleton(
    () => AddProductUseCase(repository: sl<ProductRepository>()),
  );
  sl.registerLazySingleton(
    () => EditProductUseCase(repository: sl<ProductRepository>()),
  );
  sl.registerLazySingleton(
    () => ProductCategoryUseCase(repository: sl<ProductRepository>()),
  );

  // Blocs
  sl.registerLazySingleton(
    () => ProductPaginationBloc(productUsecase: sl<GetAllProductsUseCase>()),
  );
  sl.registerLazySingleton(
    () => GetProductByIdBloc(productUsecase: sl<GetProductByIdUseCase>()),
  );
  sl.registerFactory(
    () => AddProductBloc(addProductUseCase: sl<AddProductUseCase>()),
  );
  sl.registerFactory(
    () => EditProductBloc(editProductUseCase: sl<EditProductUseCase>()),
  );
  sl.registerFactory(
    () => GetProductCategoryBloc(
      productCategoryUseCase: sl<ProductCategoryUseCase>(),
    ),
  );
}
