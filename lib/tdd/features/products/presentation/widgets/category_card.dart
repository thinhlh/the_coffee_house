import 'package:flutter/material.dart';
import 'package:the/tdd/features/products/domain/entities/category.dart';
import 'package:the/tdd/features/products/presentation/pages/products_page.dart';
import 'package:the/utils/const.dart';
import 'package:the/utils/values/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryCard extends StatelessWidget {
  final Category _category;
  final int _productsPerCategory;

  CategoryCard(this._category, this._productsPerCategory);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () =>
            Navigator.of(context).pushNamed(ProductsPage.routeName, arguments: {
          'categoryId': _category.id,
          'title': _category.title,
        }),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: AppDimens.SMALL_PADDING),
          height: 0.15.sh,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
            ),
            elevation: AppDimens.ELEVATION,
            child: Padding(
              padding: EdgeInsets.all(AppDimens.SMALL_PADDING),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Text(
                        _category.title,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '$_productsPerCategory món',
                        style: TextStyle(
                          fontSize: AppDimens.SMALL_TEXT_SIZE,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                      child: ClipRRect(
                        child: Image.network(
                          _category.imageUrl,
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
