import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the/screens/home/order_screen.dart';
import 'package:the/utils/global_vars.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/store.dart';
import '../../utils/const.dart' as Constant;

class StoreInfoScreen extends StatelessWidget {
  final Store store;

  StoreInfoScreen(this.store);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(Constant.GENERAL_PADDING),
        child: FloatingActionButton.extended(
          splashColor: Colors.transparent,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
          ),
          onPressed: () {
            sharedPref
                .setIsPreferDelivered(false)
                .then((value) => sharedPref.setTakeAwayLocation(store.id))
                .then((value) => tabScreenState.currentState
                    .navigateToScreen(OrderScreen.routeName))
                .then((value) => Navigator.of(context).pop(store.id));
          },
          label: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Đặt món'),
              Text('Tự đến lấy tại cửa hàng này'),
            ],
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
            padding: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE COFFEE HOUSE',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  store.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Giờ mở cửa: 7:00 - 22:00',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: Constant.GENERAL_PADDING),
            child: Column(
              children: [
                ListTile(
                  onTap: () => Platform.isIOS
                      ? UrlLauncher.launch(
                          'http://maps.apple.com/?q=The+Coffee+House&ll=' +
                              store.location.latitude.toString() +
                              ',' +
                              store.location.longitude.toString() +
                              '&z=20&t=s',
                        )
                      : UrlLauncher.launch('geo: ' +
                          store.location.latitude.toString() +
                          ',' +
                          store.location.longitude.toString() +
                          '?z=20'),
                  leading: Container(
                    margin: const EdgeInsets.only(
                      bottom: 4 * Constant.GENERAL_PADDING,
                    ),
                    child: Icon(
                      Icons.directions_outlined,
                      size: 34,
                    ),
                  ),
                  title: Text(
                    store.address,
                    maxLines: 2,
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.only(
                      top: 2 * Constant.GENERAL_PADDING,
                    ),
                    color: Colors.grey.shade300,
                    height: 1,
                  ),
                ),
                ListTile(
                  onTap: () => UrlLauncher.launch('tel:02871087088'),
                  leading: Container(
                    margin: const EdgeInsets.only(
                      bottom: 4 * Constant.GENERAL_PADDING,
                    ),
                    child: Icon(
                      Icons.phone,
                      size: 34,
                    ),
                  ),
                  title: Text(
                    'Liên hệ',
                    maxLines: 2,
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.only(
                      top: 2 * Constant.GENERAL_PADDING,
                    ),
                    color: Colors.grey.shade300,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2 * Constant.SIZED_BOX_HEIGHT),
        ],
      ),
    );
  }
}
