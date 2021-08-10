import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.w),
      child: Stack(
        children: [
          Container(
            width: 40.w,
            height: 2.5.h,
            color: Theme.of(context).primaryColor,
          ),
          Container(),
        ],
      ),
    );
  }
}
