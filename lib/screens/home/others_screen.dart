import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:the_coffee_house/screens/home/contact_screen.dart';
import 'package:the_coffee_house/screens/home/user_info_screen.dart';

import 'package:the_coffee_house/utils/const.dart' as Constant;
import 'package:the_coffee_house/screens/home/web_view_screen.dart';
import 'package:the_coffee_house/services/auth.dart';
import 'package:the_coffee_house/widgets/navigative_action_card.dart';

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
                color: Theme.of(context).primaryColor,
                title: 'Lịch sử đơn hàng',
                navigate: () {},
              ),
              NavigativeActionCard(
                icon: FlutterIcons.law_oct,
                color: Theme.of(context).primaryColor,
                title: 'Điều khoản',
                navigate: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                      'Điều khoản',
                      'https://order.thecoffeehouse.com/term',
                    ),
                  ),
                ),
              ),
              NavigativeActionCard(
                icon: FlutterIcons.music_note_mco,
                color: Colors.red,
                title: 'Nhạc đang phát',
                navigate: () {},
              ),
              NavigativeActionCard(
                icon: FlutterIcons.news_ent,
                color: Colors.blue,
                title: 'Tin tức & Khuyến mãi',
                navigate: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                      'Tin tức & khuyến mãi',
                      'https://www.thecoffeehouse.com/blogs/news',
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
                _ExpandableListTile(
                  leadingIcon: Icons.star,
                  title: 'Gửi đánh giá và góp ý',
                  onExpanded: () {},
                ),
                Divider(),
                _ExpandableListTile(
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
                _ExpandableListTile(
                  leadingIcon: Icons.person,
                  title: 'Thông tin cá nhân',
                  onExpanded: () =>
                      Navigator.of(context).pushNamed(UserInfoScreen.routeName),
                ),
                Divider(),
                _ExpandableListTile(
                  leadingIcon: Icons.notifications,
                  title: 'Cài đặt',
                  onExpanded: () {},
                ),
                Divider(),
                _ExpandableListTile(
                  leadingIcon: Icons.logout,
                  title: 'Đăng xuất',
                  onExpanded: () async => await Auth().signOut(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ExpandableListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Function onExpanded;

  _ExpandableListTile({
    @required this.leadingIcon,
    @required this.title,
    @required this.onExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onExpanded,
      leading: Icon(
        leadingIcon,
        color: Constant.ACCENT_COLOR,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      trailing: RotatedBox(
        quarterTurns: 3,
        child: Icon(Icons.expand_more),
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
