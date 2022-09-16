import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/custom_user.dart';
import '../../utils/exceptions/http_exception.dart';
import '../../services/auth_api.dart';
import '../../utils/const.dart' as Constant;
import 'auth_screen.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/auth/signup_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: false,
              expandedHeight: MediaQuery.of(context).size.height / 2,
              title: Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () =>
                      Provider.of<AuthProvider>(context, listen: false)
                          .navigate(),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    foregroundColor:
                        MaterialStateProperty.all(Colors.blue.shade800),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Registration',
                  style: TextStyle(
                    color: Colors.yellow.shade900,
                  ),
                ),
                background: _WavyHeader(),
              ),
            ),
            SliverToBoxAdapter(
              child: SignUpForm(),
            )
          ],
        ),
      ),
    );
  }
}

GlobalKey<FormState> _signupForm = GlobalKey<FormState>();

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController _password = TextEditingController();
  Map<String, dynamic> _userData = {
    'email': '',
    'password': '',
    'name': '',
    'birthday': DateTime.now(),
  };
  bool _isLoading = false;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final sizedBoxHeight = mediaQuery.size.height / 40;

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Form(
              key: _signupForm,
              child: Container(
                padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          (value.contains('@') && value != null)
                              ? null
                              : 'Invalid Email',
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Constant.BORDER_RADIUS),
                          borderSide: BorderSide.none,
                        ),
                        icon: Icon(
                          Icons.email,
                          color: Color(0xFFFD7267),
                        ),
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        hintText: 'Email',
                      ),
                      onSaved: (value) => _userData['email'] = value,
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? 'Invalid Password' : null,
                      controller: _password,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Constant.BORDER_RADIUS),
                          borderSide: BorderSide.none,
                        ),
                        icon: Icon(
                          Icons.vpn_key,
                          color: Color(0xFFFD7267),
                        ),
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        hintText: 'Password',
                      ),
                      onSaved: (value) => _userData['password'] = value,
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (value) => value == _password.text
                          ? null
                          : 'Confirmation password must be the same as password',
                      cursorColor: Colors.black,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Constant.BORDER_RADIUS),
                          borderSide: BorderSide.none,
                        ),
                        icon: Icon(
                          Icons.security,
                          color: Color(0xFFFD7267),
                        ),
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        hintText: 'Confirm Password',
                      ),
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      cursorColor: Colors.black,
                      validator: (value) =>
                          (!value.contains(RegExp('^[^0-9]+\$')) ||
                                  value.isEmpty)
                              ? 'Invalid Name'
                              : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Constant.BORDER_RADIUS),
                          borderSide: BorderSide.none,
                        ),
                        icon: Icon(
                          Icons.person,
                          color: Color(0xFFFD7267),
                        ),
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        hintText: 'Full Name',
                      ),
                      onSaved: (value) => _userData['name'] = value,
                    ),
                    SizedBox(height: sizedBoxHeight),
                    GestureDetector(
                      onTap: () => showDatePicker(
                        context: context,
                        initialDate: _userData['birthday'],
                        firstDate: DateTime(1990),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        if (value != null)
                          setState(() => _userData['birthday'] = value);
                      }),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabled: false,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Constant.BORDER_RADIUS),
                            borderSide: BorderSide.none,
                          ),
                          icon: Icon(
                            Icons.cake,
                            color: Color(0xFFFD7267),
                          ),
                          hintText: DateFormat('d/MM/y')
                              .format(_userData['birthday']),
                          fillColor: Colors.grey.shade300,
                          filled: true,
                        ),
                      ),
                    ),
                    SizedBox(height: sizedBoxHeight),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_signupForm.currentState.validate()) return;
                          _signupForm.currentState.save();

                          setState(() => _isLoading = true);
                          try {
                            await AuthAPI().signup(
                              CustomUser(
                                uid: null,
                                email: _userData['email'],
                                name: _userData['name'],
                                birthday: _userData['birthday'],
                              ),
                              _userData['password'],
                            );
                          } on HttpException catch (error) {
                            var errorMessage = 'Failed To Sign Up';
                            if (error.message == 'email-already-in-use')
                              errorMessage =
                                  'There already exists an account with the given email address.';
                            else if (error.message == 'weak-password')
                              errorMessage =
                                  'Thrown if the password is not strong enough.';

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
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    child: Text('Okay'),
                                  )
                                ],
                              ),
                            );
                          } catch (error) {
                            var errorMessage = 'Cannot sign up';
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
                            _password.clear();
                          }
                          setState(() => _isLoading = false);
                        },
                        child: Text('Sign Up'),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 10)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow.shade900),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: sizedBoxHeight),
                  ],
                ),
              ),
            ),
          );
  }
}

class _WavyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TopWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: orangeGradients,
            begin: Alignment.topLeft,
            end: Alignment.center,
          ),
        ),
        height: MediaQuery.of(context).size.height / 3.5,
      ),
    );
  }
}

class _TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    //creating first curver near bottom left corner
    var firstControlPoint = new Offset(size.width / 7, size.height - 30);
    var firstEndPoint = new Offset(size.width / 6, size.height / 1.5);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    //creating second curver near center
    var secondControlPoint = Offset(size.width / 5, size.height / 4);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    //creating third curver near top right corner
    var thirdControlPoint =
        Offset(size.width - (size.width / 9), size.height / 6);
    var thirdEndPoint = Offset(size.width, 0.0);

    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move to top right corner
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

const List<Color> orangeGradients = [
  Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),
];
