import 'package:flutter/material.dart';
import 'package:the/tdd/features/others/presentation/pages/web_view_page.dart';
import 'package:the/tdd/features/others/presentation/widgets/others_list_tile.dart';
import 'package:the/utils/values/dimens.dart';

class SettingPage extends StatelessWidget {
  static const routeName = '/setting_page';
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
        padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
          ),
          elevation: AppDimens.ELEVATION,
          child: ListView(
            padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Nhận thông báo',
                  style: TextStyle(
                    fontSize: AppDimens.SMALL_TEXT_SIZE,
                  ),
                ),

                /// TODO toggle sub/unsubscribe to notification
                // trailing:
                //     Consumer<UserProvider>(builder: (_, userProvider, child) {
                //   return Switch(
                //     value: userProvider.user.subscribeToNotifications,
                //     onChanged: (newValue) async {
                //       userProvider.toggleReceiveNotification(newValue);
                //     },
                //   );
                // }),
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.auto_delete_sharp,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Xoá dữ liệu đã lưu trong ứng dụng',
                  style: TextStyle(
                    fontSize: AppDimens.SMALL_TEXT_SIZE,
                  ),
                ),

                /// TODO handle clear local data
                // onTap: () => sharedPref.clearData(),
              ),
              Divider(
                thickness: 1,
              ),
              OthersListTile(
                leadingIcon: Icons.info,
                title: 'Về chúng tôi',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebViewPage(
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
