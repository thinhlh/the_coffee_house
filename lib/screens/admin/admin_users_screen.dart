import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/helpers/search_users.dart';
import 'package:the/providers/users.dart';
import 'package:the/widgets/admin/admin_user_card.dart';
import '/utils/const.dart' as Constant;

class AdminUsersScreen extends StatelessWidget {
  static const routeName = '/admin-users-screen';

  bool isFirstTimeLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users Management'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => showSearch(
            context: context,
            delegate: SearchUser(),
          ),
        ),
      ),
      body: Consumer<Users>(
        builder: (__, usersProvider, child) => FutureBuilder(
          future: isFirstTimeLoading
              ? usersProvider
                  .fetchAndUpdateUsersInfo()
                  .then((value) => isFirstTimeLoading = false)
              : null,
          builder: (_, snapshot) =>
              snapshot.connectionState != ConnectionState.done &&
                      !snapshot.hasData &&
                      (isFirstTimeLoading &&
                          snapshot.connectionState == ConnectionState.none)
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: usersProvider.fetchAndUpdateUsersInfo,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                        itemBuilder: (_, index) => AdminUserCard(
                          usersProvider.users[index],
                        ),
                        itemCount: usersProvider.users.length,
                      ),
                    ),
        ),
      ),
    );
  }
}

/*
 */
