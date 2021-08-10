import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/common/presentation/pages/tab_screen.dart';
import 'package:the/tdd/common/presentation/widgets/action_card.dart';
import 'package:the/tdd/features/home/banners.dart';
import 'package:the/tdd/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:the/tdd/features/notifications/presentation/widgets/notification_list_tile.dart';
import 'package:the/tdd/features/order/presentation/providers/cart_provider.dart';
import 'package:the/tdd/features/products/presentation/pages/order_page.dart';
import 'package:the/utils/values/colors.dart';
import 'package:the/utils/values/dimens.dart';
import 'package:the/tdd/features/notifications/domain/entities/notification.dart'
    as model;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.GRADIENT_COLOR,
              ),
            ),
            child: Column(
              children: [
                Banners(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ActionCard(
                        icon: Icons.pedal_bike,
                        color: Colors.red[400],
                        title: 'Giao Tận Nơi',
                        onPressed: () async {
                          context.read<CartProvider>().isPreferDelivered = true;
                          tabScreenState.currentState
                              .navigateToScreen(OrderPage.routeName);
                        },
                      ),
                    ),
                    Expanded(
                      child: ActionCard(
                          icon: FlutterIcons.cup_ent,
                          color: Colors.blue[400],
                          title: 'Tự Đến Lấy',
                          onPressed: () async {
                            context.read<CartProvider>().isPreferDelivered =
                                false;
                            tabScreenState.currentState.navigateToScreen(
                              OrderPage.routeName,
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.MEDIUM_PADDING,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
              ),
              child: Selector<NotificationsProvider, List<model.Notification>>(
                selector: (_, provider) => provider.notifications,
                builder: (_, notifications, child) {
                  return notifications.length == 0
                      ? ElevatedButton(
                          onPressed: () => context
                              .read<NotificationsProvider>()
                              .fetchNotifications(),
                          child: Text(
                            'Fetch Notifications',
                            style: TextStyle(
                              fontSize: AppDimens.SMALL_TEXT_SIZE,
                            ),
                          ))
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      'Thông báo mới',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: AppDimens.MEDIUM_PADDING,
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red[700],
                                        radius: AppDimens.BORDER_RADIUS,
                                        child: Selector<NotificationsProvider,
                                            int>(
                                          selector: (_, provider) => provider
                                              .numberOfViewedNotifications,
                                          builder: (
                                            _,
                                            numberOfViewedNotifications,
                                            __,
                                          ) =>
                                              Text(
                                            numberOfViewedNotifications
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) => NotificationListTile(
                                notifications[index],
                              ),
                              itemCount: notifications.length,
                            ),
                          ],
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
