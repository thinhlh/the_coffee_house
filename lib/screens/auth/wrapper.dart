import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/categories.dart';
import '../../providers/products.dart';
import '../../utils/global_vars.dart';
import '../home/tab_screen.dart';
import 'auth_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (_, user, child) => user != null
          ? FutureBuilder(
              future: Future.wait([
                Provider.of<Products>(context, listen: false).fetchProducts(),
                Provider.of<Categories>(context, listen: false)
                    .fetchCategories(),
              ]),
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
