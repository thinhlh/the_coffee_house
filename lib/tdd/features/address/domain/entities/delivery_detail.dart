import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DeliveryDetail extends Equatable {
  final String recipientName;
  final String recipientPhone;
  final String address;
  final String note;

  DeliveryDetail({
    @required this.recipientName,
    @required this.recipientPhone,
    @required this.address,
    @required this.note,
  });

  @override
  List<Object> get props => [
        this.address,
        this.recipientName,
        this.recipientPhone,
      ];
}
