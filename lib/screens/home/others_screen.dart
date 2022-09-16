import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:the/screens/home/orders_history_screen.dart';

import '../../services/auth_api.dart';
import '../../utils/const.dart' as Constant;
import '../../widgets/expandable_list_tile.dart';
import '../../widgets/navigative_action_card.dart';
import 'contact_screen.dart';
import 'setting_screen.dart';
import 'user_info_screen.dart';
import 'web_view_screen.dart';

class OthersScreen extends StatelessWidget {
  static const routeName = '/others_screen';

  Widget _titleText(String title) => Padding(
        padding: const EdgeInsets.only(left: Constant.GENERAL_PADDING),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText('Tiện ích'),
          GridView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 1.5,
            ),
            children: [
              NavigativeActionCard(
                icon: FlutterIcons.file_document_mco,
                color: Colors.cyan,
                title: 'Lịch sử đơn hàng',
                onPressed: () => Navigator.of(context)
                    .pushNamed(OrdersHistoryScreen.routeName),
              ),
              NavigativeActionCard(
                icon: FlutterIcons.law_oct,
                color: Theme.of(context).primaryColor,
                title: 'Điều khoản',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                      'Điều khoản',
                      'https://order.thecoffeehouse.com/term',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: Constant.SIZED_BOX_HEIGHT,
          ),
          _titleText('Hỗ trợ'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
            ),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
              children: [
                ExpandableListTile(
                  leadingIcon: Icons.star,
                  title: 'Gửi đánh giá và góp ý',
                  onExpanded: () {},
                ),
                Divider(),
                ExpandableListTile(
                  leadingIcon: Icons.message,
                  title: 'Liên hệ',
                  onExpanded: () =>
                      Navigator.of(context).pushNamed(ContactScreen.routeName),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Constant.SIZED_BOX_HEIGHT,
          ),
          _titleText('Tài khoản'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
            ),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
              children: [
                ExpandableListTile(
                  leadingIcon: Icons.person,
                  title: 'Thông tin cá nhân',
                  onExpanded: () =>
                      Navigator.of(context).pushNamed(UserInfoScreen.routeName),
                ),
                Divider(),
                ExpandableListTile(
                  leadingIcon: Icons.notifications,
                  title: 'Cài đặt',
                  onExpanded: () =>
                      Navigator.of(context).pushNamed(SettingScreen.routeName),
                ),
                Divider(),
                ExpandableListTile(
                  leadingIcon: Icons.logout,
                  title: 'Đăng xuất',
                  onExpanded: () async => await AuthAPI().signOut(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
