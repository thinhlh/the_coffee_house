import 'package:flutter/material.dart';

import '../utils/const.dart' as Constant;

class ExpandableListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Function onExpanded;

  ExpandableListTile({
    @required this.leadingIcon,
    @required this.title,
    @required this.onExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onExpanded,
      leading: Icon(
        leadingIcon,
        color: Theme.of(context).accentColor.withOpacity(0.8),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      visualDensity: VisualDensity.compact,
    );
  }
}
