import 'package:the/injection_container.dart';
import 'package:the/tdd/features/promotion/data/datasources/promotions_remote_datasource.dart';
import 'package:the/tdd/features/promotion/data/repositories/promotions_repository_impl.dart';
import 'package:the/tdd/features/promotion/domain/repositories/promotions_repository.dart';
import 'package:the/tdd/features/promotion/domain/usecases/fetch_promotions.dart';
import 'package:the/tdd/features/promotion/presentation/pages/promotions_page.dart';
import 'package:the/tdd/features/promotion/presentation/providers/promotions_provider.dart';

void initPromotionsDependencies() {
  sl.registerFactory(() => PromotionsProvider(sl()));

  sl.registerLazySingleton(() => FetchPromotions(sl()));

  sl.registerLazySingleton<PromotionsRepository>(
      () => PromotionsRepositoryImpl(sl()));

  sl.registerLazySingleton<PromotionsRemoteDataSource>(
      () => PromotionsRemoteDataSourceImpl());
}
