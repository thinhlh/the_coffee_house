import 'package:the/injection_container.dart';
import 'package:the/tdd/features/address/data/datasources/address_local_data_source.dart';
import 'package:the/tdd/features/address/data/repositories/address_repository_impl.dart';
import 'package:the/tdd/features/address/domain/repositories/address_repository.dart';
import 'package:the/tdd/features/address/domain/usecases/get_delivery_detail_list.dart';
import 'package:the/tdd/features/address/domain/usecases/save_new_delivery_detail.dart';
import 'package:the/tdd/features/address/presentation/providers/address_provider.dart';

void initAddressDependencies() {
  sl.registerFactory(() => AddressProvider(sl(), sl()));

  sl.registerLazySingleton(() => GetDeliveryDetailList(sl()));

  sl.registerLazySingleton(() => SaveNewDeliveryDetail(sl()));

  sl.registerLazySingleton<AddressRepository>(
      () => AddressRepositoryImpl(sl()));

  sl.registerLazySingleton<AddressLocalDataSource>(
      () => AddressLocalDataSourceImpl());
}
