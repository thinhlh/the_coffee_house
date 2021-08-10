import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/common/presentation/widgets/base_divider.dart';
import 'package:the/tdd/features/address/presentation/widgets/address_detail.dart';
import 'package:the/tdd/features/auth/presentation/providers/user_provider.dart';
import 'package:the/tdd/features/order/domain/entities/order_method.dart';
import 'package:the/tdd/features/order/domain/usecases/add_order.dart';
import 'package:the/tdd/features/order/presentation/providers/cart_provider.dart';
import 'package:the/tdd/features/order/presentation/providers/order_provider.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';
import 'package:the/tdd/features/promotion/presentation/pages/promotions_tab_page.dart';
import 'package:the/utils/const.dart';
import 'package:the/utils/helpers/currency_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderConfirmationPage extends StatelessWidget {
  static const routeName = '/order_confirmation_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Giỏ Hàng',
          style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
        ),
        actions: [
          IconButton(
            icon: Icon(
              FlutterIcons.x_oct,
            ),
            splashColor: Colors.transparent,
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      bottomNavigationBar: context
              .select<CartProvider, bool>((provider) => provider.isEmpty)
          ? Container(height: 0, width: 0)
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                gradient: LinearGradient(
                  colors: AppColors.BOTTOM_SHEET_NAVIGATION_COLOR,
                ),
              ),
              padding: EdgeInsets.all(
                Platform.isIOS
                    ? AppDimens.LARGE_PADDING
                    : AppDimens.MEDIUM_PADDING,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context
                                .select<CartProvider, int>(
                                  (provider) => provider.numberOfItems,
                                )
                                .toString() +
                            ' món trong giỏ hàng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimens.SMALL_TEXT_SIZE,
                        ),
                      ),
                      Text(
                        CurrencyHelper.formatPrice(
                          context.select<CartProvider, int>(
                              (provider) => provider.totalCartValue),
                        ),
                        style: TextStyle(
                          fontSize: AppDimens.SMALL_TEXT_SIZE,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final cartProvider = context.read<CartProvider>();
                      if ((cartProvider.isPreferDelivered &&
                              cartProvider.choosenDeliveryDetail == null) ||
                          (!cartProvider.isPreferDelivered &&
                              cartProvider.choosenTakeAwayStoreId == null)) {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                            title: Text('Invalid order detail'),
                            content: Text(
                              'You have\'t specify any order address detail',
                              style: TextStyle(
                                fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                              ),
                            ),
                            actions: [
                              CupertinoActionSheetAction(
                                isDefaultAction: true,
                                child: Text(
                                  'Okay',
                                  style:
                                      TextStyle(color: AppColors.PRIMARY_COLOR),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      } else {
                        context
                            .read<OrderProvider>()
                            .addOrder(
                              AddOrderParams(
                                orderAddress: cartProvider.isPreferDelivered
                                    ? cartProvider.choosenDeliveryDetail.address
                                    : cartProvider.choosenTakeAwayStoreId,
                                orderMethod: cartProvider.isPreferDelivered
                                    ? OrderMethod.Delivery
                                    : OrderMethod.TakeAway,
                                cartItems: cartProvider.cartItems,
                                promotionId: cartProvider.promotion?.id,
                                recipientName: cartProvider.isPreferDelivered
                                    ? cartProvider
                                        .choosenDeliveryDetail.recipientName
                                    : context.read<UserProvider>().user.name,
                                recipientPhone: cartProvider.isPreferDelivered
                                    ? cartProvider
                                        .choosenDeliveryDetail.recipientPhone
                                    : null,
                                orderValue: cartProvider.totalOrderValue,
                              ),
                            )
                            .then((value) {
                          cartProvider.clearCart();
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        StadiumBorder(),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(
                      'ĐẶT HÀNG',
                      style: TextStyle(
                        color: Color.fromRGBO(202, 118, 53, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                      ),
                    ),
                  )
                ],
              ),
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimens.MEDIUM_PADDING,
                AppDimens.MEDIUM_PADDING,
                AppDimens.MEDIUM_PADDING,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Các món đã chọn',
                    style: TextStyle(
                      fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Xóa tất cả',
                      style: TextStyle(
                        fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                      ),
                    ),
                    onPressed: () {
                      context.read<CartProvider>().clearCart();
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.blue),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) => Column(
                children: [
                  Divider(),
                  Consumer<CartProvider>(
                    builder: (_, cartProvider, __) => ListTile(
                      leading: GestureDetector(
                        onTap: () => cartProvider.deleteCartItem(index),
                        child: Icon(Icons.delete, color: Colors.red),
                      ),
                      title: Text(
                        '${cartProvider.cartItems[index].quantity}x ${cartProvider.cartItems[index].title}',
                        style: TextStyle(
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: cartProvider.cartItems[index].note.isEmpty
                          ? null
                          : Text(cartProvider.cartItems[index].note),
                      trailing: Text(
                        CurrencyHelper.formatPrice(
                          cartProvider.cartItems[index].cartItemValue,
                        ),
                        style: TextStyle(
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              itemCount: context.select<CartProvider, int>(
                  (provider) => provider.cartItems.length),
            ),
            Divider(
              height: AppDimens.SIZED_BOX_HEIGHT,
              thickness: 10,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tổng cộng',
                      style: TextStyle(
                        fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng cộng',
                        style: TextStyle(
                          fontSize: AppDimens.SMALL_TEXT_SIZE,
                        ),
                      ),
                      Text(
                        CurrencyHelper.formatPrice(
                            context.select<CartProvider, int>(
                                (cartProvider) => cartProvider.totalCartValue)),
                        style: TextStyle(
                          fontSize: AppDimens.SMALL_TEXT_SIZE,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                GestureDetector(
                  onTap: () => showBarModalBottomSheet(
                    context: context,
                    builder: (_) => PromotionTabPage(
                      isUsedForChoosingPromotion: true,
                    ),
                  ),
                  // ).then((value) => cartProvider.promotion = value),
                  child: Padding(
                    padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khuyến mãi',
                              style: TextStyle(
                                color: Colors.blue[500],
                                fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                              ),
                            ),
                            Text(
                              'Bấm vào để chọn khuyến mãi',
                              style: TextStyle(
                                fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                              ),
                            ),
                          ],
                        ),
                        Selector<CartProvider, Promotion>(
                          selector: (_, cartProvider) => cartProvider.promotion,
                          builder: (_, promotion, __) => promotion == null
                              ? Icon(Icons.arrow_forward_ios)
                              : Text(
                                  promotion.code,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Số tiền thanh toán',
                        style: TextStyle(
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        CurrencyHelper.formatPrice(
                          context.select<CartProvider, int>(
                            (cartProvider) => cartProvider.totalOrderValue,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(
              height: 20.w,
              thickness: 10,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                  child: Selector<CartProvider, bool>(
                    selector: (_, provider) => provider.isPreferDelivered,
                    builder: (_, isPreferDelivered, __) => Text(
                      isPreferDelivered
                          ? 'Giao hàng tận nơi'
                          : 'Tự đến lấy hàng',
                      style: TextStyle(
                        fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: AppDimens.MEDIUM_PADDING,
                  ),
                  child: BaseDivider(),
                ),
                AddressDetail(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
