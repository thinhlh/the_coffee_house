import 'package:flutter/material.dart';
import 'package:the/utils/values/dimens.dart';

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Function onPressed;

  ActionCard({
    @required this.icon,
    @required this.title,
    @required this.color,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.LARGE_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: color.withAlpha(50),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              SizedBox(
                height: AppDimens.SIZED_BOX_HEIGHT,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
