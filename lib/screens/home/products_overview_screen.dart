import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products.dart';
import '../../utils/const.dart' as Constant;
import '../../widgets/cart_bottom_navigation.dart';
import '../../widgets/product_card.dart';

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
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            arguments['tittle'] as String,
          ),
        ),
        bottomNavigationBar: CartBottomNavigation(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Constant.SIZED_BOX_HEIGHT,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (_, index) => ProductCard(products[index].id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
