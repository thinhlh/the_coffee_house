import 'package:flutter/material.dart';
import 'package:the/tdd/features/auth/presentation/pages/sign_in_page.dart';
import 'package:the/tdd/features/auth/presentation/pages/signup_page.dart';
import 'package:the/tdd/features/home/home_page.dart';
import 'package:the/tdd/features/order/presentation/pages/order_confirmation_page.dart';
import 'package:the/tdd/features/others/presentation/pages/contact_page.dart';
import 'package:the/tdd/features/others/presentation/pages/setting_page.dart';
import 'package:the/tdd/features/products/presentation/pages/favorites_page.dart';
import 'package:the/tdd/features/products/presentation/pages/order_page.dart';
import 'package:the/tdd/features/products/presentation/pages/products_page.dart';
import 'package:the/tdd/features/promotion/presentation/pages/promotions_page.dart';
import 'package:the/tdd/features/stores/presentation/pages/google_map.dart';
import 'package:the/tdd/features/stores/presentation/pages/stores_page.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  // Authentication page
  SignInPage.routeName: (_) => SignInPage(),
  SignUpPage.routeName: (_) => SignUpPage(),

  // Main pages
  HomePage.routeName: (_) => HomePage(),
  OrderPage.routeName: (_) => OrderPage(),
  StoresPage.routeName: (_) => StoresPage(),
  PromotionsPage.routeName: (_) => PromotionsPage(),

  //Pushed pages
  ProductsPage.routeName: (_) => ProductsPage(),
  OrderConfirmationPage.routeName: (_) => OrderConfirmationPage(),
  FavoritePage.routeName: (_) => FavoritePage(),
  GoogleMapPage.routeName: (_) => GoogleMapPage(),
  SettingPage.routeName: (_) => SettingPage(),
  ContactPage.routeName: (_) => ContactPage(),
  // ChooseDeliveryAddressPage.routeName: (_) => ChooseDeliveryAddressPage(),
  // AddNewDeliveryAddressPage.routeName: (_) => AddNewDeliveryAddressPage(),
};
