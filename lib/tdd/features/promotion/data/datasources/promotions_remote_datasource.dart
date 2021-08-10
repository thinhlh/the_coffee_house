import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/promotion/data/models/promotion_model.dart';

abstract class PromotionsRemoteDataSource {
  Future<List<PromotionModel>> fetchPromotions();
}

class PromotionsRemoteDataSourceImpl implements PromotionsRemoteDataSource {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<PromotionModel>> fetchPromotions() async {
    try {
      final result = await _firestore
          .collection('promotions')
          .get()
          .timeout(Duration(minutes: 1));

      return result.docs
          .map(
            (document) => PromotionModel.fromMap(
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
