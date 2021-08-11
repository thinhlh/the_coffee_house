import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/models/custom_user.dart';
import 'package:the/models/order.dart';
import 'package:the/models/product.dart';
import 'package:the/providers/admin_orders.dart';
import 'package:the/providers/products.dart';
import 'package:the/providers/stores.dart';
import 'package:the/providers/users.dart';
import 'package:the/services/admin_orders_api.dart';
import 'package:the/services/order_api.dart';
import 'package:the/utils/const.dart' as Constant;
import 'package:the/widgets/base_divider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminOrderDetail extends StatelessWidget {
  final String id;
  AdminOrderDetail(this.id);

  @override
  Widget build(BuildContext context) {
    Order order =
        Provider.of<AdminOrders>(context, listen: false).getOrderById(id);

    CustomUser user = Provider.of<Users>(context, listen: false)
        .getUserById(order.recipentId);

    Products productsProvider = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(order.id),
      ),
      body: FutureBuilder(
        future: OrderAPI().fetchCartItemToOrder(order),
        builder: (_, orderSnapshot) {
          if (orderSnapshot.connectionState != ConnectionState.done ||
              !orderSnapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else {
            return Padding(
              padding: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Customer Information',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BaseDivider(),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(
                        Icons.vpn_key,
                        color: Colors.amber.shade600,
                      ),
                      title: Text(order.recipentId),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(Icons.person),
                      title: Text(order.recipientName),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(order.recipientPhone),
                      leading: Icon(
                        Icons.phone,
                        color: Colors.green,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () async =>
                          await canLaunch('tel:${order.recipientPhone}')
                              ? launch('tel:${order.recipientPhone}')
                              : null,
                    ),
                    SizedBox(
                      height: Constant.SIZED_BOX_HEIGHT,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Order Information',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BaseDivider(),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(
                          order.orderMethod == 'Đến lấy tại cửa hàng'
                              ? Icons.coffee
                              : Icons.delivery_dining,
                          color: order.orderMethod == 'Đến lấy tại cửa hàng'
                              ? Colors.brown.shade400
                              : Colors.cyan),
                      title: Text(order.orderMethod),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(context
                              .read<Stores>()
                              .getNameById(order.orderAddress) ??
                          order.orderAddress),
                      leading: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(
                        Icons.timer,
                        color: Colors.teal,
                      ),
                      title: Text(order.formattedOrderTime),
                    ),
                    order.promotionId == null || order.promotionId.isEmpty
                        ? Container()
                        : ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(
                              Icons.chrome_reader_mode,
                              color: Colors.purple,
                            ),
                            title: Text(
                              order.promotionId,
                            ),
                          ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(
                        Icons.attach_money,
                        color: Colors.yellow.shade900,
                      ),
                      title: Text(
                        order.formattedOrderValue,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: Constant.SIZED_BOX_HEIGHT,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cart Items',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BaseDivider(),
                    SizedBox(height: Constant.SIZED_BOX_HEIGHT / 2),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        Product product = productsProvider.getProductById(
                            order.cart.cartItems[index].productId);
                        if (product == null) {
                          return Container();
                        } else {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Constant.BORDER_RADIUS),
                              ),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  Constant.GENERAL_PADDING,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (_, exception, stackTrace) =>
                                                Center(
                                          child: Text(
                                            'Unable to load image',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Constant.SIZED_BOX_HEIGHT,
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(
                                              product.title,
                                              maxLines: 1,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Constant.SUB_HEADING,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                Constant.SIZED_BOX_HEIGHT / 2,
                                          ),
                                          Text(
                                            'Note: ' +
                                                order
                                                    .cart.cartItems[index].note,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Quantity: ' +
                                            order.cart.cartItems[index].quantity
                                                .toString(),
                                        textAlign: TextAlign.right,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      itemCount: order.cart.cartItems.length,
                    ),
                    SizedBox(
                      height: Constant.SIZED_BOX_HEIGHT,
                    ),
                    ElevatedButton(
                        child: Text(
                          order.isDelivered ? 'Delivered' : 'Delivery',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            order.isDelivered
                                ? Colors.grey
                                : Colors.green.shade300,
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.all(2 * Constant.GENERAL_PADDING),
                          ),
                        ),
                        onPressed: order.isDelivered
                            ? null
                            : () {
                                if (user == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('User is removed'),
                                    ),
                                  );
                                }
                                AdminOrdersAPI()
                                    .delivery(
                                      orderId: id,
                                      recipientId: order.recipentId,
                                      expectedPoint: order.orderValue ~/ 1000 +
                                              user.point ??
                                          0,
                                    )
                                    .then(
                                        (value) => Navigator.of(context).pop());
                              }),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
