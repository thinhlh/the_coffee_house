import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/screens/home/contact_screen.dart';
import 'package:the_coffee_house/screens/home/user_info_screen.dart';

import 'package:the_coffee_house/utils/global_vars.dart';
import 'package:the_coffee_house/providers/coupons.dart';

import 'package:the_coffee_house/providers/notifications.dart';
import 'package:the_coffee_house/providers/cart.dart';
import 'package:the_coffee_house/providers/categories.dart';
import 'package:the_coffee_house/providers/order_card_navigation_provider.dart';
import 'package:the_coffee_house/utils/const.dart' as Constant;
import 'package:the_coffee_house/providers/products.dart';
import 'package:the_coffee_house/providers/stores.dart';
import 'package:the_coffee_house/providers/user_provider.dart';
import 'package:the_coffee_house/screens/admin_screens/general_edit_screen.dart';
import 'package:the_coffee_house/screens/auth/wrapper.dart';
import 'package:the_coffee_house/screens/home/favorites_screen.dart';
import 'package:the_coffee_house/screens/home/home_screen.dart';
import 'package:the_coffee_house/screens/home/products_overview_screen.dart';
import 'package:the_coffee_house/screens/home/order_screen.dart';
import 'package:the_coffee_house/screens/home/others_screen.dart';
import 'package:the_coffee_house/screens/admin_screens/admin_home_screen.dart';
import 'package:the_coffee_house/screens/home/reward_screen.dart';
import 'package:the_coffee_house/screens/home/stores_screen.dart';
import 'package:the_coffee_house/services/auth.dart';
import 'package:the_coffee_house/services/firestore_categories.dart';
import 'package:the_coffee_house/services/firestore_notifications.dart';
import 'package:the_coffee_house/services/firestore_products.dart';
import 'package:the_coffee_house/services/firestore_user.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await sharedPref.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: Auth().user,
      initialData: null,
      child: Consumer<User>(
        builder: (_, user, child) {
          final materialApp = MaterialApp(
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
              ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
              AdminHomeScreen.routeName: (_) => AdminHomeScreen(),
              GeneralEditScreen.routeName: (_) => GeneralEditScreen(),
              FavoriteScreen.routeName: (_) => FavoriteScreen(),
              LoginScreen.routeName: (_) => LoginScreen(),
              SignUpScreen.routeName: (_) => SignUpScreen(),
              //Pushed Page
              ContactScreen.routeName: (_) => ContactScreen(),
              UserInfoScreen.routeName: (_) => UserInfoScreen(),
            },
          );

          return user == null
              ? materialApp
              : MultiProvider(
                  providers: [
                    StreamProvider<UserProvider>.value(
                      value: user.uid == null ? null : FireStoreUser().user,
                      initialData: UserProvider.initialize(),
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
                    ChangeNotifierProvider(
                      create: (_) => Stores(),
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
