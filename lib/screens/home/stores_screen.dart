import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/stores.dart';
import '../../utils/const.dart' as Constant;
import 'google_map.dart';
import 'store_info_screen.dart';

class StoresScreen extends StatefulWidget {
  static const routeName = '/stores_screen';

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
            child: Row(
              children: [
                Icon(Icons.map),
                Text(
                  'BẢN ĐỒ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
        title: ClipRRect(
          borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
          child: ListTile(
            visualDensity: VisualDensity.compact,
            horizontalTitleGap: 0,
            tileColor: Colors.grey.shade400.withOpacity(0.4),
            title: Text(
              'Tìm kiếm',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            leading: Icon(Icons.search),
          ),
        ),
      ),
      body: isMap ? GoogleMapWidget() : _StoresListView(),
    );
  }
}

class _StoresListView extends StatelessWidget {
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
              padding: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
              child: Text(
                'CÁC CỬA HÀNG KHÁC',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
              color: Colors.grey.withOpacity(0.4),
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
              itemBuilder: (_, index) => GestureDetector(
                onTap: () => showBarModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                  ),
                  context: context,
                  builder: (_) => StoreInfoScreen(storesProvider.store[index]),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                  ),
                  // height: MediaQuery.of(context).size.height / 7,
                  height: (1 / 7).sh,
                  padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.network(
                          storesProvider.store[index].imageUrls[0],
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                      ),
                      SizedBox(
                        width: Constant.SIZED_BOX_HEIGHT,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'THE COFFEE HOUSE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              storesProvider.store[index].fullAddress,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Chưa xác định',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              itemCount: storesProvider.store.length,
            ),
          ),
        ],
      ),
    );
  }
}
