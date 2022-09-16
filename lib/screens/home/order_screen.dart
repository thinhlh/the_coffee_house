import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/helpers/search_product.dart';
import 'package:the/screens/home/recently_ordered_products.dart';

import '../../helpers/admin_search_product.dart';
import '../../utils/const.dart' as Constant;
import '../../widgets/cart_bottom_navigation.dart';
import '../../widgets/category_list_view.dart';
import '../../widgets/navigative_action_card.dart';
import '../../widgets/order_card_navigation.dart';
import 'favorites_screen.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartBottomNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 0.17.sh,
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
                height: 0.06.sh,
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
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecentlyOrderedProduct(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: NavigativeActionCard(
                    icon: Icons.favorite,
                    title: 'Yêu thích',
                    color: Colors.amber,
                    onPressed: () => Navigator.of(context)
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
