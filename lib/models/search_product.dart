import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/products.dart';
import 'package:the_coffee_house/widgets/product_card.dart';

class SearchProduct extends SearchDelegate {
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
        Provider.of<Products>(context).searchProductsByTitle(query);

    return ListView.builder(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      itemBuilder: (_, index) => ProductCard(products[index]),
      itemCount: products.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final products =
        Provider.of<Products>(context).searchProductsByTitle(query);

    return ListView.builder(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      itemBuilder: (_, index) => ProductCard(products[index]),
      itemCount: products.length,
    );
  }
}
