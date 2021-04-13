import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:the_coffee_house/models/coupon.dart';

import 'package:the_coffee_house/utils/const.dart' as Constant;

class RewardInfoScreen extends StatelessWidget {
  final Coupon _coupon;

  RewardInfoScreen(this._coupon);

  @override
  Widget build(BuildContext context) {
    final timeLeft = _coupon.expiryDate.difference(DateTime.now()).inHours;
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(
          horizontal: 3 * Constant.GENERAL_PADDING,
          vertical: 4 * Constant.GENERAL_PADDING,
        ),
        child: Container(
          padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
          ),
          child: ListView(
            children: [
              SizedBox(height: 2 * Constant.SIZED_BOX_HEIGHT),
              Center(
                child: Text(
                  'The Coffee House',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: Constant.SIZED_BOX_HEIGHT),
              Center(
                child: Text(
                  _coupon.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: Constant.SIZED_BOX_HEIGHT),
              Divider(
                color: Colors.black.withOpacity(0.4),
                thickness: 1,
                height: 10,
              ),
              SizedBox(height: 2 * Constant.SIZED_BOX_HEIGHT),
              Center(
                child: BarcodeWidget(
                  width: MediaQuery.of(context).size.width,
                  barcode: Barcode.qrCode(),
                  data: _coupon.code,
                ),
              ),
              SizedBox(height: Constant.SIZED_BOX_HEIGHT),
              Center(
                child: Text(
                  _coupon.code,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                child: Text(
                  'Sao Chép',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                  ),
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Mã ${_coupon.code} đã được sao chép',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Constant.SIZED_BOX_HEIGHT),
              Center(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    'Bắt đầu đặt hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        horizontal: 3 * Constant.GENERAL_PADDING,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Constant.SIZED_BOX_HEIGHT),
              Divider(
                color: Colors.black.withOpacity(0.2),
                thickness: 1,
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Constant.GENERAL_PADDING,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ngày hết hạn: '),
                    Text(
                      timeLeft < 24
                          ? 'Hết hạn trong $timeLeft tiếng'
                          : 'Trong ${(timeLeft / 24).floor()} ngày',
                      style: TextStyle(
                        color: timeLeft >= 24
                            ? Theme.of(context).primaryColor
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black.withOpacity(0.2),
                thickness: 1,
                height: 10,
              ),
              SizedBox(height: Constant.SIZED_BOX_HEIGHT),
              Padding(
                padding: const EdgeInsets.all(
                  Constant.GENERAL_PADDING,
                ),
                child: Text(
                  '- ' + _coupon.conditions.join('\n- '),
                ),
              ),
              SizedBox(height: Constant.SIZED_BOX_HEIGHT),
            ],
          ),
        ),
      ),
    );
  }
}