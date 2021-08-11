import 'package:flutter/material.dart';
import 'package:the/models/promotion.dart';
import 'package:the/services/promotions_api.dart';

class Promotions with ChangeNotifier {
  List<Promotion> _promotions = [];

  List<Promotion> get promotions {
    return [..._promotions];
  }

  Promotions.initialize();

  Promotions.fromList(this._promotions);

  List<Promotion> get firstThreePromotions => _promotions.length < 3
      ? _promotions.sublist(0, _promotions.length)
      : _promotions.sublist(0, 3);

  List<Promotion> get nearlyOutOfDate => _promotions
      .where((element) =>
          element.expiryDate.difference(DateTime.now()).inDays <= 7)
      .toList();

  Promotion getPromotionById(String id) => _promotions.firstWhere(
        (element) => element.id == id,
        orElse: () => Promotion.initialize(),
      );
  Promotion getPromotionByCode(String code) => _promotions.firstWhere(
        (element) => element.code == code,
        orElse: () => Promotion.initialize(),
      );
  Future<void> addPromotion(
      Promotion promotion, bool isChoosingImageFromLocal) {
    return PromotionsAPI().addPromotion(promotion, isChoosingImageFromLocal);
  }

  Future<void> updatePromotion(
    Promotion promotion,
    bool isChoosingImageFromLocal,
  ) {
    return PromotionsAPI().updatePromotion(promotion, isChoosingImageFromLocal);
  }

  List<Promotion> searchPromotion(String query) {
    return _promotions
        .where((promotion) =>
            promotion.title
                .trim()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            promotion.code.trim().toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
