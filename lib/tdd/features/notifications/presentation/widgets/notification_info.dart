import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the/tdd/common/presentation/pages/tab_screen.dart';
import 'dart:ui' as ui;
import 'package:the/tdd/features/notifications/domain/entities/notification.dart'
    as model;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/tdd/features/products/presentation/pages/order_page.dart';
import 'package:the/utils/values/dimens.dart';

class NotificationInfo extends StatelessWidget {
  final model.Notification _notification;

  NotificationInfo(this._notification);

  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
      _notification.imageUrl,
      errorBuilder: (_, exception, stackTrace) => Center(
        child: Text(
          'Unable to load image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
    Completer<ui.Image> completer = Completer<ui.Image>();

    image.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info.image)));

    return FutureBuilder(
        future: completer.future,
        builder: (_, AsyncSnapshot<ui.Image> snapshot) {
          if (!snapshot.hasData)
            return Container(
              height: 0,
            );
          return IntrinsicHeight(
            child: Container(
              width: 1.sw,
              height: MediaQuery.of(context).size.width * 4 / 3,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.zero,
                          top: Radius.circular(AppDimens.BORDER_RADIUS),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(_notification.imageUrl),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(3 * AppDimens.MEDIUM_PADDING),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              _notification.title,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                              _notification.description,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                              ),
                            ),
                          ),
                          Flexible(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                tabScreenState.currentState.navigateToScreen(
                                  OrderPage.routeName,
                                );
                              },
                              child: Text(
                                'Order ngay',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: AppDimens.SMALL_TEXT_SIZE),
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
