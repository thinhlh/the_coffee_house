import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/cart.dart';
import 'package:the_coffee_house/screens/order_confirmation_screen.dart';

class CartBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (_, provider, child) => provider.isEmpty
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
              padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.numberOfItems.toString() +
                            ' món trong giỏ hàng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () => showBarModalBottomSheet(
                      context: context,
                      builder: (_) => OrderConfirmationScreen(),
                    ),
                    child: Chip(
                      backgroundColor: Colors.white,
                      label: Text(
                        'GIỎ HÀNG',
                        style: TextStyle(
                          color: Color.fromRGBO(202, 118, 53, 1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
