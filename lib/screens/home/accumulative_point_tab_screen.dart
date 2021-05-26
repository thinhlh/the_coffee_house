import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/membership.dart';
import '../../providers/coupons.dart';
import '../../providers/user_provider.dart';
import '../../utils/const.dart' as Constant;
import '../../widgets/navigative_action_card.dart';
import '../../widgets/reward_card.dart';
import 'web_view_screen.dart';

class AccumlativePointTabScreen extends StatelessWidget {
  static const routeName = '/accumulative_point';

  final _scrollControler = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _UserPointCard(),
        Padding(
          padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: NavigativeActionCard(
                          icon: FlutterIcons.gift_faw,
                          title: 'Đổi ưu đãi',
                          color: Colors.blue.withOpacity(0.6),
                          navigate: () =>
                              DefaultTabController.of(context).animateTo(1),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: NavigativeActionCard(
                          icon: Icons.credit_card,
                          title: 'Voucher của bạn',
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.9),
                          navigate: () => _scrollControler.animateTo(
                            _scrollControler.position.maxScrollExtent,
                            duration: Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: NavigativeActionCard(
                          icon: FlutterIcons.history_faw,
                          title: 'Lịch sử BEAN',
                          color: Colors.green.shade300,
                          navigate: () {},
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: NavigativeActionCard(
                          icon: FlutterIcons.law_oct,
                          title: 'Quyền lợi của bạn',
                          color: Colors.blue.shade700,
                          navigate: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WebViewScreen(
                                'Quyền lợi của bạn',
                                'https://www.thecoffeehouse.com/pages/rewards',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  Padding(
                    padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phiếu ưu đãi của bạn',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Constant.TEXT_SIZE,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              DefaultTabController.of(context).animateTo(1),
                          child: Chip(
                            backgroundColor: Colors.white,
                            label: Text(
                              'XEM TẤT CẢ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<Coupons>(
                    builder: (_, couponsProvider, child) => ListView.builder(
                      controller: _scrollControler,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) =>
                          RewardCard(couponsProvider.firstThreeCoupons[index]),
                      itemCount: couponsProvider.firstThreeCoupons.length,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserPointCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5.sh,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey,
            Colors.white,
          ],
        ),
      ),
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      child: Card(
        elevation: Constant.ELEVATION,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            2 * Constant.BORDER_RADIUS,
          ),
        ),
        child: Consumer<UserProvider>(
          builder: (_, user, child) => Column(
            children: [
              Expanded(
                flex: 2,
                child: _UserInfoCard(),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Còn ${(2000 - user.user.point < 0) ? 0 : 2000 - user.user.point} BEAN nữa bạn sẽ thăng hạng.\n'
                    'Đổi quà không ảnh hưởng tới việc thăng hạng của bạn.\n180 BEAN tích lũy từ 1/7/2020-30/9/2020 sẽ hết hạn vào ngày 30/03/2021. '
                    'Hãy dùng BEAN này để đổi ưu đãi nhé',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: BarcodeWidget(
            data: user.uid,
            barcode: Barcode.code128(),
            drawText: false,
            padding: const EdgeInsets.symmetric(
              horizontal: 3 * Constant.GENERAL_PADDING,
              vertical: 2 * Constant.GENERAL_PADDING,
            ),
          ),
        ),
        //Text(user.uid),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(2 * Constant.BORDER_RADIUS),
              ),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.7),
                  Theme.of(context).accentColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Hạng ${user.membership == Membership.Bronze ? 'Đồng' : user.membership == Membership.Silver ? 'Bạc' : user.membership == Membership.Gold ? 'Vàng' : 'Kim cương'}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.TEXT_SIZE,
                  ),
                ),
                Text(
                  '${user.point} BEAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.LIST_TILE_SUBTITTLE,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
