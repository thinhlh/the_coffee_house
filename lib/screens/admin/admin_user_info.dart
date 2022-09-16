import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:the/models/custom_user.dart';
import 'package:the/models/membership.dart';
import 'package:the/services/user_api.dart';
import 'package:the/services/users_api.dart';
import 'package:the/utils/base_date_formatter.dart';
import 'package:the/utils/const.dart' as Constant;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminUserInfo extends StatelessWidget {
  CustomUser user;
  AdminUserInfo(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: UserAPI().fetchUserInDepthInfo(user.uid),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          user.lastSignIn = DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(
              (snapshot.data['metadata'] as Map)['lastSignInTime'], true);
          user.registerDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss')
              .parse((snapshot.data['metadata'] as Map)['creationTime'], true);
          user.totalOrders = snapshot.data['totalOrders'];
          return Padding(
            padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
            child: SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.vpn_key, color: Colors.yellow.shade800),
                    title: Text(user.uid),
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.red.shade400),
                    title: Text(user.email),
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  ListTile(
                    leading: Icon(Icons.cake, color: Colors.purple.shade600),
                    title: Text(
                      user.formattedBirthday,
                    ),
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Icon(
                            Icons.card_membership,
                            color: Colors.indigo,
                          ),
                          title: Text(user.point.toString() + 'pt'),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Icon(
                            Icons.chrome_reader_mode_rounded,
                            color: user.membership == Membership.Bronze
                                ? Colors.brown.shade700
                                : user.membership == Membership.Silver
                                    ? Colors.grey.shade600
                                    : user.membership == Membership.Gold
                                        ? Colors.amber.shade700
                                        : Colors.cyan,
                          ),
                          title: Text(
                              ParseToString(user.membership).valueString()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text(
                      BaseDateFomatter.formatDateTime(user.registerDate),
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  ListTile(
                    leading: Icon(Icons.login),
                    title: Text(
                      BaseDateFomatter.formatDateTime(user.lastSignIn),
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                  ListTile(
                    leading: Icon(FlutterIcons.list_number_fou),
                    title: Text(
                      'Total: ' + user.totalOrders.toString() + ' orders',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Constant.TEXT_SIZE),
                    ),
                  ),
                  SizedBox(height: 2 * Constant.SIZED_BOX_HEIGHT),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .snapshots(),
                          builder: (_, streamSnapshot) {
                            if (!streamSnapshot.hasData) return Container();
                            return ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.red.shade400),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(
                                        2.5 * Constant.GENERAL_PADDING)),
                              ),
                              child: Text(
                                streamSnapshot.data['admin']
                                    ? 'Demote to member'
                                    : 'Promote to admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              onPressed: () => UsersAPI().toggleAccountRole(
                                  user.uid, !streamSnapshot.data['admin']),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
