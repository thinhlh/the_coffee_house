import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/products.dart';
import '../screens/home/products_overview_screen.dart';
import '../utils/const.dart' as Constant;

class CategoryListView extends StatefulWidget {
  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Categories>(builder: (_, categoriesProvider, child) {
      final categories = categoriesProvider.categories;
      return Consumer<Products>(
        builder: (_, productProvider, child) => ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (_, index) {
            final productsPerCategory =
                categoriesProvider.getNumberOfProductsByCategoryId(
                    productProvider, categories[index].id);

            return Card(
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
              ),
              child: ListTile(
                onTap: () => Navigator.of(context).pushNamed(
                  ProductsOverviewScreen.routeName,
                  arguments: {
                    'tittle': categories[index].title,
                    'categoryId': categories[index].id,
                  },
                ),
                contentPadding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                title: Text(
                  categories[index].title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Constant.TEXT_SIZE,
                  ),
                ),
                subtitle: Text('$productsPerCategory món'),
                trailing: Image.network(categories[index].imageUrl,
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
                }),
              ),
            );
          },
        ),
      );
    });
  }
}
