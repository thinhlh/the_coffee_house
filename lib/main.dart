import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/models/notifications.dart';
import 'package:the_coffee_house/providers/cart.dart';
import 'package:the_coffee_house/providers/categories.dart';
import 'package:the_coffee_house/providers/order_card_navigation_provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/products.dart';
import 'package:the_coffee_house/screens/admin_screens/general_edit_screen.dart';
import 'package:the_coffee_house/screens/auth/auth_screen.dart';
import 'package:the_coffee_house/screens/home/favorites_screen.dart';
import 'package:the_coffee_house/screens/home/home_screen.dart';
import 'package:the_coffee_house/screens/home/products_overview_screen.dart';
import 'package:the_coffee_house/screens/home/order_screen.dart';
import 'package:the_coffee_house/screens/home/others_screen.dart';
import 'package:the_coffee_house/screens/admin_screens/admin_home_screen.dart';
import 'package:the_coffee_house/screens/home/tab_screen.dart';
import 'package:the_coffee_house/services/auth.dart';

void main() {
  runApp(App());
}

GlobalKey<TabScreenState> tabScreenState = GlobalKey<TabScreenState>();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider<OrderCardNavigationProvider>(
          create: (_) => OrderCardNavigationProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (_, auth, previousProducts) => Products(
            previousProducts == null ? [] : previousProducts.products,
            auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Categories>(
          create: null,
          update: (_, auth, previousCategories) => Categories(
            previousCategories == null ? [] : previousCategories.categories,
            auth.token,
          ),
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
        home: Consumer<Auth>(
          builder: (_, auth, child) => auth.isAuth ? TabScreen() : AuthScreen(),
        ),
        routes: {
          HomeScreen.routeName: (_) => HomeScreen(),
          OrderScreen.routeName: (_) => OrderScreen(),
          OthersScreen.routeName: (_) => OthersScreen(),
          ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
          AdminHomeScreen.routeName: (_) => AdminHomeScreen(),
          GeneralEditScreen.routeName: (_) => GeneralEditScreen(),
          FavoriteScreen.routeName: (_) => FavoriteScreen(),
          //EditProductScreen.routeName: (_) => EditProductScreen(),
          //EditCategoryScreen.routeName: (_) => EditCategoryScreen(),
        },
      ),
    );
  }
}
