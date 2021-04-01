import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/models/category.dart';
import 'package:the_coffee_house/providers/categories.dart';
import 'package:the_coffee_house/screens/home/products_overview_screen.dart';
import 'package:the_coffee_house/services/firestore_categories.dart';

class CategoryListView extends StatefulWidget {
  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  List<Category> categories;

  @override
  void initState() {
    categories = Provider.of<Categories>(context, listen: false).categories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Categories>(
        stream: FireStoreCategories().categories,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          else
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final productsPerCategory =
                    Provider.of<Categories>(context, listen: false)
                        .getNumberOfProductsByCategoryId(
                            context, categories[index].id);

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
                    contentPadding:
                        const EdgeInsets.all(Constant.GENERAL_PADDING),
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
            );
        });
  }
}
