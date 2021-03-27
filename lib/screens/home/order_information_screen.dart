import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderInformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        child: Text(
          'Call',
          style: TextStyle(
            fontSize: 20,
            color: Colors.purple,
          ),
        ),
        onPressed: () async {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+84 936004027',
            verificationCompleted: (PhoneAuthCredential credential) {},
            verificationFailed: (FirebaseAuthException e) {},
            codeSent: (String verificationId, int resendToken) {},
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        },
      ),
    );
  }
}
