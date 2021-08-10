import 'package:the/injection_container.dart';
import 'package:the/tdd/features/auth/presentation/providers/user_provider.dart';
import 'package:the/tdd/features/user/data/datasources/user_remote_data_source.dart';
import 'package:the/tdd/features/user/data/repositories/user_repository_impl.dart';
import 'package:the/tdd/features/user/domain/repositories/user_repository.dart';
import 'package:the/tdd/features/user/domain/usecases/fetch_user.dart';
import 'package:the/tdd/features/user/domain/usecases/toggle_favorite_product.dart';

void initUserDependencies() {
  sl.registerFactory(() => UserProvider(sl()));

  sl.registerFactory(() => ToggleFavoriteProduct(sl()));

  sl.registerLazySingleton(() => FetchUser(sl()));

  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl());
}
