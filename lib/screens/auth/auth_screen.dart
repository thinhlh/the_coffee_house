import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/services/auth.dart';

enum AuthOption {
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

  AuthOption option = AuthOption.SignIn;

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
                              AuthForm(option),
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
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.blue),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                onPressed: () => setState(() => option =
                                    (option == AuthOption.SignIn)
                                        ? AuthOption.SignUp
                                        : AuthOption.SignIn),
                                child: Text(
                                    'Sign ${(option != AuthOption.SignIn) ? 'In' : 'Up'} Instead'),
                              )
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
  final AuthOption option;
  AuthForm(this.option);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  Map<String, String> _authData = {'email': '', 'password': ''};
  TextEditingController _passwordController = TextEditingController();

  Future<void> _saveForm() async {
    final isValid = _authForm.currentState.validate();
    if (!isValid) return; //If not valid => not save
    _authForm.currentState.save();
    Provider.of<Auth>(context, listen: false)
        .signup(_authData['email'], _authData['password']);
  }

  @override
  Widget build(BuildContext context) {
    final sizedBoxHeight = MediaQuery.of(context).size.height / 40;
    return Form(
      key: _authForm,
      child: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
              ),
            ),
            onSaved: (value) => _authData['email'] = value,
          ),
          SizedBox(height: sizedBoxHeight),
          TextFormField(
            obscureText: true,
            textInputAction: widget.option == AuthOption.SignIn
                ? TextInputAction.done
                : TextInputAction.next,
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
              ),
            ),
            onSaved: (value) => _authData['password'] = value,
          ),
          Visibility(
            visible: widget.option == AuthOption.SignUp ? true : false,
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
                (widget.option == AuthOption.SignIn) ? 'Login' : 'Register',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
