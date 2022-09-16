import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/models/category.dart';
import 'package:the/providers/categories.dart';
import 'package:the/providers/products.dart';
import 'package:the/screens/admin/category_edit_screen.dart';
import 'package:the/services/categories_api.dart';
import '/utils/const.dart' as Constant;

class AdminCategoriesScreen extends StatelessWidget {
  static const routeName = '/admin-categories-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories Management'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EditCategoryScreen(null),
              ),
            ),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<Categories>(
          builder: (_, categoriesProvider, child) => ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                itemBuilder: (_, index) =>
                    AdminCategoryCard(categoriesProvider.categories[index]),
                itemCount: categoriesProvider.categories.length,
              )),
    );
  }
}

class AdminCategoryCard extends StatelessWidget {
  final Category category;
  AdminCategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      background: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.shade200,
          borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            child: Icon(
              Icons.delete,
              size: 30,
            ),
            margin: const EdgeInsets.only(right: 20),
          ),
        ),
      ),
      confirmDismiss: (direction) => showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('Delete this category?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              isDefaultAction: false,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              child: Text('Proceed'),
              isDefaultAction: true,
              onPressed: () => CategoriesAPI()
                  .delete(category.id)
                  .then((value) => Navigator.of(context).pop(true)),
            ),
          ],
        ),
      ).then((value) => value),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => EditCategoryScreen(
              category.id,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: Constant.GENERAL_PADDING / 2,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
            ),
            elevation: Constant.ELEVATION,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Constant.GENERAL_PADDING / 3,
                        horizontal: Constant.GENERAL_PADDING / 2,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          category.imageUrl,
                          fit: BoxFit.cover,
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
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text(
                            category.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Constant.TEXT_SIZE,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: Text(
                              'Number of products: ' +
                                  context
                                      .read<Categories>()
                                      .getNumberOfProductsByCategoryId(
                                        context.read<Products>(),
                                        category.id,
                                      )
                                      .toString(),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
