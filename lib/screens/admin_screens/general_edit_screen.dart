import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/categories.dart';
import 'package:the_coffee_house/providers/products.dart';
import 'package:the_coffee_house/screens/admin_screens/category_edit_screen.dart';
import 'package:the_coffee_house/screens/admin_screens/edit_option.dart';
import 'package:the_coffee_house/screens/admin_screens/product_edit_screen.dart';

class GeneralEditScreen extends StatefulWidget {
  static const routeName = '/admin_screens/general_edit_screen';

  @override
  _GeneralEditScreenState createState() => _GeneralEditScreenState();
}

class _GeneralEditScreenState extends State<GeneralEditScreen> {
  Future fetchProductFuture;
  Future fetchCategoryFuture;
  EditOption editOption;

  bool _isInit = true;

  Future fetchProducts() async {
    return await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  Future fetchCategories() async {
    return await Provider.of<Categories>(context, listen: false)
        .fetchCategories();
  }

  @override
  void initState() {
    fetchCategoryFuture = fetchCategories();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      editOption = ModalRoute.of(context).settings.arguments as EditOption;
      if (editOption == EditOption.product)
        // For product situation, we also need to fetch category in order to show the title to add or modify categoryId the product item
        fetchProductFuture = fetchProducts();

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> onRefresh(BuildContext context, EditOption option) async {
    if (option == EditOption.product)
      await fetchProducts();
    else
      await fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: editOption == EditOption.product
          ? fetchProductFuture
          : fetchCategoryFuture,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            {
              var products;
              var categories;
              if (editOption == EditOption.product) {
                products = Provider.of<Products>(context).products;
              } else {
                categories = Provider.of<Categories>(context).categories;
              }

              return Scaffold(
                appBar: AppBar(
                  title: Text(editOption == EditOption.product
                      ? 'Products'
                      : 'Categories'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => editOption == EditOption.product
                                  ? EditProductScreen(null)
                                  : EditCategoryScreen(null))),
                      child: Icon(Icons.add),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                  ],
                ),
                body: RefreshIndicator(
                  onRefresh: () => onRefresh(context, editOption),
                  child: Padding(
                    padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                    child: ListView.builder(
                      itemCount: editOption == EditOption.product
                          ? products.length
                          : categories.length,
                      itemBuilder: (_, index) => Column(
                        children: [
                          ListTile(
                            title: Text(editOption == EditOption.product
                                ? products[index].title
                                : categories[index].title),
                            leading: Image.network(
                              editOption == EditOption.product
                                  ? products[index].imageUrl
                                  : categories[index].imageUrl,
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
                                          editOption == EditOption.product
                                              ? EditProductScreen(
                                                  products[index].id)
                                              : EditCategoryScreen(
                                                  categories[index].id),
                                    ),
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
                                            'Are you sure want to delete this ${editOption == EditOption.product ? 'product' : 'categories'}?'),
                                        actions: [
                                          TextButton(
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red),
                                            ),
                                            child: Text('No'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.blue),
                                            ),
                                            child: Text('Yes'),
                                            onPressed: () {
                                              editOption == EditOption.product
                                                  ? Provider.of<Products>(
                                                          context,
                                                          listen: false)
                                                      .deleteProduct(
                                                          products[index].id)
                                                  : Provider.of<Categories>(
                                                          context,
                                                          listen: false)
                                                      .deleteCategory(
                                                          categories[index].id);
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
                    ),
                  ),
                ),
              );
            }
          default:
            return Scaffold(
              body: Center(
                child: Text(
                  'Something gone wrong!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
