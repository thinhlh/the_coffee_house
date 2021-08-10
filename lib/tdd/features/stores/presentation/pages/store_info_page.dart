import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the/tdd/common/presentation/pages/tab_screen.dart';
import 'package:the/tdd/features/order/presentation/providers/cart_provider.dart';
import 'package:the/tdd/features/products/presentation/pages/order_page.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';
import 'package:the/utils/const.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class StoreInfoPage extends StatelessWidget {
  static const routeName = "/store_info_page";

  final Store store;

  StoreInfoPage(this.store);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: double.infinity,
        margin: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
        child: FloatingActionButton.extended(
          splashColor: Colors.transparent,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
          ),
          onPressed: () {
            context.read<CartProvider>().isPreferDelivered = false;
            context.read<CartProvider>().choosenTakeAwayStoreId = store.id;
            Navigator.of(context).pop(store.id);
            tabScreenState.currentState.navigateToScreen(OrderPage.routeName);
          },
          label: Padding(
            padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Đặt món',
                  style: TextStyle(fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE),
                ),
                Text(
                  'Tự đến lấy tại cửa hàng này',
                  style: TextStyle(fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Image.network(
            store.imageUrl,
            height: 0.5.sh,
            fit: BoxFit.cover,
            errorBuilder: (_, exception, stackTrace) => Center(
              child: Text(
                'Unable to load image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppDimens.LARGE_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'THE COFFEE HOUSE',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  store.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Giờ mở cửa: 7:00 - 22:00',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.MEDIUM_PADDING),
            child: Column(
              children: [
                ListTile(
                  onTap: () => Platform.isIOS
                      ? UrlLauncher.launch(
                          'http://maps.apple.com/?q=The+Coffee+House&ll=' +
                              store.coordinate.latitude.toString() +
                              ',' +
                              store.coordinate.longitude.toString() +
                              '&z=20&t=s',
                        )
                      : UrlLauncher.launch('geo: ' +
                          store.coordinate.latitude.toString() +
                          ',' +
                          store.coordinate.longitude.toString() +
                          '?z=20'),
                  leading: Container(
                    margin: EdgeInsets.only(
                      bottom: 2 * AppDimens.LARGE_PADDING,
                    ),
                    child: Icon(
                      Icons.directions_outlined,
                      size: 34.r,
                    ),
                  ),
                  title: Text(
                    store.address,
                    maxLines: 2,
                    style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                      top: AppDimens.LARGE_PADDING,
                    ),
                    color: Colors.grey.shade300,
                    height: 1,
                  ),
                ),
                ListTile(
                  onTap: () => UrlLauncher.launch('tel:02871087088'),
                  leading: Container(
                    margin: EdgeInsets.only(
                      bottom: 2 * AppDimens.LARGE_TEXT_SIZE,
                    ),
                    child: Icon(
                      Icons.phone,
                      size: 34,
                    ),
                  ),
                  title: Text(
                    'Liên hệ',
                    maxLines: 2,
                    style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                      top: AppDimens.LARGE_TEXT_SIZE,
                    ),
                    color: Colors.grey.shade300,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimens.LARGE_TEXT_SIZE),
        ],
      ),
    );
  }
}
