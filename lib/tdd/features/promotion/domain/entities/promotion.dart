import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';

class Promotion extends Equatable {
  final String id;
  final String code;
  final String title;
  final String description;
  final DateTime expiryDate;
  final List<Membership> targetCustomers;
  final String imageUrl;
  final String value;

  Promotion({
    @required this.id,
    @required this.code,
    @required this.title,
    @required this.description,
    @required this.expiryDate,
    @required this.targetCustomers,
    @required this.imageUrl,
    @required this.value,
  });

  @override
  List<Object> get props => [this.id];
}
