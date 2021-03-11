import 'package:flutter/material.dart';

import 'package:the_coffee_house/const.dart' as Constant;

class NavigativeActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Function navigate;

  NavigativeActionCard({
    @required this.icon,
    @required this.title,
    @required this.color,
    @required this.navigate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigate,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Constant.GENERAL_PADDING * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: color.withAlpha(50),
                child: Icon(icon, color: color),
              ),
              SizedBox(
                height: Constant.SIZED_BOX_HEIGHT,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //fontSize: 16,
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
