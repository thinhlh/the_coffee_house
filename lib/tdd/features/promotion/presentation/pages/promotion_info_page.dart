import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';
import 'package:the/utils/values/dimens.dart';

class PromotionInfoPage extends StatelessWidget {
  static const routeName = '/promotion_info_page';

  final Promotion _promotion;
  final bool isUsedForChoosingPromotion;

  PromotionInfoPage(this._promotion, {this.isUsedForChoosingPromotion = false});

  @override
  Widget build(BuildContext context) {
    final timeLeft = _promotion.expiryDate.difference(DateTime.now()).inHours;
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        padding: EdgeInsets.symmetric(
          horizontal: 3 * AppDimens.MEDIUM_PADDING,
          vertical: AppDimens.EXTRA_LARGE_PADDING,
        ),
        child: Container(
          padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
          ),
          child: ListView(
            children: [
              SizedBox(height: AppDimens.LARGE_SIZED_BOX_HEIGHT),
              Center(
                child: Text(
                  'The Coffee House',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                    fontSize: AppDimens.SMALL_TEXT_SIZE,
                  ),
                ),
              ),
              SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
              Center(
                child: Text(
                  _promotion.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                  ),
                ),
              ),
              SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
              Divider(
                color: Colors.black.withOpacity(0.4),
                thickness: 1,
                height: 10,
              ),
              SizedBox(height: AppDimens.LARGE_SIZED_BOX_HEIGHT),
              Center(
                child: BarcodeWidget(
                  width: 1.sw,
                  barcode: Barcode.qrCode(),
                  data: _promotion.code,
                ),
              ),
              SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
              Center(
                child: Text(
                  _promotion.code,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens.SMALL_TEXT_SIZE,
                  ),
                ),
              ),
              TextButton(
                child: Text(
                  'Sao Chép',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
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
                        style: TextStyle(
                            fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
              Center(
                child: OutlinedButton(
                  onPressed: () => isUsedForChoosingPromotion
                      ? Navigator.of(context).pop(_promotion)
                      : Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                    child: Text(
                      isUsedForChoosingPromotion
                          ? 'Chọn mã'
                          : 'Bắt đầu đặt hàng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimens.SMALL_TEXT_SIZE,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        horizontal: 3 * AppDimens.MEDIUM_PADDING,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
              Divider(
                color: Colors.black.withOpacity(0.2),
                thickness: 1,
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppDimens.MEDIUM_PADDING,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ngày hết hạn: ',
                      style:
                          TextStyle(fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE),
                    ),
                    Text(
                      timeLeft < 24
                          ? 'Hết hạn trong $timeLeft tiếng'
                          : 'Trong ${(timeLeft / 24).floor()} ngày',
                      style: TextStyle(
                        fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
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
              SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
              Padding(
                padding: EdgeInsets.all(
                  AppDimens.MEDIUM_PADDING,
                ),
                child: Text(
                  _promotion.description,
                  style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                ),
              ),
              SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
            ],
          ),
        ),
      ),
    );
  }
}
