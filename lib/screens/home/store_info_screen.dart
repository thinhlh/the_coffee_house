import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:the_coffee_house/utils/const.dart' as Constant;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:the_coffee_house/models/store.dart';

class StoreInfoScreen extends StatelessWidget {
  final Store store;

  StoreInfoScreen(this.store);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

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
          onPressed: () {},
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
          CarouselSlider(
            items: store.imageUrls
                .map(
                  (value) => Image.network(
                    value,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              autoPlay: false,
              enableInfiniteScroll: true,
              height: mediaQuery.size.height / 2,
              viewportFraction: 1,
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
                  store.street,
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
                  onTap: () => UrlLauncher.launch('geo: ' +
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
                    store.fullAddress,
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
                  leading: Container(
                    margin: const EdgeInsets.only(
                      bottom: 4 * Constant.GENERAL_PADDING,
                    ),
                    child: Icon(
                      Icons.star,
                      size: 34,
                    ),
                  ),
                  title: Text(
                    'Thêm vào danh sách yêu thích',
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
                  onTap: () => UrlLauncher.launch('tel: 028 71087088'),
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
                ListTile(
                  leading: Container(
                    margin: const EdgeInsets.only(
                      bottom: 4 * Constant.GENERAL_PADDING,
                    ),
                    child: Icon(
                      Icons.ios_share,
                      size: 34,
                    ),
                  ),
                  title: Text(
                    'Chia sẻ với bạn bè',
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
