import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/providers/promotions.dart';
import 'package:the/screens/home/point_history.dart';
import 'package:the/widgets/user_info_card.dart';

import '../../models/membership.dart';
import '../../providers/user_provider.dart';
import '../../utils/const.dart' as Constant;
import '../../widgets/navigative_action_card.dart';
import '../../widgets/promotion_card.dart';
import 'web_view_screen.dart';

class AccumlativePointTabScreen extends StatelessWidget {
  static const routeName = '/accumulative_point';

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
                          onPressed: () =>
                              DefaultTabController.of(context).animateTo(1),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: NavigativeActionCard(
                          icon: FlutterIcons.news_ent,
                          color: Colors.redAccent[200],
                          title: 'Tin tức & Khuyến mãi',
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WebViewScreen(
                                'Tin tức & khuyến mãi',
                                'https://www.thecoffeehouse.com/blogs/news',
                              ),
                            ),
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
                          title: 'Lịch sử tích luỹ điểm',
                          color: Colors.green.shade300,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => PointHistory())),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: NavigativeActionCard(
                          icon: FlutterIcons.law_oct,
                          title: 'Quyền lợi của bạn',
                          color: Colors.purple.shade400,
                          onPressed: () => Navigator.of(context).push(
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
                  Consumer<Promotions>(
                    builder: (_, promotionsProvider, child) => ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) => PromotionCard(
                          promotionsProvider.firstThreePromotions[index]),
                      itemCount: promotionsProvider.firstThreePromotions.length,
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
                child: UserInfoCard(),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Còn ${(2000 - user.user.point < 0) ? 0 : 2000 - user.user.point} BEAN nữa bạn sẽ thăng hạng.\n'
                    'Đổi quà không ảnh hưởng tới việc thăng hạng của bạn.\n180 BEAN tích lũy từ 1/7/2021-30/9/2022 sẽ hết hạn vào ngày 30/03/2023. '
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
