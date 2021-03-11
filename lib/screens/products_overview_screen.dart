import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/order_card_navigation_provider.dart';
import 'package:the_coffee_house/widgets/bottom_sheet_product.dart';
import 'package:the_coffee_house/widgets/order_card_navigation.dart';
import 'package:the_coffee_house/providers/products.dart';

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
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => BottomSheetProduct(products[index].id,
                        MediaQuery.of(context).viewPadding.top),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Constant.BORDER_RADIUS),
                    ),
                    isScrollControlled: true,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.17,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Constant.BORDER_RADIUS),
                      ),
                      elevation: Constant.ELEVATION,
                      child: Padding(
                        padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      products[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Text(
                                      products[index].description,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: Constant.LIST_TILE_TITTLE),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      NumberFormat.currency(
                                        locale: 'vi-VN',
                                        decimalDigits: 0,
                                      ).format(products[index].price),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  Constant.GENERAL_PADDING),
                              child: ClipRRect(
                                child: Image.network(
                                  products[index].imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
