import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import '../models/product.dart';
import 'bottom_sheet_product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showBarModalBottomSheet(
        expand: true,
        context: context,
        builder: (context) => BottomSheetProduct(product.id),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
          ),
          elevation: Constant.ELEVATION,
          child: Padding(
            padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          product.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Text(
                          product.description,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: Constant.LIST_TILE_TITTLE),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          NumberFormat.currency(
                            locale: 'vi-VN',
                            decimalDigits: 0,
                          ).format(product.price),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                  child: ClipRRect(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
