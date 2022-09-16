import 'package:flutter/material.dart';

import '../models/notification.dart' as model;
import '../utils/const.dart' as Constant;
import '../utils/global_vars.dart';
import 'notification_info.dart';

class NotificationListTile extends StatefulWidget {
  final model.Notification _notification;
  final Function _setStateParent;
  NotificationListTile(
    this._notification,
    this._setStateParent,
  );
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
              await sharedPref.addViewedNotifications(widget._notification.id);
              widget._setStateParent();
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
                  ? SizedBox(width: 12)
                  : Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.red,
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Constant.GENERAL_PADDING,
                  Constant.GENERAL_PADDING,
                  0,
                  Constant.GENERAL_PADDING,
                ),
                child: IntrinsicHeight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                    child: Image.network(
                      widget._notification.imageUrl,
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                      errorBuilder: (_, exception, stackTrace) =>
                          Icon(Icons.error),
                    ),
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
            widget._notification.formattedDateTime,
            style: TextStyle(fontSize: Constant.LIST_TILE_SUBTITTLE),
          ),
        ),
      ],
    );
  }
}
