import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:the/providers/cart.dart';
import 'package:the/providers/categories.dart';
import 'package:the/providers/notifications.dart';
import 'package:the/providers/admin_orders.dart';
import 'package:the/providers/user_orders.dart';
import 'package:the/providers/products.dart';
import 'package:the/providers/promotions.dart';
import 'package:the/providers/stores.dart';
import 'package:the/providers/user_provider.dart';
import 'package:the/providers/users.dart';
import 'package:the/screens/auth/wrapper.dart';
import 'package:the/services/admin_orders_api.dart';
import 'package:the/services/auth_api.dart';
import 'package:the/services/categories_api.dart';
import 'package:the/services/notifications_api.dart';
import 'package:the/services/user_orders_api.dart';
import 'package:the/services/products_api.dart';
import 'package:the/services/promotions_api.dart';
import 'package:the/services/stores_api.dart';
import 'package:the/services/user_api.dart';
import 'package:the/services/shared_preferences.dart';
import 'package:the/services/users_api.dart';
import 'package:the/utils/router.dart';
import './utils/const.dart' as Constant;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  await _initializeFirebaseServices();
  runApp(App());
}

Future<void> _initializeFirebaseServices() async {
  await Firebase.initializeApp();
  //FirebaseMessaging.instance.unsubscribeFromTopic("notifications");
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthAPI().user,
      initialData: null,
      child: Consumer<User>(
        builder: (_, user, child) {
          final materialApp = ScreenUtilInit(
            designSize: Size(360, 690),
            builder: () => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                // scaffoldBackgroundColor: Color(0xba9a6d),
                primarySwatch: Constant.PRIMARY_SWATCH,
                primaryColor: Constant.PRIMARY_COLOR,
                accentColor: Constant.ACCENT_COLOR,
                appBarTheme: AppBarTheme(backgroundColor: Colors.white),
                dividerColor: Colors.grey.shade300,
              ),
              home: Wrapper(),
              routes: routes,
            ),
          );

          if (user == null) {
            return materialApp;
          } else {
            return MultiProvider(
              providers: [
                StreamProvider<UserProvider>.value(
                  value:
                      user == null || user.uid == null ? null : UserAPI().user,
                  initialData: UserProvider.initialize(),
                ),
                StreamProvider<Stores>.value(
                  value: StoresAPI().stream,
                  initialData: Stores.fromList([]),
                ),
                StreamProvider<Products>.value(
                  value: ProductsAPI().stream,
                  initialData: Products.fromList([]),
                ),
                StreamProvider<UserOrders>.value(
                  value: UserOrdersAPI().stream,
                  initialData: UserOrders.fromList([]),
                ),
                StreamProvider<Notifications>.value(
                  value: NotificationsAPI().stream,
                  initialData: Notifications.fromList([]),
                ),
                StreamProvider<Categories>.value(
                  value: CategoriesAPI().stream,
                  initialData: Categories.fromList([]),
                ),
                StreamProvider<Promotions>.value(
                  value: PromotionsAPI().stream,
                  initialData: Promotions.fromList([]),
                ),
                ChangeNotifierProvider<Cart>(
                  create: (_) => Cart(),
                ),
                StreamProvider<AdminOrders>.value(
                  value: AdminOrdersAPI().stream,
                  initialData: AdminOrders.fromList([]),
                ),
                StreamProvider<Users>.value(
                  value: UsersAPI().stream,
                  initialData: Users.fromList([]),
                ),
              ],
              child: materialApp,
            );
          }
        },
      ),
    );
  }
}
