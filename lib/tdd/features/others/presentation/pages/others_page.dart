import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:the/tdd/common/presentation/widgets/action_card.dart';
import 'package:the/tdd/features/auth/presentation/providers/auth_provider.dart';
import 'package:the/tdd/features/others/presentation/pages/contact_page.dart';
import 'package:the/tdd/features/others/presentation/pages/setting_page.dart';
import 'package:the/tdd/features/others/presentation/pages/web_view_page.dart';
import 'package:the/tdd/features/others/presentation/widgets/others_list_tile.dart';
import 'package:the/utils/const.dart';
import 'package:provider/provider.dart';

class OthersPage extends StatelessWidget {
  static const routeName = '/others_page';

  Widget _titleText(String title) => Padding(
        padding: EdgeInsets.only(left: AppDimens.MEDIUM_PADDING),
        child: Text(
          title,
          style: TextStyle(
            fontSize: AppDimens.MEDIUM_TEXT_SIZE,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
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
              ActionCard(
                icon: FlutterIcons.file_document_mco,
                color: Colors.cyan,
                title: 'Lịch sử đơn hàng',
                onPressed: () {
                  /// TODO navigate to order history screen
                  // Navigator.of(context)
                  //   .pushNamed(OrdersHistoryScreen.routeName),
                },
              ),
              ActionCard(
                icon: FlutterIcons.law_oct,
                color: Theme.of(context).primaryColor,
                title: 'Điều khoản',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebViewPage(
                      'Điều khoản',
                      'https://order.thecoffeehouse.com/term',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
          _titleText('Hỗ trợ'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
            ),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
              children: [
                OthersListTile(
                  leadingIcon: Icons.star,
                  title: 'Gửi đánh giá và góp ý',
                  onTap: () {},
                ),
                Divider(),
                OthersListTile(
                  leadingIcon: Icons.message,
                  title: 'Liên hệ',
                  onTap: () =>
                      Navigator.of(context).pushNamed(ContactPage.routeName),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
          _titleText('Tài khoản'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
            ),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
              children: [
                OthersListTile(
                    leadingIcon: Icons.person,
                    title: 'Thông tin cá nhân',
                    onTap: () {
                      /// TODO navigate to user info page
                      // Navigator.of(context).pushNamed(UserInfoScreen.routeName),
                    }),
                Divider(),
                OthersListTile(
                  leadingIcon: Icons.notifications,
                  title: 'Cài đặt',
                  onTap: () =>
                      Navigator.of(context).pushNamed(SettingPage.routeName),
                ),
                Divider(),
                OthersListTile(
                  leadingIcon: Icons.logout,
                  title: 'Đăng xuất',
                  onTap: () => context.read<AuthProvider>().signOut(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
