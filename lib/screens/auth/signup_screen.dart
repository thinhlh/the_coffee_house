import 'package:flutter/material.dart';
import 'package:the_coffee_house/const.dart' as Constant;

import 'package:intl/intl.dart';
import 'package:the_coffee_house/screens/auth/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.check, color: Colors.amber.shade200),
          backgroundColor: Color(0xFFFE8853),
          splashColor: Colors.transparent,
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: false,
              expandedHeight: MediaQuery.of(context).size.height / 2,
              title: TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  foregroundColor:
                      MaterialStateProperty.all(Colors.purple.shade400),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Registration',
                  style: TextStyle(
                    color: Colors.purple.shade300,
                  ),
                ),
                background: WavyHeader(),
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

GlobalKey _signupForm = GlobalKey<FormState>();

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  Map<String, dynamic> _userData = {
    'email': '',
    'password': '',
    'birthday': DateTime.now(),
  };

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final sizedBoxHeight = mediaQuery.size.height / 40;

    return SingleChildScrollView(
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
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
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
              ),
              SizedBox(height: sizedBoxHeight),
              TextFormField(
                cursorColor: Colors.black,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
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
              ),
              SizedBox(height: sizedBoxHeight),
              TextFormField(
                cursorColor: Colors.black,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
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
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
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
              ),
              SizedBox(height: sizedBoxHeight),
              GestureDetector(
                onTap: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
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
                    hintText:
                        DateFormat('d/MM/y').format(_userData['birthday']),
                    fillColor: Colors.grey.shade300,
                    filled: true,
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

class WavyHeader extends StatelessWidget {
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
