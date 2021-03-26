import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/screens/auth/auth_screen.dart';
import 'package:the_coffee_house/screens/home/tab_screen.dart';
import 'package:the_coffee_house/services/auth.dart';

GlobalKey<TabScreenState> tabScreenState = GlobalKey<TabScreenState>();

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (_, auth, child) => auth.isAuth
          ? TabScreen(key: tabScreenState)
          : ChangeNotifierProvider(
              create: (_) => AuthProvider(),
              child: AuthScreen(),
            ),
    );
  }
}
