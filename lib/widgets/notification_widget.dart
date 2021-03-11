import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:the_coffee_house/const.dart' as Constant;

class NotificationWidget extends StatelessWidget {
  final _notification;
  NotificationWidget(this._notification);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ListTile(
          dense: true,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                color: Colors.red,
                size: 10,
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
                    _notification.imageUrl,
                    width: 35,
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            _notification.title,
            softWrap: true,
            maxLines: 1,
            style: TextStyle(fontSize: Constant.LIST_TILE_TITTLE),
          ),
          subtitle: Text(
            DateFormat('y/MM/dd - hh:mm').format(_notification.dateTime),
            style: TextStyle(fontSize: Constant.LIST_TILE_SUBTITTLE),
          ),
        ),
      ],
    );
  }
}
