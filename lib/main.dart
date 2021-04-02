import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/models/notifications.dart';
import 'package:the_coffee_house/providers/cart.dart';
import 'package:the_coffee_house/providers/categories.dart';
import 'package:the_coffee_house/providers/order_card_navigation_provider.dart';
import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/products.dart';
import 'package:the_coffee_house/providers/user_provider.dart';
import 'package:the_coffee_house/screens/admin_screens/general_edit_screen.dart';
import 'package:the_coffee_house/screens/auth/wrapper.dart';
import 'package:the_coffee_house/screens/home/favorites_screen.dart';
import 'package:the_coffee_house/screens/home/home_screen.dart';
import 'package:the_coffee_house/screens/home/products_overview_screen.dart';
import 'package:the_coffee_house/screens/home/order_screen.dart';
import 'package:the_coffee_house/screens/home/others_screen.dart';
import 'package:the_coffee_house/screens/admin_screens/admin_home_screen.dart';
import 'package:the_coffee_house/services/auth.dart';
import 'package:the_coffee_house/services/firestore_categories.dart';
import 'package:the_coffee_house/services/firestore_products.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>(
          create: (_) => Auth().user,
          initialData: null,
        ),
        ChangeNotifierProxyProvider<User, UserProvider>(
            create: (_) => UserProvider.initialize(),
            update: (_, user, userProvider) =>
                user != null ? userProvider.update(user.uid) : null),
        StreamProvider<Products>(
          create: (_) => FireStoreProducts().products,
          initialData: Products.fromList([]),
        ),
        StreamProvider<Categories>(
          create: (_) => FireStoreCategories().categories,
          initialData: Categories.fromList([]),
        ),
        ChangeNotifierProvider<OrderCardNavigationProvider>(
          create: (_) => OrderCardNavigationProvider(),
        ),
        ChangeNotifierProvider<Notifications>(
          create: (_) => Notifications(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (_) => Cart(),
        )
      ],
      child: MaterialApp(
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
          OthersScreen.routeName: (_) => OthersScreen(),
          ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
          AdminHomeScreen.routeName: (_) => AdminHomeScreen(),
          GeneralEditScreen.routeName: (_) => GeneralEditScreen(),
          FavoriteScreen.routeName: (_) => FavoriteScreen(),
          LoginScreen.routeName: (_) => LoginScreen(),
          SignUpScreen.routeName: (_) => SignUpScreen(),
        },
      ),
    );
  }
}
