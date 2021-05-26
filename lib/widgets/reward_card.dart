import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/coupon.dart';
import '../screens/home/reward_info_screen.dart';
import '../utils/const.dart' as Constant;

class RewardCard extends StatelessWidget {
  final Coupon coupon;

  RewardCard(this.coupon);

  @override
  Widget build(BuildContext context) {
    final timeLeft = coupon.expiryDate.difference(DateTime.now()).inHours;
    return GestureDetector(
      onTap: () => showBarModalBottomSheet(
        context: context,
        builder: (_) => RewardInfoScreen(coupon),
      ),
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
                      coupon.imageUrl,
                      fit: BoxFit.cover,
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
                        coupon.title,
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
