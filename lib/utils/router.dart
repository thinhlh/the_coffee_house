import 'package:the/screens/admin/admin_categories_screen.dart';
import 'package:the/screens/admin/admin_notifications_screen.dart';
import 'package:the/screens/admin/admin_products_screen.dart';
import 'package:the/screens/admin/admin_promotions_screen.dart';
import 'package:the/screens/admin/admin_stores_screen.dart';
import 'package:the/screens/auth/login_screen.dart';
import 'package:the/screens/auth/signup_screen.dart';
import 'package:the/screens/home/change_password_screen.dart';
import 'package:the/screens/home/contact_screen.dart';
import 'package:the/screens/home/favorites_screen.dart';
import 'package:the/screens/home/home_screen.dart';
import 'package:the/screens/home/order_screen.dart';
import 'package:the/screens/home/orders_history_screen.dart';
import 'package:the/screens/home/others_screen.dart';
import 'package:the/screens/home/products_overview_screen.dart';
import 'package:the/screens/home/reward_screen.dart';
import 'package:the/screens/home/setting_screen.dart';
import 'package:the/screens/home/stores_screen.dart';
import 'package:the/screens/home/user_info_screen.dart';

final routes = {
  HomeScreen.routeName: (_) => HomeScreen(),
  OrderScreen.routeName: (_) => OrderScreen(),
  StoresScreen.routeName: (_) => StoresScreen(),
  RewardScreen.routeName: (_) => RewardScreen(),
  OthersScreen.routeName: (_) => OthersScreen(),
  ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
  FavoriteScreen.routeName: (_) => FavoriteScreen(),
  LoginScreen.routeName: (_) => LoginScreen(),
  SignUpScreen.routeName: (_) => SignUpScreen(),
  //Pushed Page
  ContactScreen.routeName: (_) => ContactScreen(),
  UserInfoScreen.routeName: (_) => UserInfoScreen(),
  SettingScreen.routeName: (_) => SettingScreen(),
  ChangePasswordScreen.routeName: (_) => ChangePasswordScreen(),
  OrdersHistoryScreen.routeName: (_) => OrdersHistoryScreen(),

  //Admin
  AdminProductsScreen.routeName: (_) => AdminProductsScreen(),
  AdminNotificationsScreen.routeName: (_) => AdminNotificationsScreen(),
  AdminPromotionsScreen.routeName: (_) => AdminPromotionsScreen(),
  AdminStoresScreen.routeName: (_) => AdminStoresScreen(),
  AdminCategoriesScreen.routeName: (_) => AdminCategoriesScreen(),
};
