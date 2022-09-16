import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:the/models/delivery_detail.dart';
import 'package:the/models/order.dart';
import 'package:the/models/store.dart';
import 'package:the/providers/stores.dart';
import 'package:the/providers/user_provider.dart';
import 'package:the/screens/home/choose_delivery_address_screen.dart';
import 'package:the/screens/home/promotion_tab_screen.dart';
import 'package:the/screens/home/stores_screen.dart';
import 'package:the/services/order_api.dart';
import 'package:the/utils/global_vars.dart';
import 'package:the/widgets/base_divider.dart';

import '../../providers/cart.dart';
import '../../utils/const.dart' as Constant;
import 'package:url_launcher/url_launcher.dart';

class OrderConfirmationScreen extends StatelessWidget {
  static const routeName = '/order_confirmation_screen';

  Object orderAddress = sharedPref.isPreferDelivered
      ? sharedPref.latestDeliveryDetail
      : sharedPref.takeAwayLocation;

  bool isCurrentDelivery = sharedPref.isPreferDelivered;
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      child: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text('Giỏ Hàng'),
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
      builder: (_, cartProvider, child) => Scaffold(
        appBar: child,
        bottomNavigationBar: cartProvider.isEmpty
            ? Container(
                height: 0,
                width: 0,
              )
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(141, 89, 43, 1),
                      Color.fromRGBO(240, 150, 74, 1),
                      Color.fromRGBO(141, 89, 43, 1),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(
                  Platform.isIOS
                      ? 2 * Constant.GENERAL_PADDING
                      : Constant.GENERAL_PADDING,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartProvider.numberOfItems.toString() +
                              ' món trong giỏ hàng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          cartProvider.formattedTotalOrderValue,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        if (orderAddress == null) {
                          showCupertinoDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                              title: Text('Invalid order detail'),
                              content: Text(
                                  'You have\'t specify any order address detail'),
                              actions: [
                                CupertinoActionSheetAction(
                                  isDefaultAction: true,
                                  child: Text(
                                    'Okay',
                                    style: TextStyle(
                                        color: Constant.PRIMARY_COLOR),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        }
                        return OrderAPI()
                            .addOrder(
                              Order(
                                id: '',
                                orderAddress: (orderAddress is String)
                                    ? orderAddress
                                    : (orderAddress as DeliveryDetail).address,
                                orderMethod: sharedPref.isPreferDelivered
                                    ? 'Giao tận nơi'
                                    : 'Đến lấy tại cửa hàng',
                                orderTime: DateTime.now(),
                                orderValue: cartProvider.totalOrderValue,
                                isDelivered: false,
                                recipentId:
                                    FirebaseAuth.instance.currentUser.uid,
                                recipientName: (orderAddress is DeliveryDetail)
                                    ? (orderAddress as DeliveryDetail).address
                                    : context.read<UserProvider>().user.name,
                                recipientPhone: (orderAddress is DeliveryDetail)
                                    ? (orderAddress as DeliveryDetail)
                                        .recipientPhone
                                    : '',
                                promotionId: cartProvider.promotion?.id,
                                cart: cartProvider,
                              ),
                            )
                            .then((value) => cartProvider.clearCart())
                            .then((value) => Navigator.of(context).pop());
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          StadiumBorder(),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: Text(
                        'ĐẶT HÀNG',
                        style: TextStyle(
                          color: Color.fromRGBO(202, 118, 53, 1),
                          fontWeight: FontWeight.w500,
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
                padding: const EdgeInsets.fromLTRB(
                  Constant.GENERAL_PADDING,
                  Constant.GENERAL_PADDING,
                  Constant.GENERAL_PADDING,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Các món đã chọn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      child: Text('Xóa tất cả'),
                      onPressed: () {
                        cartProvider.clearCart();
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
                    ListTile(
                      leading: GestureDetector(
                        onTap: () => cartProvider
                            .deleteCartItem(cartProvider.cartItems[index]),
                        child: Icon(Icons.delete, color: Colors.red),
                      ),
                      title: Text(
                        '${cartProvider.cartItems[index].quantity}x ${cartProvider.cartItems[index].title}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(cartProvider.cartItems[index].note),
                      trailing: Text(
                        cartProvider.cartItems[index].formmatedPrice,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                itemCount: cartProvider.cartItems.length,
              ),
              Divider(
                height: 20,
                thickness: 10,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tổng cộng',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng cộng',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          cartProvider.formattedTotalCartItem,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () => showBarModalBottomSheet(
                      context: context,
                      builder: (_) => PromotionTabScreen(
                        isUsedForChoosingPromotion: true,
                      ),
                    ).then((value) => cartProvider.promotion = value),
                    child: Padding(
                      padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
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
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Bấm vào để chọn khuyến mãi',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          cartProvider.promotion == null
                              ? RotatedBox(
                                  child: Icon(Icons.expand_more),
                                  quarterTurns: 3,
                                )
                              : Text(
                                  cartProvider.promotion.code,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Số tiền thanh toán',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          cartProvider.formattedTotalOrderValue,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                height: 20,
                thickness: 10,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                    child: Text(
                      sharedPref.isPreferDelivered
                          ? 'Giao hàng tận nơi'
                          : 'Tự đến lấy hàng',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: Constant.GENERAL_PADDING,
                    ),
                    child: BaseDivider(),
                  ),
                  _AddressDetail(
                    isCurrentDelivery: isCurrentDelivery,
                    updateDataOnParentWidget: (Object value) => value is String
                        ? orderAddress = value
                        : orderAddress = value as DeliveryDetail,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressDetail extends StatefulWidget {
  final bool isCurrentDelivery;
  final Function updateDataOnParentWidget;

  _AddressDetail({this.isCurrentDelivery, this.updateDataOnParentWidget});

  @override
  __AddressDetailState createState() => __AddressDetailState();
}

class __AddressDetailState extends State<_AddressDetail> {
  String takeAwayLocation = sharedPref.takeAwayLocation;

  DeliveryDetail deliveryDetail = sharedPref.latestDeliveryDetail;
  Store takeAwayStore;

  @override
  Widget build(BuildContext context) {
    takeAwayStore = context.read<Stores>().getStoreById(takeAwayLocation);

    return Column(
      children: [
        ListTile(
          title: Text(
            widget.isCurrentDelivery
                ? (deliveryDetail == null)
                    ? 'Địa chỉ giao hàng'
                    : deliveryDetail.address
                : takeAwayStore != null
                    ? takeAwayStore.name
                    : 'Chọn của hàng',
            style: TextStyle(
              fontSize: Constant.TEXT_SIZE,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: widget.isCurrentDelivery
              ? (deliveryDetail == null)
                  ? Text('Chọn địa chỉ giao hàng')
                  : Text(deliveryDetail.recipientName)
              : Text(
                  takeAwayStore != null
                      ? takeAwayStore.address
                      : 'Chọn địa chỉ cửa hàng đến lấy',
                ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () => widget.isCurrentDelivery
              ? showBarModalBottomSheet(
                  context: context,
                  builder: (_) => ChooseDeliveryAddress(),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      widget.updateDataOnParentWidget(value);
                      deliveryDetail = value;
                    });
                  }
                })
              : showBarModalBottomSheet(
                  context: context,
                  builder: (_) => StoresScreen(
                    isUsedForChoosingLocation: true,
                  ),
                ).then((value) {
                  //set the current store value, but not the shared pref value
                  setState(() {
                    takeAwayLocation = value;
                    widget.updateDataOnParentWidget(value);
                  });
                }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2 * Constant.GENERAL_PADDING,
          ),
          child: Divider(
            color: Colors.black45,
          ),
        ),
        widget.isCurrentDelivery
            ? Container()
            : GestureDetector(
                onTap: () => Platform.isIOS
                    ? launch(
                        'http://maps.apple.com/?q=The+Coffee+House&ll=' +
                            takeAwayStore.location.latitude.toString() +
                            ',' +
                            takeAwayStore.location.longitude.toString() +
                            '&z=20&t=s',
                      )
                    : launch('geo: ' +
                        takeAwayStore.location.latitude.toString() +
                        ',' +
                        takeAwayStore.location.longitude.toString() +
                        '?z=20'),
                child: Container(
                  margin: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Xem đường đi đến đây',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Constant.TEXT_SIZE,
                        ),
                      ),
                      Icon(Icons.map),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
