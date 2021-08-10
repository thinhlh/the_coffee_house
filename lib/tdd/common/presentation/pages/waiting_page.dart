import 'package:flutter/material.dart';

class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/images/waiting_screen.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
