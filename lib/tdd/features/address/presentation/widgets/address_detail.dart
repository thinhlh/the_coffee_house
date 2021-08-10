import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/features/address/presentation/pages/choose_delivery_address_page.dart';
import 'package:the/tdd/features/order/presentation/providers/cart_provider.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';
import 'package:the/tdd/features/stores/presentation/pages/stores_page.dart';
import 'package:the/tdd/features/stores/presentation/providers/stores_provider.dart';
import 'package:the/utils/const.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Selector<CartProvider, Tuple3<bool, DeliveryDetail, String>>(
            selector: (_, provider) => tuple3(
                  provider.isPreferDelivered,
                  provider.choosenDeliveryDetail,
                  provider.choosenTakeAwayStoreId,
                ),
            builder: (ctx, tuple, __) {
              Store choosenStore;
              if (tuple.value3 != null) {
                choosenStore =
                    ctx.read<StoresProvider>().getStoreById(tuple.value3);
              }

              return ListTile(
                title: Text(
                  tuple.value1
                      ? (tuple.value2 == null)
                          ? 'Địa chỉ giao hàng'
                          : tuple.value2.address
                      : choosenStore == null
                          ? 'Chọn của hàng'
                          : choosenStore.name,
                  style: TextStyle(
                    fontSize: AppDimens.SMALL_TEXT_SIZE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: tuple.value1
                    ? Text(
                        (tuple.value2 == null)
                            ? 'Chọn địa chỉ giao hàng'
                            : tuple.value2.recipientName,
                        style: TextStyle(
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                        ),
                      )
                    : Text(
                        (choosenStore == null)
                            ? 'Chọn địa chỉ cửa hàng đến lấy'
                            : choosenStore.address,
                        style: TextStyle(
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                        ),
                      ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => tuple.value1
                    ? showBarModalBottomSheet(
                        context: context,
                        builder: (_) => ChooseDeliveryAddressPage(),
                      ).then((value) {
                        if (value != null) {
                          ctx.read<CartProvider>().choosenDeliveryDetail =
                              value;
                        }
                      })
                    : showBarModalBottomSheet(
                        context: context,
                        builder: (_) =>
                            StoresPage(isUsedForChoosingLocation: true),
                      ).then(
                        (value) {
                          if (value != null)
                            ctx.read<CartProvider>().choosenTakeAwayStoreId =
                                value;
                        },
                      ),
              );
            }),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.LARGE_PADDING,
          ),
          child: Divider(
            color: Colors.black45,
          ),
        ),
        Selector<CartProvider, Tuple3<bool, DeliveryDetail, String>>(
          selector: (_, provider) => tuple3(
            provider.isPreferDelivered,
            provider.choosenDeliveryDetail,
            provider.choosenTakeAwayStoreId,
          ),
          builder: (ctx, tuple, __) => tuple.value1
              ? Container()
              : GestureDetector(
                  onTap: () {
                    Store choosenStore;
                    if (tuple.value3 != null) {
                      choosenStore =
                          ctx.read<StoresProvider>().getStoreById(tuple.value3);
                    }
                    Platform.isIOS
                        ? launch(
                            'http://maps.apple.com/?q=The+Coffee+House&ll=' +
                                choosenStore.coordinate.latitude.toString() +
                                ',' +
                                choosenStore.coordinate.longitude.toString() +
                                '&z=20&t=s',
                          )
                        : launch('geo: ' +
                            choosenStore.coordinate.latitude.toString() +
                            ',' +
                            choosenStore.coordinate.longitude.toString() +
                            '?z=20');
                  },
                  child: Container(
                    margin: EdgeInsets.all(AppDimens.LARGE_PADDING),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Xem đường đi đến đây',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimens.SMALL_TEXT_SIZE,
                          ),
                        ),
                        Icon(Icons.map),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
