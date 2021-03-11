import 'package:flutter/cupertino.dart';

class Notification {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String imageUrl;
  NotificationAction notificationAction = NotificationAction.Order;

  Notification({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.dateTime,
    @required this.imageUrl,
    this.notificationAction,
  });
}

/// Actions that navigate user to appropriate screen;
enum NotificationAction {
  Order,
  Exchange,
}
