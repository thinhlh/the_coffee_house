import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:the_coffee_house/utils/const.dart' as Constant;
import 'package:the_coffee_house/models/search_product.dart';
import 'package:the_coffee_house/screens/home/favorites_screen.dart';
import 'package:the_coffee_house/screens/home/google_map.dart';
import 'package:the_coffee_house/widgets/cart_bottom_navigation.dart';
import 'package:the_coffee_house/widgets/order_card_navigation.dart';
import 'package:the_coffee_house/widgets/navigative_action_card.dart';

import '../../widgets/category_list_view.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order_screen';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      bottomNavigationBar: CartBottomNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: mediaQuery.size.height * 0.17,
              child: OrderCardNavigation(),
            ),
            SizedBox(
              height: Constant.SIZED_BOX_HEIGHT,
            ),
            GestureDetector(
              onTap: () => showSearch(
                context: context,
                delegate: SearchProduct(),
              ),
              child: Container(
                height: mediaQuery.size.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                  color: Colors.grey[300],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      'Tìm kiếm',
                      style: TextStyle(
                        fontSize: Constant.TEXT_SIZE,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Constant.SIZED_BOX_HEIGHT,
            ),
            Row(
              children: [
                Expanded(
                  child: NavigativeActionCard(
                    title: 'Các món vừa đặt',
                    color: Colors.blue.shade300,
                    icon: FlutterIcons.coffee_mco,
                    navigate: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => GoogleMapWidget())),
                  ),
                ),
                Expanded(
                  child: NavigativeActionCard(
                    icon: Icons.favorite,
                    title: 'Yêu thích',
                    color: Colors.amber,
                    navigate: () => Navigator.of(context)
                        .pushNamed(FavoriteScreen.routeName),
                  ),
                )
              ],
            ),
            SizedBox(
              height: Constant.SIZED_BOX_HEIGHT,
            ),
            CategoryListView(),
          ],
        ),
      ),
    );
  }
}
