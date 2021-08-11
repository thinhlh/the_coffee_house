import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:the/providers/user_provider.dart';
import 'package:the/utils/global_vars.dart';

import '../../utils/const.dart' as Constant;
import '../../widgets/expandable_list_tile.dart';
import 'web_view_screen.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting_screen';
  bool receiveNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
          ),
          elevation: Constant.ELEVATION,
          child: ListView(
            padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('Nhận thông báo'),
                trailing:
                    Consumer<UserProvider>(builder: (_, userProvider, child) {
                  return Switch(
                    value: userProvider.user.subscribeToNotifications,
                    onChanged: (newValue) async {
                      userProvider.toggleReceiveNotification(newValue);
                    },
                  );
                }),
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.auto_delete_sharp,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('Xoá dữ liệu đã lưu trong ứng dụng'),
                onTap: () => sharedPref.clearData(),
              ),
              Divider(
                thickness: 1,
              ),
              ExpandableListTile(
                leadingIcon: Icons.info,
                title: 'Về chúng tôi',
                onExpanded: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                      'Về chúng tôi',
                      'https://www.thecoffeehouse.com/pages/cau-chuyen-thuong-hieu',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
