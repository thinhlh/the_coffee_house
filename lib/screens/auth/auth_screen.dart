import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/screens/auth/login_screen.dart';
import 'package:the_coffee_house/screens/auth/signup_screen.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, child) =>
          auth._isLogin ? LoginScreen() : SignUpScreen(),
    );
  }
}

class AuthProvider with ChangeNotifier {
  bool _isLogin=true;

  void navigate() {
    _isLogin = !_isLogin;
    notifyListeners();
  }
}
