import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/cart.dart';
import 'package:the_coffee_house/widgets/cart_bottom_navigation.dart';

class OrderConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      bottomNavigationBar: CartBottomNavigation(),
      body: Consumer<Cart>(
        builder: (_, provider, child) => SingleChildScrollView(
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
                        provider.clearCart();
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
                      leading: Icon(Icons.edit),
                      title: Text(
                        '${provider.cart[index].quantity}x ${provider.cart[index].title}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Property'),
                      trailing: Text(
                        NumberFormat.currency(
                          locale: 'vi-VN',
                          decimalDigits: 0,
                        ).format(provider.cart[index].price),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                itemCount: provider.cart.length,
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
                          NumberFormat.currency(
                            locale: 'vi-VN',
                            decimalDigits: 0,
                          ).format(provider.totalPrice),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
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
                        RotatedBox(
                          child: Icon(Icons.expand_more),
                          quarterTurns: 3,
                        ),
                      ],
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
                          NumberFormat.currency(
                            locale: 'vi-VN',
                            decimalDigits: 0,
                          ).format(provider.totalPrice),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
