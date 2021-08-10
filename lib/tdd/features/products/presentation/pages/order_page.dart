import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:the/tdd/common/presentation/widgets/action_card.dart';
import 'package:the/tdd/features/order/presentation/widgets/order_card_navigation.dart';
import 'package:the/tdd/features/order/presentation/widgets/cart_bottom_navigation.dart';
import 'package:the/tdd/features/products/domain/entities/category.dart';
import 'package:the/tdd/features/products/presentation/pages/favorites_page.dart';
import 'package:the/tdd/features/products/presentation/providers/products_provider.dart';

import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/tdd/features/products/presentation/widgets/category_card.dart';
import 'package:the/tdd/features/products/presentation/widgets/search_product.dart';
import 'package:the/utils/values/dimens.dart';

class OrderPage extends StatelessWidget {
  static const routeName = '/order_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartBottomNavigation(),
      body: ListView(
        padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
        children: [
          SizedBox(
            height: 0.17.sh,
            child: OrderCardNavigation(),
          ),
          SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
          GestureDetector(
            onTap: () => showSearch(
              context: context,
              delegate: SearchProduct(),
            ),
            child: Container(
              height: 0.06.sh,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
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
                      fontSize: AppDimens.SMALL_TEXT_SIZE,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimens.SMALL_SIZED_BOX_HEIGHT),
          Row(
            children: [
              Expanded(
                child: ActionCard(
                  title: 'Các món vừa đặt',
                  color: Colors.blue.shade300,
                  icon: FlutterIcons.coffee_mco,
                  onPressed: () {},

                  ///TODO navigate to recently ordered products
                  // onPressed: () => Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => RecentlyOrderedProduct(),
                  //   ),
                  // ),
                ),
              ),
              Expanded(
                child: ActionCard(
                  icon: Icons.favorite,
                  title: 'Yêu thích',
                  color: Colors.amber,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(FavoritePage.routeName),
                ),
              )
            ],
          ),
          SizedBox(height: AppDimens.SMALL_SIZED_BOX_HEIGHT),
          Selector<ProductsProvider, List<Category>>(
            selector: (_, productsProvider) => productsProvider.categories,
            builder: (_, categories, __) => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => CategoryCard(
                categories[index],
                context
                    .read<ProductsProvider>()
                    .getNumberOfProductsEachCategory(
                      categories[index].id,
                    ),
              ),
              itemCount: categories.length,
            ),
          ),
        ],
      ),
    );
  }
}
