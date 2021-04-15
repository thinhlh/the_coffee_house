import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/utils/const.dart' as Constant;
import 'package:the_coffee_house/models/product.dart';
import 'package:the_coffee_house/providers/products.dart';
import 'bottom_sheet_product.dart';

class ProductCard extends StatelessWidget {
  final String _productId;
  ProductCard(this._productId);

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Products>(context, listen: false)
        .getProductById(_productId);

    // if (product == null) {
    //   // toggle unfavorite this product
    //   Provider.of<UserProvider>(context, listen: false)
    //       .toggleFavoriteStatus(_productId);
    // }

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
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            product.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
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
                          product.formattedPrice,
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
