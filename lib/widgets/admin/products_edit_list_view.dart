import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/screens/admin/product_edit_screen.dart';

import '../../providers/products.dart';
import '../../utils/const.dart' as Constant;

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
                                ProductEditScreen(products[index].id)),
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
                                  provider.deleteProduct(
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
