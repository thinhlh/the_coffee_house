import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/models/search_store.dart';
import 'package:the_coffee_house/widgets/store_card.dart';

import '../../providers/stores.dart';
import '../../utils/const.dart' as Constant;
import 'google_map.dart';

class StoresScreen extends StatefulWidget {
  static const routeName = '/stores_screen';
  bool isUsedForChoosingLocation;

  StoresScreen({this.isUsedForChoosingLocation});

  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  bool isMap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => setState(() => isMap = !isMap),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.grey.shade500),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Icon(Icons.map),
                  Text(
                    'BẢN ĐỒ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
        title: ListTile(
            shape: StadiumBorder(),
            visualDensity: VisualDensity.compact,
            horizontalTitleGap: 0,
            tileColor: Colors.grey.shade400.withOpacity(0.4),
            title: Text(
              'Tìm kiếm',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            leading: Icon(Icons.search),
            onTap: () => showSearch(
                  context: context,
                  delegate: SearchStore(widget.isUsedForChoosingLocation),
                ).then((value) {
                  if (value != null) {
                    //This situation happends when choosing location from the order screen => navigate to search => choose store
                    // the store returned need to be poped one more time to back to order screen
                    Navigator.of(context).pop(value);
                  }
                })),
      ),
      body: isMap
          ? GoogleMapWidget()
          : _StoresListView(widget.isUsedForChoosingLocation ?? false),
    );
  }
}

class _StoresListView extends StatelessWidget {
  final bool isUsedForChoosingLocation;

  _StoresListView(this.isUsedForChoosingLocation);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
              child: Text(
                'CÁC CỬA HÀNG KHÁC',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Consumer<Stores>(
            builder: (_, storesProvider, child) => ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (_, index) => SizedBox(
                height: Constant.SIZED_BOX_HEIGHT / 2,
              ),
              padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
              shrinkWrap: true,
              itemBuilder: (_, index) => StoreCard(
                store: storesProvider.stores[index],
                isUsedForChoosingLocation: isUsedForChoosingLocation,
              ),
              itemCount: storesProvider.stores.length,
            ),
          ),
        ],
      ),
    );
  }
}
