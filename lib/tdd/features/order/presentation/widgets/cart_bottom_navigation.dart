import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/order/presentation/pages/order_confirmation_page.dart';
import 'package:the/tdd/features/order/presentation/providers/cart_provider.dart';
import 'package:the/utils/helpers/currency_helper.dart';
import 'package:the/utils/values/colors.dart';
import 'package:the/utils/values/dimens.dart';

class CartBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (_, provider, child) => provider.cartItems.isEmpty
          ? Container(height: 0, width: 0)
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                gradient: LinearGradient(
                  colors: AppColors.BOTTOM_SHEET_NAVIGATION_COLOR,
                ),
              ),
              padding: EdgeInsets.all(Platform.isIOS
                  ? AppDimens.LARGE_PADDING
                  : AppDimens.MEDIUM_PADDING),
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
                          fontSize: AppDimens.SMALL_TEXT_SIZE,
                        ),
                      ),
                      Text(
                        CurrencyHelper.formatPrice(provider.totalCartValue),
                        style: TextStyle(
                          fontSize: AppDimens.SMALL_TEXT_SIZE,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () => showBarModalBottomSheet(
                      context: context,
                      builder: (_) => OrderConfirmationPage(),
                    ),
                    child: Chip(
                      backgroundColor: Colors.white,
                      label: Text(
                        'GIỎ HÀNG',
                        style: TextStyle(
                          color: Color.fromRGBO(202, 118, 53, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
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
