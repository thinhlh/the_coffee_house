import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/helpers/search_notification.dart';
import 'package:the/providers/notifications.dart';
import 'package:the/screens/admin/product_edit_screen.dart';
import 'package:the/widgets/admin/admin_notification_card.dart';
import '/utils/const.dart' as Constant;
import 'notification_edit_screen.dart';

class AdminNotificationsScreen extends StatelessWidget {
  static const routeName = '/admin-notifications-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Management'),
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => showSearch(
            context: context,
            delegate: SearchNotification(),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NotificationEditScreen(null),
              ),
            ),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<Notifications>(
        builder: (_, notificationsProvider, child) => ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
          itemBuilder: (_, index) => AdminNotificationCard(
            notificationsProvider.notifications[index],
          ),
          itemCount: notificationsProvider.notifications.length,
        ),
      ),
    );
  }
}
