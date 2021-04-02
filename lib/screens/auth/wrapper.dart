import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/screens/auth/auth_screen.dart';
import 'package:the_coffee_house/screens/home/tab_screen.dart';
import 'package:the_coffee_house/services/firestore_products.dart';

GlobalKey<TabScreenState> tabScreenState = GlobalKey<TabScreenState>();

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (_, user, child) => user != null
          ? FutureBuilder(
              future:
                  FireStoreProducts().firestore.collection('products').get(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return TabScreen(key: tabScreenState);
                }
                return Scaffold(
                  body: Image.asset(
                    'assets/images/waiting_screen.jpg',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                );
              })
          : ChangeNotifierProvider(
              create: (_) => AuthProvider(),
              child: AuthScreen(),
            ),
    );
  }
}
