import 'package:flutter/material.dart';

import 'package:the_coffee_house/utils/const.dart' as Constant;
import 'package:the_coffee_house/screens/admin_screens/edit_option.dart';
import 'package:the_coffee_house/screens/admin_screens/general_edit_screen.dart';
import 'package:the_coffee_house/screens/admin_screens/notification_edit_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  static const routeName = '/admin_screens/admin_home_screen';

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
        child: ListView(
          children: [
            ListTile(
              title: Text('Customize products'),
              onTap: () => Navigator.of(context).pushNamed(
                GeneralEditScreen.routeName,
                arguments: EditOption.product,
              ),
            ),
            ListTile(
              title: Text('Customize product categories'),
              onTap: () => Navigator.of(context).pushNamed(
                GeneralEditScreen.routeName,
                arguments: EditOption.category,
              ),
            ),
            ListTile(
              title: Text('Customize notifications'),
              onTap: () => Navigator.of(context).pushNamed(
                GeneralEditScreen.routeName,
                arguments: EditOption.notification,
              ),
            ),
            ListTile(
              title: Text('Modify banners'),
            ),
          ],
        ));
  }
}
