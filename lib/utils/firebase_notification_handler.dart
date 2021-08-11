import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_handler.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  BuildContext context;

  void setupFirebase(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessageListener(context);
    this.context = context;
  }

  void firebaseCloudMessageListener(BuildContext context) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Setting ${settings.authorizationStatus}');

    //Get Token
    _firebaseMessaging.getToken().then((value) => print(
        'My Token: $value\nServer Token: AAAACSy_oK4:APA91bHJmLvl77etIPCRLxTJTQt-YVbO5hU0qwU26i63c_b0iuxf_edtkbilV45bMVjoQFo2KfKvdsFIDXeZ6QSLwnXp3Pcwr7hwb2djUnFVQ5IFqJurCKQVkz-TQXlFtzaKVevslvnv'));

    //Subscribe to Topic
    _firebaseMessaging.subscribeToTopic('topic');

    //Handle message
    FirebaseMessaging.onMessage.listen((message) {
      print('Receive $message');
      showNotification(message.notification.title, message.notification.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (Platform.isIOS)
        showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text(message.notification.title),
            content: Text(message.notification.body),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                isDefaultAction: true,
                onPressed: () => Navigator.of(_, rootNavigator: true).pop(),
              )
            ],
          ),
        );
      else
        showNotification(message.data['title'], message.data['body']);
    });
  }

  static void showNotification(String title, String body) async {
    var androidChannel = AndroidNotificationDetails(
      ('com.example.push_notification'),
      'Push Notification',
      'Description',
      autoCancel: true,
      ongoing: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var ios = IOSNotificationDetails();

    var platForm = NotificationDetails(android: androidChannel, iOS: ios);
    await NotificationHandler.flutterLocalNotificationPlugin
        .show(0, title, body, platForm, payload: 'Application Payload');
  }
}
