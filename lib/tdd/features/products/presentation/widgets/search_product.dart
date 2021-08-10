import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/products/presentation/providers/products_provider.dart';
import 'package:the/utils/values/dimens.dart';
import '../widgets/product_card.dart';

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
    final products = Provider.of<ProductsProvider>(context, listen: false)
        .searchProducts(query);

    return ListView.builder(
      padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
      itemBuilder: (_, index) => ProductCard(products[index]),
      itemCount: products.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context, listen: false)
        .searchProducts(query);

    return ListView.builder(
      padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
      itemBuilder: (_, index) => ProductCard(products[index]),
      itemCount: products.length,
    );
  }
}
