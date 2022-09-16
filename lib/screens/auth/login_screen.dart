import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/utils/exceptions/authenticate_exception.dart';

import '../../utils/exceptions/http_exception.dart';
import '../../services/auth_api.dart';
import '../../utils/const.dart' as Constant;
import 'auth_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth/login_screen';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final sizedBoxHeight = mediaQuery.size.height / 40;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: mediaQuery.size.height / 2.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/auth_background.jpg'),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: mediaQuery.size.height * 0.7,
                  //color: Colors.red,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                  ),
                  child: Scaffold(
                    //resizeToAvoidBottomInset: false,
                    body: SingleChildScrollView(
                      physics: RangeMaintainingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                        child: Center(
                          child: Column(
                            children: [
                              Text('Chào mừng bạn đến với'),
                              SizedBox(height: sizedBoxHeight / 2),
                              Text(
                                'THE COFFEE HOUSE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 28,
                                ),
                              ),
                              SizedBox(height: 2 * sizedBoxHeight),
                              LoginForm(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _loginForm = GlobalKey<FormState>();

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Map<String, String> _authData = {'email': '', 'password': ''};
  bool _isLoading = false;

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);
    try {
      return await AuthAPI().signInWithGoogle();
    } catch (e) {
      if (e.code == AuthMessages.UserDismissedGoogleSignIn) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _facebookSignIn() async {
    setState(() => _isLoading = true);
    try {
      return await AuthAPI().signInWithFacebook();
    } catch (e) {
      if (e.code == AuthMessages.UserDismissedFacebookSignIn) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveForm() async {
    final isValid = _loginForm.currentState.validate();
    if (!isValid) return; //If not valid => not save
    _loginForm.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await AuthAPI().signin(_authData['email'], _authData['password']);
      setState(() {
        _isLoading = false;
      });
    } on HttpException catch (error) {
      var errorMessage = 'Failed To Login';
      if (error.message == 'wrong-password')
        errorMessage =
            'The password is invalid for the given email, or the account corresponding to the email does not have a password set.';
      else if (error.message == 'invalid-email')
        errorMessage = 'Email does not valid';
      else if (error.message == 'user-disable')
        errorMessage =
            'User corresponding to the given email has been disabled.';
      else if (error.message == 'user-not-found')
        errorMessage = 'There is no user corresponding to the given email.';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.blue),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text('Okay'),
            )
          ],
        ),
      );
    } catch (error) {
      var errorMessage = 'Cannot download the data';
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Okay'),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizedBoxHeight = MediaQuery.of(context).size.height / 40;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Form(
            key: _loginForm,
            child: Column(
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.redAccent[200]),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Constant.BORDER_RADIUS),
                    ),
                  ),
                  validator: (value) =>
                      value.contains('@') ? null : 'Invalid email',
                  onSaved: (value) => _authData['email'] = value,
                ),
                SizedBox(height: sizedBoxHeight),
                TextFormField(
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.amber.shade700,
                    ),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Constant.BORDER_RADIUS),
                    ),
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Password cannot be empty' : null,
                  onSaved: (value) => _authData['password'] = value,
                ),
                SizedBox(height: sizedBoxHeight),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: Text('Login'),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 10),
                      ),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.amber.shade700,
                      ),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: sizedBoxHeight),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.black87)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Constant.GENERAL_PADDING,
                      ),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider(color: Colors.black87)),
                  ],
                ),
                SizedBox(height: sizedBoxHeight),
                GoogleAuthButton(
                  onPressed: _googleSignIn,
                  style: AuthButtonStyle(
                    buttonColor: Colors.white,
                    splashColor: Colors.grey.shade100,
                    shadowColor: Colors.grey,
                    borderRadius: 8.0,
                    elevation: 2.0,
                    width: 280.0,
                    height: 50.0,
                    separator: 10.0,
                    iconSize: 35.0,
                    iconBackground: Colors.transparent,
                    iconType: AuthIconType.secondary,
                    buttonType: AuthButtonType.secondary,
                    padding: const EdgeInsets.all(8.0),
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                SizedBox(height: sizedBoxHeight),
                FacebookAuthButton(
                  onPressed: _facebookSignIn,
                  rtl: false,
                  style: AuthButtonStyle(
                    buttonColor: Colors.white,
                    splashColor: Colors.grey.shade100,
                    shadowColor: Colors.grey,
                    borderRadius: 8.0,
                    elevation: 2.0,
                    width: 280.0,
                    height: 50.0,
                    separator: 10.0,
                    iconSize: 35.0,
                    iconBackground: Colors.transparent,
                    iconType: AuthIconType.outlined,
                    buttonType: AuthButtonType.secondary,
                    padding: const EdgeInsets.all(8.0),
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
                SizedBox(height: 2 * sizedBoxHeight),
                Text.rich(
                  TextSpan(
                    text: '',
                    children: [
                      TextSpan(text: 'Don\'t have an account? '),
                      TextSpan(
                        text: 'Register',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              Provider.of<AuthProvider>(context, listen: false)
                                  .navigate(),
                        style: TextStyle(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
