import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/providers/user_orders.dart';
import 'package:the/widgets/product_card.dart';
import 'package:the/utils/const.dart' as Constant;

class RecentlyOrderedProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Các món vừa đặt'),
        centerTitle: true,
      ),
      body: Consumer<UserOrders>(
        builder: (_, ordersProvider, child) => FutureBuilder(
          builder: (_, orderedProductsSnapshot) {
            if (orderedProductsSnapshot.connectionState != ConnectionState.done)
              return Center(
                child: CircularProgressIndicator(),
              );
            List<String> productsInLastOrder = orderedProductsSnapshot.data;
            if (productsInLastOrder.isEmpty || productsInLastOrder == null)
              return Center(
                child: Text(
                  'You haven\'t order yet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              );
            return ListView.builder(
              padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
              itemBuilder: (_, index) =>
                  ProductCard(productsInLastOrder[index]),
              itemCount: productsInLastOrder.length,
            );
          },
          future: ordersProvider.recentlyOrderedProducts,
        ),
      ),
    );
  }
}
