import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:the/screens/home/change_password_screen.dart';
import 'package:the/services/user_api.dart';

import '../../models/custom_user.dart';
import '../../providers/user_provider.dart';
import '../../utils/const.dart' as Constant;

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class UserInfoScreen extends StatelessWidget {
  static const routeName = '/user_info_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cập nhật thông tin'),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(3 * Constant.GENERAL_PADDING),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/originals/db/2f/76/db2f7619df455ddbb31dc52ab286ab1b.jpg',
                    ),
                  ),
                  CircleAvatar(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          _UserForm()
        ],
      ),
    );
  }
}

class _UserForm extends StatefulWidget {
  @override
  __UserFormState createState() => __UserFormState();
}

class __UserFormState extends State<_UserForm> {
  TextEditingController _birthdayController = TextEditingController();

  Map<String, dynamic> tempData = {};

  CustomUser user;

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    user = Provider.of<UserProvider>(context, listen: false).user;
    tempData = {
      'name': user.name,
      'birthday': user.birthday,
    };
    super.initState();
  }

  bool _isInfoChanged() {
    return (tempData['name'] != user.name ||
        tempData['birthday'] != user.birthday);
  }

  void _save() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    UserAPI().editUser(tempData).then((value) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    _birthdayController.text =
        DateFormat('dd/MM/y').format(tempData['birthday']);

    return Padding(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Constant.GENERAL_PADDING,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Nhập tên của bạn *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                  ),
                ),
                validator: (value) =>
                    (!value.contains(RegExp('^[^0-9]+\$')) || value.isEmpty)
                        ? 'Invalid name'
                        : null,
                initialValue: tempData['name'],
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) =>
                    setState(() => tempData['name'] = value),
                onSaved: (value) => tempData['name'] = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Constant.GENERAL_PADDING,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Nhập email của bạn *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                  ),
                ),
                readOnly: true,
                initialValue: user.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) => (value.isEmpty || !value.contains('@'))
                    ? 'Invalid email'
                    : null,
                //enabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Constant.GENERAL_PADDING,
              ),
              child: TextFormField(
                controller: _birthdayController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => showDatePicker(
                  context: context,
                  builder: (BuildContext ctx, Widget child) => Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    child: child,
                  ),
                  initialDate: tempData['birthday'],
                  firstDate: DateTime(1990, 1, 1),
                  lastDate: DateTime.now(),
                  initialDatePickerMode: DatePickerMode.year,
                  fieldLabelText: 'Birthday',
                ).then((value) {
                  if (value != null)
                    setState(() {
                      tempData['birthday'] = value;
                    });
                }),
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(height: Constant.SIZED_BOX_HEIGHT),
            ElevatedButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) => ChangePasswordScreen(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
                child: Text('Đổi mật khẩu'),
              ),
            ),
            SizedBox(height: Constant.SIZED_BOX_HEIGHT),
            ElevatedButton(
              onPressed: _isInfoChanged() ? () async => _save() : null,
              child: Padding(
                padding: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
                child: Text('Cập nhật tài khoản'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
