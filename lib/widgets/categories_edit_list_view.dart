import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/categories.dart';
import 'package:the_coffee_house/screens/admin_screens/category_edit_screen.dart';

class EditcategoriesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Categories>(
      builder: (_, provider, child) {
        final categories = provider.categories;
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (_, index) => Column(
            children: [
              ListTile(
                title: Text(categories[index].title),
                leading: Image.network(
                  categories[index].imageUrl,
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
                                  Provider.of<Categories>(context,
                                          listen: false)
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
