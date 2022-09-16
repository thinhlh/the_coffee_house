import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/promotion.dart';
import '../../utils/const.dart' as Constant;

class PromotionInfoScreen extends StatelessWidget {
  final Promotion _promotion;
  bool isUsedForChoosingPromotion = false;

  PromotionInfoScreen(this._promotion,
      {this.isUsedForChoosingPromotion = false});

  @override
  Widget build(BuildContext context) {
    final timeLeft = _promotion.expiryDate.difference(DateTime.now()).inHours;
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
                  _promotion.title,
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
                  width: 1.sw,
                  barcode: Barcode.qrCode(),
                  data: _promotion.code,
                ),
              ),
              SizedBox(height: Constant.SIZED_BOX_HEIGHT),
              Center(
                child: Text(
                  _promotion.code,
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
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _promotion.code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Mã ${_promotion.code} đã được sao chép',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: Constant.SIZED_BOX_HEIGHT),
              Center(
                child: OutlinedButton(
                  onPressed: () => isUsedForChoosingPromotion
                      ? Navigator.of(context).pop(_promotion)
                      : Navigator.of(context).pop(),
                  child: Text(
                    isUsedForChoosingPromotion ? 'Chọn mã' : 'Bắt đầu đặt hàng',
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
                  '- ' + _promotion.description,
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
