import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderInformationScreen extends StatelessWidget {
  static const routeName = '/order_information_screen';

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
            phoneNumber: '+84 343099210',
            timeout: Duration(seconds: 20),
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
