import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../utils/const.dart' as Constant;
import '../../widgets/expandable_list_tile.dart';
import 'web_view_screen.dart';

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
                trailing: _NotificationSwitch(true),
              ),
              Divider(
                thickness: 1,
              ),
              ExpandableListTile(
                leadingIcon: Icons.link,
                title: 'Liên kết với tài khoản',
                onExpanded: () {},
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

class _NotificationSwitch extends StatefulWidget {
  bool receiveNotification;
  _NotificationSwitch(this.receiveNotification);
  @override
  __NotificationSwitchState createState() => __NotificationSwitchState();
}

class __NotificationSwitchState extends State<_NotificationSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.receiveNotification,
      onChanged: (newValue) async {
        newValue
            ? await FirebaseMessaging.instance.subscribeToTopic("Test")
            : await FirebaseMessaging.instance.unsubscribeFromTopic("Test");
        setState(() => widget.receiveNotification = newValue);
      },
    );
  }
}
