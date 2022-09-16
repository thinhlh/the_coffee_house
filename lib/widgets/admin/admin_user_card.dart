import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the/models/custom_user.dart';
import 'package:the/models/membership.dart';
import 'package:the/screens/admin/admin_user_info.dart';
import 'package:the/services/users_api.dart';

import 'package:the/utils/const.dart' as Constant;

class AdminUserCard extends StatelessWidget {
  final CustomUser _user;
  AdminUserCard(this._user);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      background: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.shade200,
          borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            child: Icon(
              Icons.delete,
              size: 30,
            ),
            margin: const EdgeInsets.only(right: 20),
          ),
        ),
      ),
      confirmDismiss: (direction) => showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('Delete this users?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              isDefaultAction: false,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              child: Text('Proceed'),
              isDefaultAction: true,
              onPressed: () => UsersAPI()
                  .delete(_user.uid)
                  .then((value) => Navigator.of(context).pop(true)),
            ),
          ],
        ),
      ).then((value) => value),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => AdminUserInfo(
              _user,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: Constant.GENERAL_PADDING / 2,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
            ),
            elevation: Constant.ELEVATION,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(
                Constant.GENERAL_PADDING,
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          Constant.GENERAL_PADDING,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Constant.GENERAL_PADDING,
                              ),
                              child: Text(
                                _user.email,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                                softWrap: true,
                                maxLines: 1,
                              ),
                            ),
                            Text(
                              _user.isAdmin ? 'Admin' : 'User',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: _user.isAdmin
                                      ? Colors.red.shade500
                                      : Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Constant.BORDER_RADIUS),
                          color: _user.membership == Membership.Bronze
                              ? Colors.brown[200]
                              : _user.membership == Membership.Silver
                                  ? Colors.grey[400]
                                  : _user.membership == Membership.Gold
                                      ? Colors.yellow[200]
                                      : Colors.cyan[200],
                        ),
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Text(
                            _user.point.toString(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
