import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:the/tdd/features/auth/presentation/providers/auth_provider.dart';
import 'package:the/utils/values/dimens.dart';

class SignInPage extends StatelessWidget {
  static const routeName = '/auth/sign-in-page';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: 0.4.sh,
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
                  height: 0.7.sh,
                  //color: Colors.red,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppDimens.BORDER_RADIUS),
                  ),
                  child: Scaffold(
                    //resizeToAvoidBottomInset: false,
                    body: SingleChildScrollView(
                      physics: RangeMaintainingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                'Chào mừng bạn đến với',
                                style: TextStyle(
                                  fontSize: AppDimens.SMALL_TEXT_SIZE,
                                ),
                              ),
                              SizedBox(
                                  height: AppDimens.SMALL_SIZED_BOX_HEIGHT),
                              Text(
                                'THE COFFEE HOUSE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(height: 2 * AppDimens.SIZED_BOX_HEIGHT),
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Future<void> _googleSignIn() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     return await AuthAPI().signInWithGoogle();
  //   } catch (e) {
  //     if (e as.code == AuthMessages.UserDismissedGoogleSignIn) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  // Future<void> _facebookSignIn() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     return await AuthAPI().signInWithFacebook();
  //   } catch (e) {
  //     if (e.code == AuthMessages.UserDismissedFacebookSignIn) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  Future<void> _saveForm(BuildContext context) async {
    if (!_loginForm.currentState.validate()) return;
    _loginForm.currentState.save();

    context.read<AuthProvider>().signIn(
          SignInParams(
            email: emailController.text,
            password: passwordController.text,
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return context.select<AuthProvider, bool>((provider) => provider.loading)
        ? Center(child: CircularProgressIndicator())
        : Form(
            key: _loginForm,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    fontSize: AppDimens.SMALL_TEXT_SIZE,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.redAccent[200]),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.BORDER_RADIUS),
                    ),
                  ),
                  validator: (value) =>
                      value.contains('@') ? null : 'Invalid email',
                ),
                SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(
                    fontSize: AppDimens.SMALL_TEXT_SIZE,
                  ),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.amber.shade700,
                    ),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.BORDER_RADIUS),
                    ),
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Password cannot be empty' : null,
                ),
                SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveForm(context),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                    ),
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
                SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.black87)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.BORDER_RADIUS,
                      ),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                GoogleAuthButton(
                  onPressed: () {
                    //! TODO HANDLING GOOGLE SIGN IN
                  },
                  style: AuthButtonStyle(
                    buttonColor: Colors.white,
                    splashColor: Colors.grey.shade100,
                    shadowColor: Colors.grey,
                    borderRadius: 8.0,
                    elevation: 2.0,
                    width: 280.w,
                    height: 40.h,
                    separator: 10.0,
                    iconSize: 35.0,
                    iconBackground: Colors.transparent,
                    iconType: AuthIconType.secondary,
                    buttonType: AuthButtonType.secondary,
                    padding: const EdgeInsets.all(8.0),
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: AppDimens.SMALL_TEXT_SIZE,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                FacebookAuthButton(
                  onPressed: () {
                    //! TODO HANDLING FACEBOOK SIGN IN
                  },
                  rtl: false,
                  style: AuthButtonStyle(
                    buttonColor: Colors.white,
                    splashColor: Colors.grey.shade100,
                    shadowColor: Colors.grey,
                    borderRadius: 8.0,
                    elevation: 2.0,
                    width: 280.0.w,
                    height: 40.0.h,
                    separator: 10.0,
                    iconSize: 35.0,
                    iconBackground: Colors.transparent,
                    iconType: AuthIconType.outlined,
                    buttonType: AuthButtonType.secondary,
                    padding: const EdgeInsets.all(8.0),
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: AppDimens.SMALL_TEXT_SIZE,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
                SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                Text.rich(
                  TextSpan(
                    text: '',
                    children: [
                      TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                        ),
                      ),
                      TextSpan(
                        text: 'Register',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context
                              .read<AuthProvider>()
                              .navigateToSignUp(context),
                        style: TextStyle(
                          color: Colors.yellow.shade900,
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  context.select<AuthProvider, String>(
                      (value) => value.message ?? ''),
                  style: TextStyle(
                    fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                  ),
                ),
              ],
            ),
          );
  }
}
