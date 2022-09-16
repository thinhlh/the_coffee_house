import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/notifications.dart';
import '../../utils/const.dart' as Constant;
import '../../utils/global_vars.dart';
import '../../widgets/image_slider_widget.dart';
import '../../widgets/navigative_action_card.dart';
import '../../widgets/notification_list_tile.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Constant.GRADIENT_COLOR,
              ),
            ),
            child: Column(
              children: [
                ImageSlider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: NavigativeActionCard(
                        icon: Icons.pedal_bike,
                        color: Colors.red[400],
                        title: 'Giao Tận Nơi',
                        onPressed: () {
                          sharedPref.setIsPreferDelivered(true).then(
                                (value) => tabScreenState.currentState
                                    .navigateToScreen(
                                  OrderScreen.routeName,
                                ),
                              );
                        },
                      ),
                    ),
                    Expanded(
                      child: NavigativeActionCard(
                          icon: FlutterIcons.cup_ent,
                          color: Colors.blue[400],
                          title: 'Tự Đến Lấy',
                          onPressed: () {
                            sharedPref.setIsPreferDelivered(false).then(
                                  (value) => tabScreenState.currentState
                                      .navigateToScreen(
                                    OrderScreen.routeName,
                                  ),
                                );
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.GENERAL_PADDING),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
              ),
              child: Consumer<Notifications>(
                builder: (_, notificationProvider, child) {
                  final notifications = notificationProvider.notifications;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Row(
                            children: [
                              Text(
                                'Thông báo mới',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Constant.TEXT_SIZE),
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: Constant.GENERAL_PADDING),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red[700],
                                  radius: Constant.BORDER_RADIUS,
                                  child: Consumer<Notifications>(
                                    builder: (_, notifications, child) => Text(
                                      (notifications.notifications.length -
                                              sharedPref
                                                  .numberOfViewedNotification(
                                                notifications.notifications
                                                    .map((e) => e.id)
                                                    .toList(),
                                              ))
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Constant.LIST_TILE_SUBTITTLE,
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
                          () => setState(() {}),
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
