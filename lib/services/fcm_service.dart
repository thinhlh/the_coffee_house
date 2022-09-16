import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/firebase_notification_handler.dart';

class FCMService {
  static Future<void> initializeFCMSubscription(
      bool isSubscribeToNotifications) async {
    if (isSubscribeToNotifications) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      await messaging.subscribeToTopic('notifications');

      FirebaseMessaging.onMessage.listen((event) {
        print(event.notification.body);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        print('Message Clicked => Open the app');
      });
      FirebaseMessaging.onBackgroundMessage(messageHandler);
    }
  }

  static Future<void> messageHandler(RemoteMessage message) async {
    //TODO show popup here
    print(message.notification.body);
    dynamic data = message.data['data'];
    FirebaseNotifications.showNotification(data['title'], data['body']);
  }
}
