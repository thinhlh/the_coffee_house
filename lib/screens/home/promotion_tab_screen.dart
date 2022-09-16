import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:the/helpers/search_promotion.dart';
import 'package:the/providers/promotions.dart';
import 'package:the/screens/home/search_promotion_bottom_sheet.dart';

import '../../utils/const.dart' as Constant;
import '../../widgets/promotion_card.dart';

class PromotionTabScreen extends StatelessWidget {
  bool isUsedForChoosingPromotion = false;
  PromotionTabScreen({this.isUsedForChoosingPromotion = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      child: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ListTile(
              onTap: () => showBarModalBottomSheet(
                context: context,
                builder: (_) => SearchPromotionBottomSheet(),
              ),
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
          Consumer<Promotions>(
            builder: (_, promotionsProvider, child) => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => PromotionCard(
                promotionsProvider.nearlyOutOfDate[index],
                isUsedForChoosingPromotion: isUsedForChoosingPromotion,
              ),
              itemCount: promotionsProvider.nearlyOutOfDate.length,
            ),
          ),
          SizedBox(height: Constant.SIZED_BOX_HEIGHT),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.GENERAL_PADDING),
            child: Text(
              'Sẵn sàng sử dụng',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(height: Constant.SIZED_BOX_HEIGHT),
          Consumer<Promotions>(
            builder: (_, promotionsProvider, child) => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => PromotionCard(
                promotionsProvider.promotions[index],
                isUsedForChoosingPromotion: isUsedForChoosingPromotion,
              ),
              itemCount: promotionsProvider.promotions.length,
            ),
          ),
        ],
      ),
    );
  }
}
