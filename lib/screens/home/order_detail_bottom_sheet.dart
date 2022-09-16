import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:the/models/order.dart';
import 'package:the/models/store.dart';
import 'package:the/providers/products.dart';
import 'package:the/providers/stores.dart';
import 'package:the/services/order_api.dart';
import 'package:the/widgets/base_divider.dart';
import 'package:url_launcher/url_launcher.dart';
import '/utils/const.dart' as Constant;

class OrderDetailBottomSheet extends StatelessWidget {
  final String _orderId;

  OrderDetailBottomSheet(this._orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Text('Trạng thái đơn hàng'),
        centerTitle: true,
      ),
      body: StreamBuilder<Order>(
        stream: OrderAPI().getStreamOrder(_orderId),
        builder: (_, streamBuilderSnapshot) => FutureBuilder(
            future: OrderAPI().fetchCartItemToOrder(streamBuilderSnapshot.data),
            builder: (_, AsyncSnapshot<Order> futureSnapshot) {
              if (futureSnapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                Order order = futureSnapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Image.asset(
                        'assets/images/coffee-cup-icon.png',
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'Trạng thái',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: Constant.TEXT_SIZE,
                        ),
                      ),
                      Text(
                        order.isDelivered ? 'Hoàn tất' : 'Đang chờ',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      BaseDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: Constant.GENERAL_PADDING,
                              ),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text('Đánh giá'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: Constant.GENERAL_PADDING,
                              ),
                              child: ElevatedButton(
                                onPressed: () => launch('tel:0902514621'),
                                child: Text('Gọi hỗ trợ'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Đặt lại'),
                      ),
                      Text(
                        'Thông tin đơn hàng',
                        style: TextStyle(
                          fontSize: Constant.SUB_HEADING,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      BaseDivider(),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Constant.GENERAL_PADDING,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Text(
                                        'Người nhận',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    Text(order.recipientName)
                                  ],
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.black54,
                              indent: Constant.GENERAL_PADDING,
                              endIndent: Constant.GENERAL_PADDING,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    Constant.GENERAL_PADDING),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'Số điện thoại',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    Text(order.recipientPhone),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Constant.GENERAL_PADDING,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderMethod == 'Giao tận nơi'
                                  ? 'Giao đến'
                                  : 'Đến lấy tại',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(context
                                    .read<Stores>()
                                    .getNameById(order.orderAddress) ??
                                order.orderAddress),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Constant.GENERAL_PADDING,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mã đơn hàng',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(order.id),
                          ],
                        ),
                      ),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Các món đã chọn',
                            style: TextStyle(
                              fontSize: Constant.SUB_HEADING,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          BaseDivider(),
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, index) => Divider(
                              color: Colors.black54,
                            ),
                            shrinkWrap: true,
                            itemBuilder: (_, index) => ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              horizontalTitleGap: 8,
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    order.cart.cartItems[index].quantity
                                        .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Constant.TEXT_SIZE,
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                Provider.of<Products>(context, listen: false)
                                            .getProductById(order.cart
                                                .cartItems[index].productId) ==
                                        null
                                    ? 'Removed'
                                    : Provider.of<Products>(context,
                                            listen: false)
                                        .getProductById(order
                                            .cart.cartItems[index].productId)
                                        .title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                (order.cart.cartItems[index].note == null ||
                                        order.cart.cartItems[index].note
                                            .isNotEmpty)
                                    ? order.cart.cartItems[index].note
                                    : 'Default',
                              ),
                              trailing: Text(
                                  order.cart.cartItems[index].formmatedPrice),
                            ),
                            itemCount: order.cart.cartItems.length,
                          ),
                        ],
                      ),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng cộng',
                            style: TextStyle(
                              fontSize: Constant.SUB_HEADING,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          BaseDivider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Constant.GENERAL_PADDING,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tổng cộng'),
                                Text(order.cart.formattedTotalCartItem),
                              ],
                            ),
                          ),
                          Divider(),
                          order.promotionId != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Khuyến mãi',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        Text(
                                          order.promotionId,
                                        )
                                      ],
                                    ),
                                    Text(
                                      '- ' +
                                          NumberFormat.currency(
                                            locale: 'vi-VN',
                                            decimalDigits: 0,
                                          ).format(
                                              order.cart.totalCartItemsValue -
                                                  order.orderValue),
                                    ),
                                  ],
                                )
                              : Container(),
                          order.promotionId != null ? Divider() : Container(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Constant.GENERAL_PADDING,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Số tiền thanh toán',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  order.formattedOrderValue,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
