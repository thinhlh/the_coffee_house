import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/products.dart';
import 'package:the_coffee_house/screens/admin_screens/product_edit_screen.dart';

class EditProductsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Products>(
      builder: (_, provider, child) {
        final products = provider.products;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (_, index) => Column(
            children: [
              ListTile(
                title: Text(products[index].title),
                leading: Image.network(
                  products[index].imageUrl,
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
                                EditProductScreen(products[index].id)),
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
                                'Are you sure want to delete this product?'),
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
                                  Provider.of<Products>(context, listen: false)
                                      .deleteProduct(
                                          products[index].id, context);

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
