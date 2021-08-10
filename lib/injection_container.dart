import 'package:get_it/get_it.dart';
import 'package:the/tdd/features/address/address_injection_container.dart';
import 'package:the/tdd/features/auth/auth_injection_container.dart';
import 'package:the/tdd/features/notifications/notifications_injection_container.dart';
import 'package:the/tdd/features/order/order_injection_container.dart';
import 'package:the/tdd/features/products/product_injection_container.dart';
import 'package:the/tdd/features/promotion/promotion_injection_container.dart';
import 'package:the/tdd/features/stores/stores_injection_container.dart';
import 'package:the/tdd/features/user/user_injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  initAuthDependencies();
  initUserDependencies();
  initProductsDependencies();
  initStoresDependencies();
  initNotificationsDependencies();
  initPromotionsDependencies();
  initOrderDependencies();
  initAddressDependencies();
}
