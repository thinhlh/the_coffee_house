import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../../services/auth.dart';
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
                              SizedBox(height: 2 * sizedBoxHeight),
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

  Future<void> _saveForm() async {
    final isValid = _loginForm.currentState.validate();
    if (!isValid) return; //If not valid => not save
    _loginForm.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Auth().signin(_authData['email'], _authData['password']);
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
                SizedBox(height: 2 * sizedBoxHeight),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: Text('Login'),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Provider.of<AuthProvider>(context, listen: false)
                          .navigate(),
                  child: Text("Register"),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all(Colors.purple.shade600),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                ),
              ],
            ),
          );
  }
}
