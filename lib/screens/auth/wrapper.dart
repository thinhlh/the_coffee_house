import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/providers/categories.dart';
import 'package:the/providers/admin_orders.dart';
import 'package:the/providers/products.dart';
import 'package:the/providers/stores.dart';
import 'package:the/providers/user_provider.dart';
import 'package:the/screens/admin/admin_tab_screen.dart';
import 'package:the/screens/home/tab_screen.dart';
import 'package:the/services/fcm_service.dart';
import 'package:the/services/user_orders_api.dart';
import 'package:the/utils/global_vars.dart';

import 'auth_screen.dart';

class Wrapper extends StatelessWidget {
  final waitingScreen = Scaffold(
    body: Image.asset(
      'assets/images/waiting_screen.jpg',
      fit: BoxFit.cover,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (_, user, child) => user != null
          ? FutureBuilder(
              future: Future.wait([
                Provider.of<Products>(context, listen: false).fetchProducts(),
                Provider.of<Categories>(context, listen: false)
                    .fetchCategories(),
                Provider.of<Stores>(context, listen: false).fetchStores(),
                UserOrdersAPI().getOrdersFuture(),
              ]),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return FutureBuilder(
                    builder: (_, futureSnapshot) =>
                        futureSnapshot.connectionState == ConnectionState.done
                            ? context.read<UserProvider>().user.isAdmin
                                ? AdminTabScreen()
                                : TabScreen(key: tabScreenState)
                            : waitingScreen,
                    future: Future.wait(
                      [
                        Provider.of<UserProvider>(context, listen: false)
                            .fetchUser(),
                        FCMService.initializeFCMSubscription(context
                            .watch<UserProvider>()
                            .user
                            .subscribeToNotifications),
                      ],
                    ),
                  );
                }
                return waitingScreen;
              })
          : ChangeNotifierProvider(
              create: (_) => AuthProvider(),
              child: AuthScreen(),
            ),
    );
  }
}
