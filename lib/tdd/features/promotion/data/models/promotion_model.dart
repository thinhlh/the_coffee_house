import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';

class PromotionModel extends Promotion {
  PromotionModel({
    @required String id,
    @required String code,
    @required String title,
    @required String description,
    @required DateTime expiryDate,
    @required String imageUrl,
    @required String value,
    @required List<Membership> targetCustomers,
  }) : super(
          id: id,
          code: code,
          description: description,
          expiryDate: expiryDate,
          imageUrl: imageUrl,
          title: title,
          value: value,
          targetCustomers: targetCustomers,
        );

  factory PromotionModel.fromMap(Map<String, dynamic> map) {
    return PromotionModel(
      id: map['id'],
      code: map['code'],
      title: map['title'],
      description: map['description'],
      expiryDate: map['expiryDate'] == null
          ? DateTime.now()
          : (map['expiryDate'] is DateTime)
              ? map['expityDate']
              : (map['expiryDate'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'],
      value: map['value'],
      targetCustomers: (map['targetCustomer'] as List<dynamic>)
          .cast<String>()
          .map((string) => parseMembershipFromString(string))
          .toList(),
    );
  }

  Map<String, dynamic> get toMap => {
        'code': this.code,
        'title': this.title,
        'expiryDate': this.expiryDate,
        'description': this.description,
        'targetCustomer': targetCustomers
            .map((membership) => membership.valueString())
            .toList(),
        'imageUrl': this.imageUrl,
        'value': this.value,
      };
}
