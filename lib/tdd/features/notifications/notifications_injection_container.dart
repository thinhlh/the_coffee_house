import 'package:the/injection_container.dart';
import 'package:the/tdd/features/notifications/data/datasources/notifications_local_data_source.dart';
import 'package:the/tdd/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:the/tdd/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:the/tdd/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:the/tdd/features/notifications/domain/usecases/fetch_notifications.dart';
import 'package:the/tdd/features/notifications/domain/usecases/get_viewed_notifications.dart';
import 'package:the/tdd/features/notifications/domain/usecases/save_viewed_notifications.dart';
import 'package:the/tdd/features/notifications/presentation/providers/notifications_provider.dart';

void initNotificationsDependencies() {
  sl.registerFactory(() => NotificationsProvider(sl(), sl(), sl()));

  sl.registerLazySingleton(() => FetchNotifications(sl()));

  sl.registerLazySingleton(() => GetViewedNotifications(sl()));

  sl.registerLazySingleton(() => SaveViewedNotification(sl()));

  sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl());

  sl.registerLazySingleton<NotificationsLocalDataSource>(
      () => NotificationsLocalDataSourceImpl());
}
