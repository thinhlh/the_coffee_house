import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/models/http_exception.dart';
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
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  AuthMode authMode = AuthMode.SignIn;

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
                              AuthForm(authMode),
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

final _authForm = GlobalKey<FormState>();

class AuthForm extends StatefulWidget {
  AuthMode authMode;
  AuthForm(this.authMode);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  Map<String, String> _authData = {'email': '', 'password': ''};
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _authForm.currentState.validate();
    if (!isValid) return; //If not valid => not save
    _authForm.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (widget.authMode == AuthMode.SignIn)
        await Provider.of<Auth>(context, listen: false)
            .signin(_authData['email'], _authData['password']);
      else
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);
    } on HttpException catch (error) {
      var errorMessage = 'Failed To Login';

      if (error.message == 'EMAIL_EXISTS')
        errorMessage =
            'The email address is already in use by another account.';
      else if (error.message == 'TOO_MANY_ATTEMPTS_TRY_LATER')
        errorMessage =
            'You have been tried to login this account for multiple times. Please try again later';
      else if (error.message == 'WEAK_PASSWORD')
        errorMessage = 'Password should be at least 6 characters';
      else if (error.message == 'INVALID_EMAIL')
        errorMessage = 'Email does not valid';
      else if (error.message == 'INVALID_PASSWORD')
        errorMessage = 'The password is invalid.';
      else if (error.message == 'EMAIL_NOT_FOUND')
        errorMessage =
            'There is no user record corresponding to this identifier.';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                _passwordController.clear();
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
                _passwordController.clear();
                Navigator.pop(context);
              },
              child: Text('Okay'),
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizedBoxHeight = MediaQuery.of(context).size.height / 40;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Form(
            key: _authForm,
            child: Column(
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
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
                  textInputAction: widget.authMode == AuthMode.SignIn
                      ? TextInputAction.done
                      : TextInputAction.next,
                  controller: _passwordController,
                  decoration: InputDecoration(
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
                Visibility(
                  visible: widget.authMode == AuthMode.SignUp ? true : false,
                  child: Column(
                    children: [
                      SizedBox(height: sizedBoxHeight),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Constant.BORDER_RADIUS),
                          ),
                          labelText: 'Confirm Password',
                        ),
                        validator: (value) {
                          if (value != _passwordController.text)
                            return 'Password do not match';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sizedBoxHeight),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: Text(
                      (widget.authMode == AuthMode.SignIn)
                          ? 'Login'
                          : 'Register',
                    ),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
                SizedBox(height: sizedBoxHeight),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Divider(
                          color: Colors.black,
                          height: 20,
                        ),
                      ),
                    ),
                    Text('HOẶC'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Divider(
                          color: Colors.black,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sizedBoxHeight),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.blue),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () => setState(() => widget.authMode =
                      (widget.authMode == AuthMode.SignIn)
                          ? AuthMode.SignUp
                          : AuthMode.SignIn),
                  child: Text(
                      'Sign ${(widget.authMode != AuthMode.SignIn) ? 'In' : 'Up'} Instead'),
                )
              ],
            ),
          );
  }
}
