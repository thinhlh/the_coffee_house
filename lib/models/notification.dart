import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'membership.dart';

class Notification {
  String id;
  String title;
  String description;
  String imageUrl;
  DateTime dateTime;
  List<Membership> targetCustomers = [];
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
    this.targetCustomers,
    this.notificationAction,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'dateTime': DateTime.now(),
      'targetCustomer': targetCustomers.map((e) => e.valueString()).toList(),
    };
  }

  Notification.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.description = json['description'];
    this.imageUrl = json['imageUrl'];
    this.dateTime = (json['dateTime'] as Timestamp).toDate();
    print(json['targetCustomer']);
    this.targetCustomers = (json['targetCustomer'] as List<dynamic> ?? [])
        .cast<String>()
        .map((e) => parseMembershipFromString(e))
        .toList();
  }

  String get formattedDateTime =>
      DateFormat('y/MM/dd - hh:mm').format(dateTime);
}

/// Actions that navigate user to appropriate screen;
enum NotificationAction {
  Order,
  ViewLastTransaction,
  Exchange,
}
