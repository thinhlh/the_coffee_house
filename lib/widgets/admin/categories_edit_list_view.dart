import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/screens/admin/category_edit_screen.dart';

import '../../providers/categories.dart';
import '../../utils/const.dart' as Constant;

class EditCategoriesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Categories>(
      builder: (_, categoriesProvider, child) {
        final categories = categoriesProvider.categories;
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (_, index) => Column(
            children: [
              ListTile(
                title: Text(categories[index].title),
                leading: Image.network(
                  categories[index].imageUrl,
                  errorBuilder: (_, exception, stackTrace) => Center(
                    child: Text(
                      'Unable to load image',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  width: 40,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) =>
                                EditCategoryScreen(categories[index].id)),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            elevation: Constant.ELEVATION,
                            title: Text('Delete'),
                            content: Text(
                                'Are you sure want to delete this categor?'),
                            actions: [
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                ),
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.blue),
                                ),
                                child: Text('Yes'),
                                onPressed: () {
                                  categoriesProvider
                                      .deleteCategory(categories[index].id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
