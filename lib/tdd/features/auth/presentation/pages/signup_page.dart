import 'package:flutter/material.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_up.dart';
import 'package:the/tdd/features/auth/presentation/providers/auth_provider.dart';
import 'package:the/tdd/features/auth/presentation/widgets/sign_up_wave_app_bar.dart';
import 'package:the/utils/const.dart';
import 'package:the/utils/helpers/date_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  static const routeName = '/auth/sign-up-page';

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
              expandedHeight: 0.5.sh,
              centerTitle: false,
              title: TextButton(
                onPressed: () =>
                    context.read<AuthProvider>().navigateToSignIn(context),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                background: SignUpWaveAppBar(),
              ),
            ),
            SliverToBoxAdapter(
              child: _SignUpForm(),
            )
          ],
        ),
      ),
    );
  }
}

GlobalKey<FormState> _signupForm = GlobalKey<FormState>();

class _SignUpForm extends StatefulWidget {
  @override
  __SignUpFormState createState() => __SignUpFormState();
}

class __SignUpFormState extends State<_SignUpForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return context.select<AuthProvider, bool>((provider) => provider.loading)
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Form(
              key: _signupForm,
              child: Container(
                padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          (value.contains('@') && value != null)
                              ? null
                              : 'Invalid Email',
                      cursorColor: Colors.black,
                      style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimens.BORDER_RADIUS),
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
                    SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? 'Invalid Password' : null,
                      controller: passwordController,
                      style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimens.BORDER_RADIUS),
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
                    SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                    TextFormField(
                      controller: confirmPasswordController,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                      validator: (value) => value == passwordController.text
                          ? null
                          : 'Confirmation password must be the same as password',
                      cursorColor: Colors.black,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimens.BORDER_RADIUS),
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
                    SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
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
                              BorderRadius.circular(AppDimens.BORDER_RADIUS),
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
                    SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                    GestureDetector(
                      onTap: () => showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        if (value != null)
                          birthdayController.text = DateHelper.ddMMyy(value);
                      }),
                      child: TextFormField(
                        controller: birthdayController,
                        style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                        decoration: InputDecoration(
                          enabled: false,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.BORDER_RADIUS),
                            borderSide: BorderSide.none,
                          ),
                          icon: Icon(
                            Icons.cake,
                            color: Color(0xFFFD7267),
                          ),
                          hintText: DateHelper.ddMMyy(DateTime.now()),
                          fillColor: Colors.grey.shade300,
                          filled: true,
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_signupForm.currentState.validate()) return;
                        _signupForm.currentState.save();

                        context.read<AuthProvider>().signUp(
                              SignUpParams(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                birthday: DateHelper.parsedMMyy(
                                  birthdayController.text,
                                ),
                              ),
                            );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: AppDimens.SMALL_TEXT_SIZE,
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.BORDER_RADIUS),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.all(AppDimens.MEDIUM_PADDING)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue.shade300),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                    SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                    Center(
                      child: Text(
                        context.select<AuthProvider, String>(
                            (provider) => provider.message),
                        style: TextStyle(
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
