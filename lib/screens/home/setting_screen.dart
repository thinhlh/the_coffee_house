import 'package:flutter/material.dart';

import '../../utils/const.dart' as Constant;
import '../../widgets/expandable_list_tile.dart';
import 'web_view_screen.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting_screen';

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
                trailing: Switch(
                  value: true,
                  onChanged: (newValue) {},
                ),
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
