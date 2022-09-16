import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/widgets/admin/admin_product_card.dart';

import '../providers/products.dart';
import '../utils/const.dart' as Constant;
import '../widgets/product_card.dart';

class AdminSearchProduct extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_outlined),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final products =
        Provider.of<Products>(context, listen: false).searchProducts(query);

    return ListView.builder(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      itemBuilder: (_, index) => AdminProductCard(products[index]),
      itemCount: products.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final products =
        Provider.of<Products>(context, listen: false).searchProducts(query);

    return ListView.builder(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      itemBuilder: (_, index) => AdminProductCard(products[index]),
      itemCount: products.length,
    );
  }
}
