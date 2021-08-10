import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/stores/data/models/store_model.dart';

abstract class StoresRemoteDataSource {
  Future<List<StoreModel>> fetchStores();
}

class StoresRemoteDataSourceImpl implements StoresRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<StoreModel>> fetchStores() async {
    try {
      final storesSnapshot = await _firestore
          .collection('stores')
          .get()
          .timeout(Duration(minutes: 1));

      return storesSnapshot.docs
          .map(
            (document) => StoreModel.fromMap(
              document.data()
                ..addEntries(
                  [MapEntry('id', document.id)],
                ),
            ),
          )
          .toList();
    } on TimeoutException {
      throw ConnectionException();
    }
  }
}
