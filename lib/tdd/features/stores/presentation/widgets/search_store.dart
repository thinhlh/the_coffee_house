import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/stores/presentation/providers/stores_provider.dart';
import 'package:the/tdd/features/stores/presentation/widgets/store_card.dart';
import 'package:the/utils/values/dimens.dart';

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
        Provider.of<StoresProvider>(context, listen: false).searchStore(query);

    return ListView.builder(
      padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
      itemBuilder: (_, index) => StoreCard(
        store: stores[index],
        isUsedForChoosingLocation: false,
      ),
      itemCount: stores.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final stores =
        Provider.of<StoresProvider>(context, listen: false).searchStore(query);

    return ListView.builder(
      padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
      itemBuilder: (_, index) => StoreCard(
        store: stores[index],
        isUsedForChoosingLocation: this.isUsedForChoosingLocation,
      ),
      itemCount: stores.length,
    );
  }
}
