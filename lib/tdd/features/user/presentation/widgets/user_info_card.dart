import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';
import 'package:the/tdd/features/auth/presentation/providers/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/utils/const.dart';

class UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<UserProvider, CustomUser>(
      selector: (_, provider) => provider.user,
      builder: (_, user, __) => Container(
        width: 1.sw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        height: (1 / 3).sh,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: BarcodeWidget(
                data: user.uid,
                barcode: Barcode.code128(),
                drawText: false,
                padding: EdgeInsets.symmetric(
                  horizontal: 3 * AppDimens.MEDIUM_PADDING,
                  vertical: AppDimens.LARGE_PADDING,
                ),
              ),
            ),
            //Text(user.uid),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20.r),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.7),
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Hạng ${user.membership == Membership.Bronze ? 'Đồng' : user.membership == Membership.Silver ? 'Bạc' : user.membership == Membership.Gold ? 'Vàng' : 'Kim cương'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimens.SMALL_TEXT_SIZE,
                      ),
                    ),
                    Text(
                      '${user.point} BEAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimens.SMALL_TEXT_SIZE,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
