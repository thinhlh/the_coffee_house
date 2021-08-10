import 'package:flutter/material.dart';

import 'package:the/tdd/features/notifications/domain/entities/notification.dart'
    as model;
import 'package:the/tdd/features/notifications/domain/usecases/save_viewed_notifications.dart';
import 'package:the/tdd/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:the/tdd/features/notifications/presentation/widgets/notification_info.dart';
import 'package:the/utils/helpers/date_helper.dart';
import 'package:the/utils/values/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NotificationListTile extends StatelessWidget {
  final model.Notification _notification;

  NotificationListTile(this._notification);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ListTile(
          dense: true,
          onTap: () async {
            final provider =
                Provider.of<NotificationsProvider>(context, listen: false);
            if (!provider.isNotificationsViewed(_notification.id))
              await provider.saveViewedNotification(
                SaveViewedNotificationParams(_notification.id),
              );
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
              ),
              isScrollControlled: true,
              builder: (_) => NotificationInfo(this._notification),
            );
          },
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              context.select<NotificationsProvider, bool>(
                (NotificationsProvider provider) =>
                    provider.isNotificationsViewed(_notification.id),
              )
                  ? SizedBox(width: 12.w)
                  : Icon(
                      Icons.circle,
                      size: 12.w,
                      color: Colors.red,
                    ),
              Padding(
                padding: EdgeInsets.only(
                  left: AppDimens.MEDIUM_PADDING,
                ),
                child: IntrinsicHeight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.r),
                    child: Image.network(
                      _notification.imageUrl,
                      width: 35.w,
                      height: 35.h,
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
            _notification.title,
            softWrap: true,
            maxLines: 1,
            style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
          ),
          subtitle: Text(
            DateHelper.ddMMyy(_notification.dateTime),
            style: TextStyle(fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE),
          ),
        ),
      ],
    );
  }
}
