import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/features/address/presentation/pages/choose_delivery_address_page.dart';
import 'package:the/tdd/features/address/presentation/providers/address_provider.dart';
import 'package:the/tdd/features/order/presentation/providers/cart_provider.dart';
import 'package:the/tdd/features/stores/presentation/pages/stores_page.dart';
import 'package:the/tdd/features/stores/presentation/providers/stores_provider.dart';
import 'package:the/utils/values/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCardNavigation extends StatelessWidget {
  final List<Tab> _tabs = [
    Tab(
      child: Text(
        'GIAO TẬN NƠI',
        style: TextStyle(fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE),
      ),
    ),
    Tab(
      child: Text(
        'TỰ ĐẾN LẤY',
        style: TextStyle(fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
      ),
      color: const Color.fromRGBO(135, 111, 93, 1),
      elevation: AppDimens.ELEVATION,
      semanticContainer: true,
      child: DefaultTabController(
        initialIndex: context.select<CartProvider, bool>(
                (provider) => provider.isPreferDelivered)
            ? 0
            : 1,
        length: 2,
        child: Column(
          children: [
            TabBar(
              onTap: (index) => context.read<CartProvider>().isPreferDelivered =
                  index == 0 ? true : false,
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: AppDimens.MEDIUM_PADDING),
              indicatorWeight: 1.5,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: _tabs,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _OrderActionCard(true),
                  _OrderActionCard(false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderActionCard extends StatelessWidget {
  final bool isDeliveryCard;
  _OrderActionCard(this.isDeliveryCard);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  isDeliveryCard ? 'ĐẾN ĐỊA CHỈ' : 'TẠI THE COFFEE HOUSE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Selector<CartProvider, dynamic>(
                  selector: (_, provider) => isDeliveryCard
                      ? provider.choosenDeliveryDetail
                      : provider.choosenTakeAwayStoreId,
                  builder: (_, detail, __) {
                    String text = '';

                    if (isDeliveryCard) {
                      /// This is delivery card => location is DeliveryDetail => info is the address of latest delivery detail otherwise [DefaultText]
                      if ((detail as DeliveryDetail) == null) {
                        text = 'Chọn địa chỉ';
                      } else {
                        text = (detail as DeliveryDetail).address;
                      }
                    } else {
                      /// This is take away card => location is store id
                      if ((detail as String) == null ||
                          (detail as String).isEmpty) {
                        text = 'Chọn cửa hàng';
                      } else {
                        text = context
                                .read<StoresProvider>()
                                .getStoreNameById(detail) ??
                            'Chọn của hàng';
                      }
                    }
                    return Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimens.SMALL_TEXT_SIZE,
                      ),
                      softWrap: false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
              child: Chip(
                label: Text(
                  'THAY ĐỔI',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                  ),
                ),
                elevation: AppDimens.ELEVATION,
                //backgroundColor: Colors.brown,
              ),
              onTap: () {
                context.read<AddressProvider>().getDeliveryDetails();

                showBarModalBottomSheet(
                  context: context,
                  builder: (_) => isDeliveryCard
                      ? ChooseDeliveryAddressPage()
                      : StoresPage(isUsedForChoosingLocation: true),
                ).then(
                  (value) async {
                    //Handling on choose store

                    if (value == null)
                      return;
                    else {
                      if (value is String)
                        context.read<CartProvider>().choosenTakeAwayStoreId =
                            value;
                      else
                        context.read<CartProvider>().choosenDeliveryDetail =
                            value;
                    }
                  },
                );
              }),
        ),
      ],
    );
  }
}
