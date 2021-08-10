import 'package:flutter/material.dart';
import 'package:the/utils/values/colors.dart';
import 'package:the/utils/values/dimens.dart';

class OthersListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Function onTap;

  OthersListTile({
    this.leadingIcon,
    this.title,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: Icon(
        leadingIcon,
        color: AppColors.PRIMARY_COLOR.withOpacity(0.8),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      visualDensity: VisualDensity.compact,
    );
  }
}
