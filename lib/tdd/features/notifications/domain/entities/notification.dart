import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';

class Notification extends Equatable {
  String id;
  String title;
  String description;
  String imageUrl;
  DateTime dateTime;
  List<Membership> targetCustomers = [];

  Notification({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.dateTime,
    this.targetCustomers,
  });

  @override
  List<Object> get props => [id];
}
