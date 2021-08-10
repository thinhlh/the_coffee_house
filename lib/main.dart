import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the/tdd/core/shared_preferences/app_shared_preferences.dart';
import 'app.dart';
import 'package:the/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  await AppSharedPreferences.init();
  runApp(App());
}
