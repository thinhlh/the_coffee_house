import 'dart:async';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:the_coffee_house/utils/const.dart' as Constant;
import 'package:the_coffee_house/models/notification.dart' as model;

class NotificationInfo extends StatelessWidget {
  final model.Notification notification;

  NotificationInfo(this.notification);
  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
      notification.imageUrl,
    );
    Completer<ui.Image> completer = Completer<ui.Image>();

    image.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info.image)));

    final mediaQuery = MediaQuery.of(context);

    return FutureBuilder(
        future: completer.future,
        builder: (_, AsyncSnapshot<ui.Image> snapshot) {
          if (!snapshot.hasData)
            return Container(
              height: 0,
            );
          return IntrinsicHeight(
            child: Container(
              width: mediaQuery.size.width,
              // height: mediaQuery.size.width *
              //     snapshot.data.height /
              //     snapshot.data.width *
              //     2,
              height: mediaQuery.size.width * 4 / 3,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.zero,
                          top: Radius.circular(Constant.BORDER_RADIUS),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(notification.imageUrl),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(3 * Constant.GENERAL_PADDING),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              notification.title,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              notification.description,
                              maxLines: 4,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Flexible(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text(
                                'Order ngay',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  StadiumBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
