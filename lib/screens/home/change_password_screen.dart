import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/providers/user_provider.dart';
import 'package:the/utils/exceptions/authenticate_exception.dart';
import '/utils/const.dart' as Constant;

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change_password_screen';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmationPasswordController =
      TextEditingController();

  bool visiblePassword = false;
  bool isLoading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmationPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: isLoading
                ? CircularProgressIndicator(
                    color: Colors.black,
                  )
                : Padding(
                    padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: currentPasswordController,
                          obscureText: !visiblePassword,
                          decoration: InputDecoration(
                            hintText: 'Current password',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Constant.BORDER_RADIUS),
                            ),
                            suffix: GestureDetector(
                              onTap: () => setState(
                                  () => visiblePassword = !visiblePassword),
                              child: Icon(
                                !visiblePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) => value.length <= 5
                              ? 'Current password must have at least 6 characters'
                              : null,
                        ),
                        SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: !visiblePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Constant.BORDER_RADIUS),
                            ),
                            suffix: GestureDetector(
                              onTap: () => setState(
                                  () => visiblePassword = !visiblePassword),
                              child: Icon(
                                !visiblePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) => value.length <= 5
                              ? 'Password must have at least 6 characters'
                              : null,
                        ),
                        SizedBox(
                          height: Constant.SIZED_BOX_HEIGHT,
                        ),
                        TextFormField(
                          controller: confirmationPasswordController,
                          obscureText: !visiblePassword,
                          decoration: InputDecoration(
                            hintText: 'Confirmation password',
                            suffix: GestureDetector(
                              onTap: () => setState(
                                  () => visiblePassword = !visiblePassword),
                              child: Icon(
                                !visiblePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Constant.BORDER_RADIUS),
                            ),
                          ),
                          validator: (value) => value.length <= 5
                              ? 'Confirmation password must have at least 6 characters'
                              : value != confirmationPasswordController.text
                                  ? 'Confimation password is difference from password'
                                  : null,
                        ),
                        SizedBox(
                          height: Constant.SIZED_BOX_HEIGHT,
                        ),
                        ElevatedButton(
                          onPressed: onSubmit,
                          child: Text('Change password'),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void onSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
      setState(() => isLoading = true);
      try {
        await Provider.of<UserProvider>(context, listen: false)
            .changePassword(
          currentPasswordController.text,
          newPasswordController.text,
        )
            .catchError(
          (error, stackTrace) {
            print(error);
            throw error;
          },
        );
        Navigator.of(context).pop();
      } on AuthenticateException catch (e) {
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Okay'),
              )
            ],
            title: Text('Authenticate failed'),
            content: Text('Given current password is invalid'),
          ),
        );
        setState(() => isLoading = false);
      }
    }
  }
}
