import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/coupons.dart';
import '../../utils/const.dart' as Constant;
import '../../widgets/reward_card.dart';

class CouponTabScreen extends StatelessWidget {
  static final readyForUseKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      child: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ListTile(
              horizontalTitleGap: 0,
              tileColor: Colors.white,
              leading: Icon(
                Icons.chrome_reader_mode_sharp,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
              trailing: Icon(
                Icons.navigate_next,
              ),
              title: Text('Nhập mã khuyến mãi'),
            ),
          ),
          SizedBox(
            height: Constant.SIZED_BOX_HEIGHT,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.GENERAL_PADDING),
            child: Text(
              'Sắp hết hạn',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(height: Constant.SIZED_BOX_HEIGHT),
          Consumer<Coupons>(
            builder: (_, couponsProvider, child) => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) =>
                  RewardCard(couponsProvider.nearlyOutOfDate[index]),
              itemCount: couponsProvider.nearlyOutOfDate.length,
            ),
          ),
          SizedBox(height: Constant.SIZED_BOX_HEIGHT),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.GENERAL_PADDING),
            child: Text(
              'Sẵn sàng sử dụng',
              key: readyForUseKey,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(height: Constant.SIZED_BOX_HEIGHT),
          Consumer<Coupons>(
            builder: (_, couponsProvider, child) => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) =>
                  RewardCard(couponsProvider.coupons[index]),
              itemCount: couponsProvider.coupons.length,
            ),
          ),
        ],
      ),
    );
  }
}
