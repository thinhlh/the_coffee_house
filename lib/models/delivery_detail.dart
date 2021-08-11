import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DeliveryDetail extends Equatable {
  String recipientName = '';
  String recipientPhone = '';
  String address = '';
  String note = '';

  DeliveryDetail({
    @required this.recipientName,
    @required this.recipientPhone,
    @required this.address,
    @required this.note,
  });

  Map<String, Object> toMap() {
    return {
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'address': address,
      'note': note,
    };
  }

  DeliveryDetail.fromMap(Map<String, Object> map) {
    this.recipientName = map['recipientName'];
    this.recipientPhone = map['recipientPhone'];
    this.address = map['address'];
    this.note = map['note'];
  }

  @override
  List<Object> get props => [
        this.address,
        this.recipientName,
        this.recipientPhone,
      ];
}
