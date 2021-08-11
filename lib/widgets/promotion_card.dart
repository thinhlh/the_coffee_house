import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:the/screens/home/order_screen.dart';
import 'package:the/utils/global_vars.dart';

import '../models/promotion.dart';
import '../screens/home/promotion_info_screen.dart';
import '../utils/const.dart' as Constant;

class PromotionCard extends StatelessWidget {
  final Promotion promotion;
  bool isUsedForChoosingPromotion = false;
  PromotionCard(this.promotion, {this.isUsedForChoosingPromotion = false});

  @override
  Widget build(BuildContext context) {
    final timeLeft = promotion.expiryDate.difference(DateTime.now()).inHours;
    return GestureDetector(
      onTap: () => showBarModalBottomSheet(
        context: context,
        builder: (_) => PromotionInfoScreen(
          promotion,
          isUsedForChoosingPromotion: isUsedForChoosingPromotion,
        ),
      ).then((value) {
        if (value != null)
          Navigator.of(context).pop(value);
        else if (value == null && isUsedForChoosingPromotion == true)
          tabScreenState.currentState.navigateToScreen(OrderScreen.routeName);
      }),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: Constant.GENERAL_PADDING / 2,
          ),
          child: Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Padding(
                    padding: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
                    child: Image.network(
                      promotion.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, exception, stackTrace) => Center(
                        child: Text(
                          'Unable to load image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 2,
                width: 2,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        promotion.title,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        timeLeft < 24
                            ? 'Hết hạn trong $timeLeft tiếng'
                            : 'Hết hạn trong ${(timeLeft / 24).floor()} ngày',
                        style: TextStyle(
                          color: timeLeft >= 24 ? Colors.black : Colors.red,
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
