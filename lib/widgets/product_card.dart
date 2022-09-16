import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../providers/products.dart';
import '../utils/const.dart' as Constant;
import 'bottom_sheet_product.dart';

class ProductCard extends StatelessWidget {
  final String _productId;
  ProductCard(this._productId);

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Products>(context, listen: false)
        .getProductById(_productId);

    //This is for when  product is deleted
    if (product == null) {
      return Container();
    }

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
        height: 0.17.sh,
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
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        );
                      },
                      errorBuilder: (_, exception, stackTrace) => Center(
                        child: Text(
                          'Unable to load image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
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
