import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';
import 'package:the/tdd/features/notifications/domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    @required String id,
    @required String title,
    @required String description,
    @required String imageUrl,
    @required DateTime dateTime,
    List<Membership> targetCustomers,
  }) : super(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          dateTime: dateTime,
          targetCustomers: targetCustomers,
        );

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'dateTime': dateTime,
      'targetCustomer': targetCustomers
          .map((membership) => membership.valueString())
          .toList(),
    };
  }

  NotificationModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.imageUrl = map['imageUrl'];

    this.dateTime = map['dateTime'] is DateTime
        ? map['dateTime']
        : (map['dateTime'] as Timestamp).toDate();

    if ((map['targetCustomer']) == null) return;

    this.targetCustomers = (map['targetCustomer'] as List<dynamic>)
        .cast<String>()
        .map((value) => parseMembershipFromString(value))
        .toList();
  }
}
