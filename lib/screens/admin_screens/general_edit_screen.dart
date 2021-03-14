import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/models/category.dart';
import 'package:the_coffee_house/models/product.dart';
import 'package:the_coffee_house/providers/categories.dart';
import 'package:the_coffee_house/providers/products.dart';
import 'package:the_coffee_house/screens/admin_screens/category_edit_screen.dart';
import 'package:the_coffee_house/screens/admin_screens/edit_option.dart';
import 'package:the_coffee_house/screens/admin_screens/product_edit_screen.dart';
import 'package:the_coffee_house/widgets/categories_edit_list_view.dart';
import 'package:the_coffee_house/widgets/products_edit_list_view.dart';

class GeneralEditScreen extends StatefulWidget {
  static const routeName = '/admin_screens/general_edit_screen';

  @override
  _GeneralEditScreenState createState() => _GeneralEditScreenState();
}

class _GeneralEditScreenState extends State<GeneralEditScreen> {
  EditOption editOption;

  List<Product> products;
  List<Category> categories;

  bool isInit = true;

  @override
  void initState() {
    categories = Provider.of<Categories>(context, listen: false).categories;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      editOption = ModalRoute.of(context).settings.arguments as EditOption;
      if (editOption == EditOption.product)
        // For product situation, we also need to fetch category in order to show the title to add or modify categoryId the product item
        products = Provider.of<Products>(context, listen: false).products;
      isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> onRefresh(BuildContext context, EditOption option) async {
    if (option == EditOption.product)
      await Provider.of<Products>(context, listen: false).fetchProducts();
    else
      await Provider.of<Categories>(context, listen: false).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(editOption == EditOption.product ? 'Products' : 'Categories'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => editOption == EditOption.product
                    ? EditProductScreen(null)
                    : EditCategoryScreen(null),
              ),
            ),
            child: Icon(Icons.add),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => onRefresh(context, editOption),
        child: Padding(
          padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
          child: editOption == EditOption.product
              ? EditProductsListView()
              : EditcategoriesListView(),
        ),
      ),
    );
  }
}
