import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/models/http_exception.dart';
import 'package:the_coffee_house/screens/auth/login_screen.dart';
import 'package:the_coffee_house/services/auth.dart';

enum AuthMode {
  SignIn,
  SignUp,
}

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode authMode = AuthMode.SignIn;

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}

final _authForm = GlobalKey<FormState>();

class AuthForm extends StatefulWidget {
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return LoginScreen();
    //       Visibility(
    //         visible: widget.authMode == AuthMode.SignUp ? true : false,
    //         child: Column(
    //           children: [
    //             SizedBox(height: sizedBoxHeight),
    //             TextFormField(
    //               obscureText: true,
    //               decoration: InputDecoration(
    //                 border: OutlineInputBorder(
    //                   borderRadius:
    //                       BorderRadius.circular(Constant.BORDER_RADIUS),
    //                 ),
    //                 labelText: 'Confirm Password',
    //               ),
    //               validator: (value) {
    //                 if (value != _passwordController.text)
    //                   return 'Password do not match';
    //                 return null;
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //       SizedBox(height: sizedBoxHeight),
    //       SizedBox(
    //         width: double.infinity,
    //         child: ElevatedButton(
    //           onPressed: _saveForm,
    //           child: Text(
    //             (widget.authMode == AuthMode.SignIn)
    //                 ? 'Login'
    //                 : 'Register',
    //           ),
    //           style: ButtonStyle(
    //             overlayColor:
    //                 MaterialStateProperty.all(Colors.transparent),
    //           ),
    //         ),
    //       ),
    //       SizedBox(height: sizedBoxHeight),
    //       Row(
    //         children: [
    //           Expanded(
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 20,
    //               ),
    //               child: Divider(
    //                 color: Colors.black,
    //                 height: 20,
    //               ),
    //             ),
    //           ),
    //           Text('HOẶC'),
    //           Expanded(
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 20,
    //               ),
    //               child: Divider(
    //                 color: Colors.black,
    //                 height: 20,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       SizedBox(height: sizedBoxHeight),
    //       TextButton(
    //         style: ButtonStyle(
    //           foregroundColor: MaterialStateProperty.all(Colors.blue),
    //           overlayColor: MaterialStateProperty.all(Colors.transparent),
    //         ),
    //         onPressed: () => setState(() => widget.authMode =
    //             (widget.authMode == AuthMode.SignIn)
    //                 ? AuthMode.SignUp
    //                 : AuthMode.SignIn),
    //         child: Text(
    //             'Sign ${(widget.authMode != AuthMode.SignIn) ? 'In' : 'Up'} Instead'),
    //       )
    //     ],
    //   ),
    // );
  }
}
