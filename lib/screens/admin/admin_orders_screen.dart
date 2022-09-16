import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/helpers/search_notification.dart';
import 'package:the/helpers/admin_search_product.dart';
import 'package:the/models/order.dart';
import 'package:the/providers/admin_orders.dart';
import 'package:the/screens/admin/admin_order_detail.dart';
import 'package:the/screens/admin/product_edit_screen.dart';
import 'package:the/services/admin_orders_api.dart';
import 'package:the/services/notifications_api.dart';
import '/utils/const.dart' as Constant;

class AdminOrdersScreen extends StatefulWidget {
  static const routeName = '/admin-orders-screen';

  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  //0 is not filter, 1 is filter to delivered, 2 is filter to not yet delivered, maximum value is 2
  int option = 0;
  List<Order> filteredOrders;

  @override
  void initState() {
    filteredOrders = context.read<AdminOrders>().orders;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminOrders>(
        child: AppBar(
          title: Text('Orders Management'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              onPressed: () => setState(() {
                option = (++option) == 3 ? 0 : option;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(option == 0
                        ? 'All Orders'
                        : option == 1
                            ? 'Delivered Orders'
                            : 'Pending Orders'),
                    duration: Duration(milliseconds: 500),
                  ),
                );
              }),
              icon: Icon(Icons.filter_alt),
            ),
          ],
        ),
        builder: (_, ordersProvider, child) {
          if (option == 1)
            filteredOrders = ordersProvider.deliveredOrders;
          else if (option == 2)
            filteredOrders = ordersProvider.notDeliveredOrders;
          else
            filteredOrders = ordersProvider.orders;
          return Scaffold(
            appBar: child,
            body: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
              itemBuilder: (_, index) => AdminOrderCard(filteredOrders[index]),
              itemCount: filteredOrders.length,
            ),
          );
        });
  }
}

class AdminOrderCard extends StatelessWidget {
  final Order order;
  AdminOrderCard(this.order);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key('Orders List'),
      background: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.shade200,
          borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            child: Icon(
              Icons.delete,
              size: 30,
            ),
            margin: const EdgeInsets.only(right: 20),
          ),
        ),
      ),
      confirmDismiss: (direction) => showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('Delete this order?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              isDefaultAction: false,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
                child: Text('Proceed'),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop(true);
                  AdminOrdersAPI().delete(order.id);
                }),
          ],
        ),
      ).then((value) => value),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => AdminOrderDetail(order.id),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: Constant.GENERAL_PADDING / 2,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
            ),
            elevation: Constant.ELEVATION,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          isThreeLine: true,
                          title: Text(
                            order.recipientName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Constant.TEXT_SIZE,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  order.formattedOrderTime,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                order.formattedOrderValue,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Constant.GENERAL_PADDING / 3,
                          horizontal: Constant.GENERAL_PADDING / 2,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  order.isDelivered ? 'Delivered' : 'Pending',
                                  style: TextStyle(
                                    color: order.isDelivered
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  softWrap: true,
                                ),
                              ),
                            ),
                            SizedBox(width: Constant.SIZED_BOX_HEIGHT / 3),
                            Icon(
                              order.isDelivered ? Icons.check : Icons.close,
                              color:
                                  order.isDelivered ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
