import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/models/membership.dart';
import 'package:the/providers/user_provider.dart';
import 'package:the/utils/const.dart' as Constant;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2 * Constant.BORDER_RADIUS),
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
      ),
    );
  }
}
