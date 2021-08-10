import 'package:the/injection_container.dart';
import 'package:the/tdd/features/address/domain/usecases/get_latest_delivery_detail.dart';
import 'package:the/tdd/features/address/domain/usecases/get_latest_take_away_location.dart';
import 'package:the/tdd/features/order/data/datasources/order_remote_data_source.dart';
import 'package:the/tdd/features/order/data/repositories/order_repository_impl.dart';
import 'package:the/tdd/features/order/domain/repositories/order_repository.dart';
import 'package:the/tdd/features/order/domain/usecases/add_order.dart';
import 'package:the/tdd/features/order/presentation/providers/cart_provider.dart';
import 'package:the/tdd/features/order/presentation/providers/order_provider.dart';

void initOrderDependencies() {
  sl.registerFactory(() => OrderProvider(sl()));

  sl.registerFactory(() => CartProvider(sl(), sl()));

  sl.registerLazySingleton(() => AddOrder(sl()));

  sl.registerLazySingleton(() => GetLatestDeliveryDetail(sl()));

  sl.registerLazySingleton(() => GetLatestTakeAwayLocation(sl()));

  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));

  sl.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl());
}
