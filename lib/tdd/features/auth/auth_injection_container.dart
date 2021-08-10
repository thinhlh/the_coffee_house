import 'package:the/injection_container.dart';
import 'package:the/tdd/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:the/tdd/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the/tdd/features/auth/domain/repositories/auth_repository.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_out.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_up.dart';
import 'package:the/tdd/features/auth/presentation/providers/auth_provider.dart';

void initAuthDependencies() {
  sl.registerFactory(() => AuthProvider(sl(), sl(), sl(), sl()));

  sl.registerLazySingleton(() => SignInWithEmailAndPassword(sl()));

  sl.registerLazySingleton(() => SignUp(sl()));

  sl.registerLazySingleton(() => SignOut(sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());
}
