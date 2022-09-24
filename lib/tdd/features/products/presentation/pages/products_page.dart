import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/order/presentation/widgets/cart_bottom_navigation.dart';
import 'package:the/tdd/features/products/domain/entities/product.dart';
import 'package:the/tdd/features/products/presentation/providers/products_provider.dart';
import 'package:the/tdd/features/products/presentation/widgets/product_card.dart';
import 'package:the/utils/const.dart';
import 'package:the/utils/values/dimens.dart';

///This widgets can be navigated from category pages, receive 2 params as arguments
///[categoryId] **String** indicate the category of this page
///[title] **String** the title of this category

class ProductsPage extends StatelessWidget {
  static const routeName = '/products-page';

  @override
  Widget build(BuildContext context) {
    Map<String, String> arguments =
        (ModalRoute.of(context).settings.arguments as Map<String, String>);
    String categoryId = arguments['categoryId'];
    String categoryTitle = arguments['title'];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          categoryTitle,
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: CartBottomNavigation(),
      body: Selector<ProductsProvider, List<Product>>(
        builder: (_, products, __) {
          final productsById = context
              .read<ProductsProvider>()
              .getProductsByCategory(categoryId);
          return ListView.builder(
            itemBuilder: (_, index) => ProductCard(productsById[index]),
            itemCount: productsById.length,
            padding: EdgeInsets.all(AppDimens.SMALL_PADDING),
          );
        },
        selector: (_, provider) => provider.products,
      ),
    );
  }
}
