import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';
import 'package:the/tdd/features/stores/presentation/pages/store_info_page.dart';
import 'package:the/utils/const.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                borderRadius: BorderRadius.circular(
                  AppDimens.BORDER_RADIUS,
                ),
              ),
              context: context,
              builder: (_) => StoreInfoPage(store),
            ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
        ),
        // height: MediaQuery.of(context).size.height / 7,
        height: (1 / 7).sh,
        padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
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
            ),
            SizedBox(
              width: AppDimens.SIZED_BOX_HEIGHT,
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
                    style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                  ),
                  Text(
                    'Chưa xác định',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
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
