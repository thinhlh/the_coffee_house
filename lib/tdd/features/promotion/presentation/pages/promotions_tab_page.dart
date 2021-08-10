import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';
import 'package:the/tdd/features/promotion/presentation/pages/search_promotion_page.dart';
import 'package:the/tdd/features/promotion/presentation/providers/promotions_provider.dart';
import 'package:the/tdd/features/promotion/presentation/widgets/promotion_card.dart';
import 'package:the/utils/const.dart';
import 'package:the/utils/values/dimens.dart';

class PromotionTabPage extends StatelessWidget {
  static const routeName = '/promotions_tab_page';

  bool isUsedForChoosingPromotion = false;
  PromotionTabPage({this.isUsedForChoosingPromotion = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
      child: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ListTile(
              onTap: () => showBarModalBottomSheet(
                context: context,
                builder: (_) => SearchPromotionPage(
                    isUsedForChoosingPromotion: isUsedForChoosingPromotion),
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
              title: Text(
                'Nhập mã khuyến mãi',
                style: TextStyle(
                  fontSize: AppDimens.SMALL_TEXT_SIZE,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.MEDIUM_PADDING),
            child: Text(
              'Sắp hết hạn',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimens.MEDIUM_TEXT_SIZE,
              ),
            ),
          ),
          SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
          Selector<PromotionsProvider, List<Promotion>>(
            selector: (_, provider) => provider.nearlyOutOfDate,
            builder: (_, promotions, child) => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => PromotionCard(
                promotions[index],
                isUsedForChoosingPromotion: isUsedForChoosingPromotion,
              ),
              itemCount: promotions.length,
            ),
          ),
          SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.MEDIUM_PADDING),
            child: Text(
              'Sẵn sàng sử dụng',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimens.MEDIUM_TEXT_SIZE,
              ),
            ),
          ),
          SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
          Selector<PromotionsProvider, List<Promotion>>(
            selector: (_, provider) => provider.promotions,
            builder: (_, promotions, child) => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => PromotionCard(
                promotions[index],
                isUsedForChoosingPromotion: isUsedForChoosingPromotion,
              ),
              itemCount: promotions.length,
            ),
          ),
        ],
      ),
    );
  }
}
