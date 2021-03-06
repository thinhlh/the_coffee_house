import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/services/firestore_stores.dart';

import 'providers/cart.dart';
import 'providers/categories.dart';
import 'providers/coupons.dart';
import 'providers/notifications.dart';
import 'providers/order_card_navigation_provider.dart';
import 'providers/products.dart';
import 'providers/stores.dart';
import 'providers/user_provider.dart';
import 'screens/admin_screens/admin_home_screen.dart';
import 'screens/admin_screens/general_edit_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/wrapper.dart';
import 'screens/home/contact_screen.dart';
import 'screens/home/favorites_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/order_screen.dart';
import 'screens/home/others_screen.dart';
import 'screens/home/products_overview_screen.dart';
import 'screens/home/reward_screen.dart';
import 'screens/home/setting_screen.dart';
import 'screens/home/stores_screen.dart';
import 'screens/home/user_info_screen.dart';
import 'services/auth.dart';
import 'services/firestore_categories.dart';
import 'services/firestore_notifications.dart';
import 'services/firestore_products.dart';
import 'services/firestore_user.dart';

import 'utils/const.dart' as Constant;
import 'utils/global_vars.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPref.init();
  await initializeFirebaseServices();
  runApp(App());
}

Future<void> initializeFirebaseServices() async {
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.subscribeToTopic("Test");

  FirebaseMessaging.onMessage.listen((event) {
    print(event.notification.body);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('Message Clicked => Open the app');
  });
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  //FirebaseMessaging.instance.unsubscribeFromTopic("Test");
}

Future<void> _messageHandler(RemoteMessage message) async {
  print(message.notification.body);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: Auth().user,
      initialData: null,
      child: Consumer<User>(
        builder: (_, user, child) {
          final materialApp = ScreenUtilInit(
            designSize: Size(360, 690),
            builder: () => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Constant.PRIMARY_SWATCH,
                primaryColor: Constant.PRIMARY_COLOR,
                accentColor: Constant.ACCENT_COLOR,
                appBarTheme: AppBarTheme(backgroundColor: Colors.white),
                dividerColor: Colors.grey.shade300,
              ),
              home: Wrapper(),
              routes: {
                HomeScreen.routeName: (_) => HomeScreen(),
                OrderScreen.routeName: (_) => OrderScreen(),
                StoresScreen.routeName: (_) => StoresScreen(),
                RewardScreen.routeName: (_) => RewardScreen(),
                OthersScreen.routeName: (_) => OthersScreen(),
                ProductsOverviewScreen.routeName: (_) =>
                    ProductsOverviewScreen(),
                AdminHomeScreen.routeName: (_) => AdminHomeScreen(),
                GeneralEditScreen.routeName: (_) => GeneralEditScreen(),
                FavoriteScreen.routeName: (_) => FavoriteScreen(),
                LoginScreen.routeName: (_) => LoginScreen(),
                SignUpScreen.routeName: (_) => SignUpScreen(),
                //Pushed Page
                ContactScreen.routeName: (_) => ContactScreen(),
                UserInfoScreen.routeName: (_) => UserInfoScreen(),
                SettingScreen.routeName: (_) => SettingScreen(),
              },
            ),
          );

          return user == null
              ? materialApp
              : MultiProvider(
                  providers: [
                    StreamProvider<UserProvider>.value(
                      value: user.uid == null ? null : FireStoreUser().user,
                      initialData: UserProvider.initialize(),
                    ),
                    StreamProvider<Stores>.value(
                      value: FireStoreStores().stream,
                      initialData: Stores.fromList([]),
                    ),
                    StreamProvider<Products>.value(
                      value: FireStoreProducts().stream,
                      initialData: Products.fromList([]),
                    ),
                    StreamProvider<Categories>.value(
                      value: FireStoreCategories().stream,
                      initialData: Categories.fromList([]),
                    ),
                    ChangeNotifierProvider<OrderCardNavigationProvider>(
                      create: (_) => OrderCardNavigationProvider(),
                    ),
                    ChangeNotifierProvider<Cart>(
                      create: (_) => Cart(),
                    ),
                    ChangeNotifierProvider<Coupons>(
                      create: (_) => Coupons(),
                    ),
                  ],
                  builder: (_, child) => Consumer<UserProvider>(
                    builder: (_, userProvider, child) => MultiProvider(
                      providers: [
                        StreamProvider<Notifications>.value(
                          value: FireStoreNotifications().stream,
                          initialData: Notifications.initialize(),
                        ),
                      ],
                      child: materialApp,
                    ),
                  ),
                  child: materialApp,
                );
        },
      ),
    );
  }
}
