import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:the/models/delivery_detail.dart';
import 'package:the/providers/stores.dart';
import 'package:the/screens/home/add_new_delivery_address.dart';
import 'package:the/screens/home/choose_delivery_address_screen.dart';
import 'package:the/screens/home/stores_screen.dart';
import 'package:the/utils/global_vars.dart';

import '../utils/const.dart' as Constant;

class OrderCardNavigation extends StatelessWidget {
  final List<Tab> _tabs = [
    Tab(text: 'GIAO TẬN NƠI'),
    Tab(text: 'TỰ ĐẾN LẤY'),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
      ),
      color: const Color.fromRGBO(135, 111, 93, 1),
      elevation: Constant.ELEVATION,
      semanticContainer: true,
      child: DefaultTabController(
        initialIndex: sharedPref.isPreferDelivered ? 0 : 1,
        length: 2,
        child: Column(
          children: [
            TabBar(
              onTap: (index) async => await sharedPref.setIsPreferDelivered(
                index == 0 ? true : false,
              ),
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: Constant.GENERAL_PADDING),
              indicatorWeight: 1.5,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: _tabs,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _OrderActionCard(
                    true,
                    sharedPref.latestDeliveryDetail,
                  ),
                  _OrderActionCard(
                    false,
                    sharedPref.takeAwayLocation,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderActionCard extends StatefulWidget {
  Object location;
  //This can be String (store id) either DeliveryDetail (delivery)
  final bool isDeliveryCard;

  _OrderActionCard(this.isDeliveryCard, this.location);

  @override
  __OrderActionCardState createState() => __OrderActionCardState();
}

class __OrderActionCardState extends State<_OrderActionCard> {
  @override
  Widget build(BuildContext context) {
    String text = '';

    if (widget.isDeliveryCard) {
      /// This is delivery card => location is DeliveryDetail => info is the address of latest delivery detail otherwise [DefaultText]
      if ((widget.location as DeliveryDetail) == null) {
        text = 'Chọn địa chỉ';
      } else {
        text = (widget.location as DeliveryDetail).address;
      }
    } else {
      /// This is take away card => location is store id
      if ((widget.location as String) == null ||
          (widget.location as String).isEmpty) {
        text = 'Chọn cửa hàng';
      } else {
        final provider = Provider.of<Stores>(context, listen: false);
        try {
          text = provider.getNameById(widget.location);
        } catch (StateError) {
          text = 'Chọn của hàng';
        }
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.isDeliveryCard
                      ? 'ĐẾN ĐỊA CHỈ'
                      : 'TẠI THE COFFEE HOUSE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  softWrap: false,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            child: Chip(
              label: Text(
                'THAY ĐỔI',
                style: TextStyle(color: Colors.black),
              ),
              elevation: Constant.ELEVATION,
              //backgroundColor: Colors.brown,
            ),
            onTap: () => showBarModalBottomSheet(
              context: context,
              builder: (_) => widget.isDeliveryCard
                  ? ChooseDeliveryAddress()
                  : StoresScreen(
                      isUsedForChoosingLocation: true,
                    ),
            ).then(
              (value) async {
                if (value != null) {
                  Future<bool> setFuture;
                  if (sharedPref.isPreferDelivered) {
                    setFuture = sharedPref
                        .setLatestDeliveryDetail(value as DeliveryDetail);
                  } else {
                    setFuture = sharedPref.setTakeAwayLocation(value as String);
                  }
                  setFuture.then(
                    (_) => setState(
                      () => widget.location = sharedPref.isPreferDelivered
                          ? sharedPref.latestDeliveryDetail
                          : sharedPref.takeAwayLocation,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
