import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/models/notifications.dart';
import 'package:the_coffee_house/screens/auth/wrapper.dart';
import 'package:the_coffee_house/screens/home/order_screen.dart';
import 'package:the_coffee_house/widgets/navigative_action_card.dart';
import 'package:the_coffee_house/widgets/image_slider_widget.dart';
import 'package:the_coffee_house/widgets/notification_widget.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    final _notifications = Provider.of<Notifications>(context).notifications;

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
                        navigate: () =>
                            tabScreenState.currentState.navigateToScreen(
                          OrderScreen.routeName,
                          true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: NavigativeActionCard(
                        icon: FlutterIcons.cup_ent,
                        color: Colors.blue[400],
                        title: 'Tự Đến Lấy',
                        navigate: () =>
                            tabScreenState.currentState.navigateToScreen(
                          OrderScreen.routeName,
                          false,
                        ),
                      ),
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
              child: Column(
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
                              child: Text(
                                _notifications.length.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Constant.LIST_TILE_SUBTITTLE,
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
                    itemBuilder: (_, index) => NotificationWidget(
                      _notifications[index],
                    ),
                    itemCount: _notifications.length,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
