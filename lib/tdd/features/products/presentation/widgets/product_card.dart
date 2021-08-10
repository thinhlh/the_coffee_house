import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:the/tdd/features/products/domain/entities/product.dart';
import 'package:the/tdd/features/products/presentation/pages/product_info_page.dart';
import 'package:the/utils/helpers/currency_helper.dart';
import 'package:the/utils/values/colors.dart';
import 'package:the/utils/values/dimens.dart';

class ProductCard extends StatelessWidget {
  final Product _product;
  ProductCard(this._product);

  @override
  Widget build(BuildContext context) {
    //This is for when  product is deleted
    if (_product == null) {
      return Container();
    }

    return GestureDetector(
      onTap: () => showBarModalBottomSheet(
        expand: true,
        context: context,
        builder: (context) => ProductInfoPage(_product),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
        ),
      ),
      child: SizedBox(
        height: 0.17.sh,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
          ),
          elevation: AppDimens.ELEVATION,
          child: Padding(
            padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            _product.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Text(
                          _product.description,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: AppDimens.SMALL_TEXT_SIZE),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          CurrencyHelper.formatPrice(_product.price),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: AppDimens.SMALL_TEXT_SIZE,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                    child: ClipRRect(
                      child: Image.network(
                        _product.imageUrl,
                        loadingBuilder: (_, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.PRIMARY_COLOR,
                            ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
