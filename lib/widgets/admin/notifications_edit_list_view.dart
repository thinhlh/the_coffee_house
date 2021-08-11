import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/screens/admin/notification_edit_screen.dart';

import '../../providers/notifications.dart';
import '../../utils/const.dart' as Constant;

class EditNotificationsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Notifications>(
      builder: (_, notificationsProvider, child) {
        final notifications = notificationsProvider.notifications;

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (_, index) => Column(
            children: [
              ListTile(
                title: Text(notifications[index].title),
                leading: Image.network(
                  notifications[index].imageUrl,
                  width: 40,
                  errorBuilder: (_, exception, stackTrace) => Center(
                    child: Text(
                      'Unable to load image',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => NotificationEditScreen(
                                notifications[index].id)),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            elevation: Constant.ELEVATION,
                            title: Text('Delete'),
                            content: Text(
                                'Are you sure want to delete this categor?'),
                            actions: [
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                ),
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.blue),
                                ),
                                child: Text('Yes'),
                                onPressed: () {
                                  notificationsProvider.deleteNotification(
                                      notifications[index].id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
