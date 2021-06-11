import 'package:flutter/cupertino.dart';
import 'package:the_coffee_house/services/firestore_stores.dart';

import '../models/store.dart';

class Stores with ChangeNotifier {
  List<Store> _stores = [];

  List<Store> get stores => [..._stores];

  Stores.fromList(this._stores);

  Future<void> fetchStores() {
    return FireStoreStores()
        .firestore
        .collection('stores')
        .get()
        .then((value) => this._stores = value.docs.map((e) {
              Map<String, dynamic> json = e.data();
              json['id'] = e.id;
              return Store.fromJson(json);
            }).toList());
  }

  List<Store> searchStoreByTitle(String searchString) {
    return [..._stores]
        .where((store) => store.address
            .trim()
            .toLowerCase()
            .contains(searchString.toLowerCase()))
        .toList();
  }
}
