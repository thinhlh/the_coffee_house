import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/helpers/admin_search_product.dart';
import 'package:the/providers/products.dart';
import 'package:the/screens/admin/product_edit_screen.dart';
import 'package:the/widgets/admin/admin_product_card.dart';
import '/utils/const.dart' as Constant;

class AdminProductsScreen extends StatelessWidget {
  static const routeName = '/admin-products-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products Management'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductEditScreen(null),
              ),
            ),
            icon: Icon(Icons.add),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: AdminSearchProduct(),
            ),
          ),
        ],
      ),
      body: Consumer<Products>(
        builder: (_, productsProvider, child) => ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
          itemBuilder: (_, index) =>
              AdminProductCard(productsProvider.products[index]),
          itemCount: productsProvider.products.length,
        ),
      ),
    );
  }
}
