import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:the/providers/user_orders.dart';
import 'package:the/widgets/base_divider.dart';
import 'package:the/utils/const.dart' as Constant;

class PointHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử tích luỹ điểm'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
        shrinkWrap: true,
        children: [
          Text(
            'Lịch sử điểm',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          BaseDivider(),
          SizedBox(
            height: Constant.SIZED_BOX_HEIGHT,
          ),
          Consumer<UserOrders>(
            builder: (_, ordersProvider, child) => ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, index) => ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text(
                  'Đơn hàng #${ordersProvider.deliveredOrders[index].id}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Constant.TEXT_SIZE,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      (ordersProvider.deliveredOrders[index].orderValue ~/ 1000)
                          .toString(),
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Constant.GENERAL_PADDING),
                  child: Text(
                    ordersProvider.deliveredOrders[index].formattedOrderTime,
                  ),
                ),
              ),
              separatorBuilder: (_, index) => Divider(),
              itemCount: ordersProvider.deliveredOrders.length,
            ),
          )
        ],
      ),
    );
  }
}
