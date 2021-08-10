import 'package:flutter/material.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';
import 'package:the/tdd/features/promotion/domain/usecases/fetch_promotions.dart';

class PromotionsProvider with ChangeNotifier {
  final FetchPromotions _fetchPromotions;

  PromotionsProvider(this._fetchPromotions);

  List<Promotion> _promotions = [];

  List<Promotion> get promotions => [..._promotions];

  set promotions(List<Promotion> promotion) {
    _promotions = promotion;
    notifyListeners();
  }

  Future<void> fetchPromotions() async {
    final result = await _fetchPromotions(NoParams());

    result.fold((failure) => null, (promotions) {
      _promotions = promotions;
      notifyListeners();
    });
  }

  Promotion getPromotionById(String id) => promotions
      .firstWhere((promotion) => promotion.id == id, orElse: () => null);

  Promotion getPromotionByCode(String code) => promotions
      .firstWhere((promotion) => promotion.code == code, orElse: () => null);

  List<Promotion> get nearlyOutOfDate => promotions
      .where((promotion) =>
          promotion.expiryDate.difference(DateTime.now()).inDays <= 7)
      .toList();

  List<Promotion> get firstThreePromotions => _promotions.length < 3
      ? _promotions.sublist(0, _promotions.length)
      : _promotions.sublist(0, 3);
}
