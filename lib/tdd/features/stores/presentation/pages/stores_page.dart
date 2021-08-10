import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';
import 'package:the/tdd/features/stores/presentation/pages/google_map.dart';
import 'package:the/tdd/features/stores/presentation/providers/stores_provider.dart';
import 'package:the/tdd/features/stores/presentation/widgets/search_store.dart';
import 'package:the/tdd/features/stores/presentation/widgets/store_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/utils/values/colors.dart';
import 'package:the/utils/values/dimens.dart';

class StoresPage extends StatelessWidget {
  static const routeName = '/stores_page';
  final bool isUsedForChoosingLocation;
  StoresPage({this.isUsedForChoosingLocation = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => showSearch(
                  context: context,
                  delegate: SearchStore(false),
                ).then(
                  (value) {
                    if (value != null) {
                      //This situation happends when choosing location from the order screen => navigate to search => choose store
                      // the store returned need to be poped one more time to back to order screen
                      Navigator.of(context).pop(value);
                    }
                  },
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                        BorderRadius.circular(AppDimens.BORDER_RADIUS),
                  ),
                  child: Text(
                    'Tìm kiếm',
                    style: TextStyle(
                      fontSize: AppDimens.SMALL_TEXT_SIZE,
                      color: AppColors.TEXT_SECONDARY,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                final provider = context.read<StoresProvider>();
                provider.isMap = !provider.isMap;
              },
              child: Row(
                children: [
                  Icon(
                    Icons.map,
                    color: AppColors.TEXT_SECONDARY,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Bản đồ',
                    style: TextStyle(
                      color: AppColors.TEXT_SECONDARY,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        centerTitle: true,
        toolbarHeight: 60.h,
      ),
      body: Selector<StoresProvider, bool>(
        selector: (_, provider) => provider.isMap,
        builder: (_, isMap, __) => isMap
            ? GoogleMapPage()
            : Center(
                child: Selector<StoresProvider, List<Store>>(
                  selector: (_, provider) => provider.stores,
                  builder: (_, stores, child) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.MEDIUM_PADDING,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (_, index) => SizedBox(
                        height: AppDimens.SMALL_SIZED_BOX_HEIGHT,
                      ),
                      itemBuilder: (_, index) => StoreCard(
                        store: stores[index],
                        isUsedForChoosingLocation: isUsedForChoosingLocation,
                      ),
                      itemCount: stores.length,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
