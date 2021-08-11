import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/providers/promotions.dart';
import 'package:the/providers/stores.dart';
import 'package:the/screens/admin/admin_promotions_screen.dart';
import 'package:the/screens/admin/admin_stores_screen.dart';
import 'package:the/widgets/admin/admin_product_card.dart';
import 'package:the/widgets/store_card.dart';

import '../providers/products.dart';
import '../utils/const.dart' as Constant;
import '../widgets/product_card.dart';

class SearchStore extends SearchDelegate {
  final bool isUsedForChoosingLocation;
  SearchStore(this.isUsedForChoosingLocation);

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
    final stores =
        Provider.of<Stores>(context, listen: false).searchStore(query);

    return ListView.builder(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      itemBuilder: (_, index) => AdminStoreCard(stores[index]),
      itemCount: stores.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final stores =
        Provider.of<Stores>(context, listen: false).searchStore(query);

    return ListView.builder(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      itemBuilder: (_, index) => StoreCard(
        store: stores[index],
        isUsedForChoosingLocation: this.isUsedForChoosingLocation,
      ),
      itemCount: stores.length,
    );
  }
}
