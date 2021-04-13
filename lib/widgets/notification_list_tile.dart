import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:the_coffee_house/utils/const.dart' as Constant;
import 'package:the_coffee_house/utils/global_vars.dart';
import 'package:the_coffee_house/services/shared_preferences.dart';
import 'package:the_coffee_house/widgets/notification_info.dart';
import 'package:the_coffee_house/models/notification.dart' as model;

class NotificationListTile extends StatefulWidget {
  final model.Notification _notification;
  NotificationListTile(this._notification);

  @override
  _NotificationListTileState createState() => _NotificationListTileState();
}

class _NotificationListTileState extends State<NotificationListTile> {
  bool isViewed = false;

  @override
  void initState() {
    super.initState();
    isViewed = sharedPref.isViewedNotification(widget._notification.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ListTile(
          dense: true,
          onTap: () async {
            if (!isViewed) {
              await SharedPref()
                  .addViewedNotifications(widget._notification.id);
              setState(() => isViewed = true);
            }
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
              ),
              isScrollControlled: true,
              builder: (_) => NotificationInfo(this.widget._notification),
            );
          },
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isViewed
                  ? Text(isViewed.toString())
                  : Icon(
                      Icons.circle_notifications,
                      color: Theme.of(context).primaryColorDark,
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Constant.GENERAL_PADDING,
                  Constant.GENERAL_PADDING,
                  0,
                  Constant.GENERAL_PADDING,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                  child: Image.network(
                    widget._notification.imageUrl,
                    width: 35,
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            widget._notification.title,
            softWrap: true,
            maxLines: 1,
            style: TextStyle(fontSize: Constant.LIST_TILE_TITTLE),
          ),
          subtitle: Text(
            DateFormat('y/MM/dd - hh:mm').format(widget._notification.dateTime),
            style: TextStyle(fontSize: Constant.LIST_TILE_SUBTITTLE),
          ),
        ),
      ],
    );
  }
}
