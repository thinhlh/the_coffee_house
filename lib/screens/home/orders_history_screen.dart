import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:the/models/cart_item.dart';
import 'package:the/providers/user_orders.dart';
import 'package:the/providers/products.dart';
import 'package:the/screens/home/order_detail_bottom_sheet.dart';
import 'package:the/screens/home/order_screen.dart';
import 'package:the/services/user_orders_api.dart';
import 'package:the/utils/global_vars.dart';
import 'package:the/widgets/base_divider.dart';
import '/utils/const.dart' as Constant;

class OrdersHistoryScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  void _showOrderDetailBottomSheet(BuildContext context, String orderId) {
    showBarModalBottomSheet(
      context: context,
      builder: (_) => OrderDetailBottomSheet(orderId),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2 * Constant.BORDER_RADIUS),
      ),
    ).then((value) {
      //User want to order again => navigate to order screen
      if (value == true) {
        Navigator.of(context).pop();
        tabScreenState.currentState.navigateToScreen(OrderScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Lịch sử đơn hàng'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
          margin: const EdgeInsets.symmetric(
            vertical: Constant.GENERAL_PADDING,
          ),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Text(
                'Đơn hàng đang chờ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              BaseDivider(),
              Consumer<UserOrders>(
                builder: (_, ordersProvider, child) => ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return StreamBuilder(
                      stream: UserOrdersAPI().getCartItemStream(
                        ordersProvider.notDeliveredOrders[index].id,
                      ),
                      builder: (_, AsyncSnapshot cartItemSnapshot) {
                        if (!cartItemSnapshot.hasData)
                          return Container();
                        else {
                          //Find product and concatenate it
                          Products productsProvider =
                              Provider.of<Products>(context, listen: false);
                          return ListTile(
                            onTap: () => _showOrderDetailBottomSheet(
                              context,
                              ordersProvider.notDeliveredOrders[index].id,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 0),
                            title: Text(
                              (cartItemSnapshot.data as List<CartItem>)
                                  .map((cartItem) {
                                    return cartItem.productId;
                                  })
                                  .toList()
                                  .map((productId) {
                                    return productsProvider
                                                .getProductById(productId) ==
                                            null
                                        ? 'Removed'
                                        : productsProvider
                                            .getProductById(productId)
                                            .title;
                                  })
                                  .join(', '),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('HH:mm - dd/MM/yyyy').format(
                                      ordersProvider
                                          .notDeliveredOrders[index].orderTime),
                                ),
                                Text(ordersProvider
                                    .notDeliveredOrders[index].orderMethod)
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  NumberFormat.currency(
                                    locale: 'vi-VN',
                                    decimalDigits: 0,
                                  ).format(
                                    ordersProvider
                                        .notDeliveredOrders[index].orderValue,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          );
                        }
                      },
                    );
                  },
                  itemCount: ordersProvider.notDeliveredOrders.length,
                  separatorBuilder: (_, index) => Divider(
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: Constant.SIZED_BOX_HEIGHT),
              Text(
                'Đơn hàng đã hoàn tất',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              BaseDivider(),
              Consumer<UserOrders>(
                builder: (_, ordersProvider, child) => ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return StreamBuilder(
                      builder: (_, AsyncSnapshot cartItemSnapshot) {
                        if (!cartItemSnapshot.hasData) {
                          return Container();
                        } else {
                          Products productsProvider =
                              Provider.of<Products>(context, listen: false);
                          return ListTile(
                            onTap: () => _showOrderDetailBottomSheet(
                              context,
                              ordersProvider.deliveredOrders[index].id,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 0),

                            //Find product and concatenate it
                            title: Text(
                              (cartItemSnapshot.data as List<CartItem>)
                                  .map((cartItem) => cartItem.productId)
                                  .toList()
                                  .map((productId) => productsProvider
                                      .getProductById(productId)
                                      .title)
                                  .join(', '),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('HH:mm - dd/MM/yyyy').format(
                                      ordersProvider
                                          .deliveredOrders[index].orderTime),
                                ),
                                Text(ordersProvider
                                    .deliveredOrders[index].orderMethod)
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  NumberFormat.currency(
                                    locale: 'vi-VN',
                                    decimalDigits: 0,
                                  ).format(
                                    ordersProvider
                                        .deliveredOrders[index].orderValue,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          );
                        }
                      },
                      stream: UserOrdersAPI().getCartItemStream(
                        ordersProvider.deliveredOrders[index].id,
                      ),
                    );
                  },
                  itemCount: ordersProvider.deliveredOrders.length,
                  separatorBuilder: (_, index) => Divider(
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
