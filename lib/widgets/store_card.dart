import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:the/models/store.dart';
import 'package:the/screens/home/store_info_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/utils/const.dart' as Constant;

class StoreCard extends StatelessWidget {
  final Store store;
  final bool isUsedForChoosingLocation;

  StoreCard({
    @required this.store,
    @required this.isUsedForChoosingLocation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isUsedForChoosingLocation
          ? Navigator.of(context).pop(store.id)
          : showBarModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
              ),
              context: context,
              builder: (_) => StoreInfoScreen(store),
            ).then((value) {
              // Customer decided to order and take from this store => Update order navigation card
              if (value != null) ;
            }),
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
                store.imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                errorBuilder: (_, exception, stackTrace) => Center(
                  child: Text(
                    'Unable to load image',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
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
                    store.address,
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
    );
  }
}
