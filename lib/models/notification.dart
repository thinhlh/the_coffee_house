import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:the_coffee_house/models/membership.dart';

class Notification {
  String id;
  String title;
  String description;
  String imageUrl;
  DateTime dateTime;
  List<Membership> targetCustomer = [];
  NotificationAction notificationAction = NotificationAction.Order;

  Notification.initialize() {
    this.id = null;
    this.title = '';
    this.description = '';
    this.imageUrl = '';
  }

  Notification({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.dateTime,
    this.targetCustomer,
    this.notificationAction,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'dateTime': DateTime.now(),
      'targetCustomer': targetCustomer.map((e) => e.toString()).toList(),
    };
  }

  Notification.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.description = json['description'];
    this.imageUrl = json['imageUrl'];
    this.dateTime = (json['dateTime'] as Timestamp).toDate();
    this.targetCustomer = (json['targetCustomer'] as List<dynamic>)
        .cast<String>()
        .map((value) => value == 'Membership.Bronze'
            ? Membership.Bronze
            : value == 'Membership.Silver'
                ? Membership.Silver
                : value == 'Membership.Gold'
                    ? Membership.Gold
                    : Membership.Diamond)
        .toList();
  }
}

/// Actions that navigate user to appropriate screen;
enum NotificationAction {
  Order,
  ViewLastTransaction,
  Exchange,
}
