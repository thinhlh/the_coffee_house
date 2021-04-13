import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/utils/const.dart' as Constant;
import 'package:the_coffee_house/providers/order_card_navigation_provider.dart';

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
      child:
          Consumer<OrderCardNavigationProvider>(builder: (_, provider, child) {
        return DefaultTabController(
          initialIndex: (provider.isDelivery) ? 0 : 1,
          length: 2,
          child: Column(
            children: [
              TabBar(
                onTap: (index) {
                  if ((index == 0 && provider.isDelivery == false) ||
                      (index == 1 && provider.isDelivery == true)) {
                    provider.checkAndUpdateOption(!provider.isDelivery);
                  }
                },
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
                      'ĐẾN ĐỊA CHỈ',
                      '86-88 Cao Thắng, Phường 04, Quận 10, TPHCM',
                    ),
                    _OrderActionCard(
                      'TẠI THE COFFEE HOUSE',
                      '86 Cao Thắng',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _OrderActionCard extends StatelessWidget {
  final String title;
  final String location;

  _OrderActionCard(this.title, this.location);

  @override
  Widget build(BuildContext context) {
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
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  location,
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
          child: Chip(
            label: Text(
              'THAY ĐỔI',
              style: TextStyle(color: Colors.black),
            ),
            elevation: Constant.ELEVATION,
            //backgroundColor: Colors.brown,
          ),
        ),
      ],
    );
  }
}
