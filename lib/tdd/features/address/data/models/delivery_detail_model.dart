import 'package:flutter/foundation.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';

class DeliveryDetailModel extends DeliveryDetail {
  DeliveryDetailModel({
    @required String recipientName,
    @required String recipientPhone,
    @required String address,
    @required String note,
  }) : super(
          recipientName: recipientName,
          recipientPhone: recipientPhone,
          address: address,
          note: note,
        );

  Map<String, Object> toMap() {
    return {
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'address': address,
      'note': note,
    };
  }

  factory DeliveryDetailModel.fromMap(Map<String, Object> map) {
    return DeliveryDetailModel(
      recipientName: map['recipientName'],
      recipientPhone: map['recipientPhone'],
      address: map['address'],
      note: map['note'],
    );
  }
}
