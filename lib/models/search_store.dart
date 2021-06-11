import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/providers/stores.dart';
import 'package:the_coffee_house/widgets/store_card.dart';
import 'package:the_coffee_house/utils/const.dart' as Constant;

class SearchStore extends SearchDelegate {
  final bool isUsedForChossingLocation;
  SearchStore(this.isUsedForChossingLocation);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: Icon(Icons.clear),
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
        Provider.of<Stores>(context, listen: false).searchStoreByTitle(query);

    return ListView.builder(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      itemBuilder: (_, index) => StoreCard(
        store: stores[index],
        isUsedForChoosingLocation: isUsedForChossingLocation,
      ),
      itemCount: stores.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final stores =
        Provider.of<Stores>(context, listen: false).searchStoreByTitle(query);

    return ListView.builder(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      itemBuilder: (_, index) => StoreCard(
        store: stores[index],
        isUsedForChoosingLocation: isUsedForChossingLocation,
      ),
      itemCount: stores.length,
    );
  }
}
