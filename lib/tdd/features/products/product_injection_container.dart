import 'package:the/injection_container.dart';
import 'package:the/tdd/features/products/data/datasources/categories_remote_data_source.dart';
import 'package:the/tdd/features/products/data/datasources/products_remote_data_source.dart';
import 'package:the/tdd/features/products/data/repositories/products_repository_impl.dart';
import 'package:the/tdd/features/products/domain/repositories/products_repository.dart';
import 'package:the/tdd/features/products/domain/usecases/fetch_categories.dart';
import 'package:the/tdd/features/products/domain/usecases/fetch_products.dart';
import 'package:the/tdd/features/products/presentation/providers/products_provider.dart';

void initProductsDependencies() {
  sl.registerFactory(() => ProductsProvider(sl(), sl()));

  sl.registerLazySingleton(() => FetchProducts(sl()));

  sl.registerLazySingleton(() => FetchCategories(sl()));

  sl.registerLazySingleton<ProductsRepository>(() => ProductsRepositoryImpl(
      productsRemoteDataSource: sl(), categoriesRemoteDataSource: sl()));

  sl.registerLazySingleton<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSourceImpl());

  sl.registerLazySingleton<CategoriesRemoteDataSource>(
      () => CategoriesRemoteDataSourceImpl());
}
