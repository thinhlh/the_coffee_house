import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/helpers/admin_search_store.dart';
import 'package:the/models/store.dart';
import 'package:the/providers/notifications.dart';
import 'package:the/providers/stores.dart';
import 'package:the/screens/admin/store_edit_screen.dart';
import 'package:the/screens/admin/product_edit_screen.dart';
import 'package:the/services/notifications_api.dart';
import 'package:the/services/stores_api.dart';
import '/utils/const.dart' as Constant;

class AdminStoresScreen extends StatelessWidget {
  static const routeName = '/admin-stores-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stores Management'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => EditStoreScreen(null),
              ),
            ),
            icon: Icon(Icons.add),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: AdminSearchStore(),
            ),
          ),
        ],
      ),
      body: Consumer<Stores>(
          builder: (_, storesProvider, child) => ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                itemBuilder: (_, index) =>
                    AdminStoreCard(storesProvider.stores[index]),
                itemCount: storesProvider.stores.length,
              )),
    );
  }
}

class AdminStoreCard extends StatelessWidget {
  final Store store;
  AdminStoreCard(this.store);

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
          title: Text('Delete this store?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              isDefaultAction: false,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              child: Text('Proceed'),
              isDefaultAction: true,
              onPressed: () => StoresAPI()
                  .delete(store.id)
                  .then((value) => Navigator.of(context).pop(true)),
            ),
          ],
        ),
      ).then((value) => value),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => EditStoreScreen(
              store.id,
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Constant.GENERAL_PADDING / 3,
                        horizontal: Constant.GENERAL_PADDING / 2,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          store.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, exception, stackTrace) => Center(
                            child: Text(
                              'Unable to load image',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          isThreeLine: true,
                          title: Text(
                            store.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Constant.TEXT_SIZE,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  store.address,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                store.location.latitude.toStringAsFixed(4) +
                                    ',' +
                                    store.location.longitude.toStringAsFixed(4),
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
