import 'package:flutter/cupertino.dart';
import 'package:the/services/stores_api.dart';

import '../models/store.dart';

class Stores with ChangeNotifier {
  List<Store> _stores = [];

  List<Store> get stores => [..._stores];

  Stores.fromList(this._stores);

  Future<void> fetchStores() {
    return StoresAPI()
        .firestore
        .collection('stores')
        .get()
        .then((value) => this._stores = value.docs.map((e) {
              Map<String, dynamic> json = e.data();
              json['id'] = e.id;
              return Store.fromJson(json);
            }).toList());
  }

  List<Store> searchStore(String searchString) {
    return [..._stores]
        .where((store) => store.address
            .trim()
            .toLowerCase()
            .contains(searchString.toLowerCase()))
        .toList();
  }

  Store getStoreById(String id) {
    try {
      return [..._stores].where((element) => element.id == id).first;
    } on StateError catch (e) {
      return null;
    }
  }

  String getNameById(String id) {
    return [..._stores]
        .firstWhere((element) => element.id == id, orElse: () => null)
        ?.name;
  }

  Future<void> addStore(Store store, bool isLocalImage) async {
    try {
      await StoresAPI().addStore(store, isLocalImage);
      notifyListeners();
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> updateStore(Store newStore, bool isLocalImage) async {
    final index = _stores.indexWhere((store) => store.id == newStore.id);
    if (index < 0) return;

    try {
      await StoresAPI().updateStore(newStore, isLocalImage);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
