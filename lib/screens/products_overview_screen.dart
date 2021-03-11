import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/order_card_navigation_provider.dart';
import 'package:the_coffee_house/widgets/bottom_sheet_product.dart';
import 'package:the_coffee_house/widgets/order_card_navigation.dart';
import 'package:the_coffee_house/providers/products.dart';
import 'package:the_coffee_house/widgets/product_card.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const routeName = '/products_screen';

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final products = Provider.of<Products>(context, listen: false)
        .getProductsByCategory((arguments['categoryId']));
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(
          Provider.of<OrderCardNavigationProvider>(context, listen: false)
              .isDelivery,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            arguments['tittle'] as String,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: Constant.TEXT_SIZE,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.17,
                child: OrderCardNavigation(),
              ),
              SizedBox(
                height: Constant.SIZED_BOX_HEIGHT,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (_, index) => ProductCard(products[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
