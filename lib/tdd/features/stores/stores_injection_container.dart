import 'package:the/injection_container.dart';
import 'package:the/tdd/features/stores/data/datasources/stores_remote_data_source.dart';
import 'package:the/tdd/features/stores/data/repositories/stores_repository_impl.dart';
import 'package:the/tdd/features/stores/domain/repositories/stores_repository.dart';
import 'package:the/tdd/features/stores/domain/usecases/fetch_stores.dart';
import 'package:the/tdd/features/stores/presentation/providers/stores_provider.dart';

void initStoresDependencies() {
  sl.registerFactory(() => StoresProvider(sl()));

  sl.registerLazySingleton(() => FetchStores(sl()));

  sl.registerLazySingleton<StoresRepository>(() => StoresRepositoryImpl(sl()));

  sl.registerLazySingleton<StoresRemoteDataSource>(
      () => StoresRemoteDataSourceImpl());
}
