import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:the/tdd/common/presentation/pages/tab_screen.dart';
import 'package:the/tdd/features/order/presentation/providers/cart_provider.dart';
import 'package:the/tdd/features/products/presentation/pages/order_page.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';
import 'package:the/tdd/features/promotion/presentation/pages/promotion_info_page.dart';
import 'package:the/utils/values/dimens.dart';
import 'package:provider/provider.dart';

class PromotionCard extends StatelessWidget {
  final Promotion promotion;
  final bool isUsedForChoosingPromotion;
  PromotionCard(this.promotion, {this.isUsedForChoosingPromotion = false});

  @override
  Widget build(BuildContext context) {
    final timeLeft = promotion.expiryDate.difference(DateTime.now()).inHours;
    return GestureDetector(
      onTap: () => showBarModalBottomSheet(
        context: context,
        builder: (_) => PromotionInfoPage(
          promotion,
          isUsedForChoosingPromotion: isUsedForChoosingPromotion,
        ),
      ).then((value) {
        if (value != null) {
          //User have choose a promotion
          Navigator.of(context).pop(value);
          context.read<CartProvider>().promotion = value;
        } else if (value == null && isUsedForChoosingPromotion == false) {
          //User just want to view promotion
          tabScreenState.currentState.navigateToScreen(OrderPage.routeName);
        }
      }),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(
            vertical: AppDimens.SMALL_PADDING,
          ),
          child: Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Padding(
                    padding: EdgeInsets.all(AppDimens.LARGE_PADDING),
                    child: Image.network(
                      promotion.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, exception, stackTrace) => Center(
                        child: Text(
                          'Unable to load image',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimens.SMALL_TEXT_SIZE,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: AppDimens.LARGE_PADDING),
                child: VerticalDivider(
                  thickness: 2,
                  width: 2,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        promotion.title,
                        style: TextStyle(
                          fontSize: AppDimens.SMALL_TEXT_SIZE,
                        ),
                      ),
                      Text(
                        timeLeft < 24
                            ? 'Hết hạn trong $timeLeft tiếng'
                            : 'Hết hạn trong ${(timeLeft / 24).floor()} ngày',
                        style: TextStyle(
                          color: timeLeft >= 24 ? Colors.black : Colors.red,
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                        ),
                      ),
                    ],
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
