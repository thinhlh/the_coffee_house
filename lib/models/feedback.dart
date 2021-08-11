import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Feedback extends Equatable {
  String id;
  String description;
  String userEmail;
  String userId;
  String userName;
  String userPhone;

  Feedback({
    @required this.id,
    @required this.description,
    @required this.userEmail,
    @required this.userId,
    @required this.userName,
    @required this.userPhone,
  });

  @override
  List<Object> get props => [id];

  Feedback.fromJson(Map<String, Object> json) {
    this.id = json['id'];
    this.description = json['description'];
    this.userName = json['userName'];
    this.userEmail = json['userEmail'];
    this.userPhone = json['userPhone'];
    this.userId = json['userId'];
  }
}
