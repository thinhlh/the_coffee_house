import 'package:flutter/material.dart';

import '../../utils/const.dart' as Constant;
import '../../widgets/admin/categories_edit_list_view.dart';
import '../../widgets/admin/notifications_edit_list_view.dart';
import '../../widgets/admin/products_edit_list_view.dart';
import 'category_edit_screen.dart';
import 'edit_option.dart';
import 'notification_edit_screen.dart';
import 'product_edit_screen.dart';

class GeneralEditScreen extends StatefulWidget {
  static const routeName = '/admin_screens/general_edit_screen';

  @override
  _GeneralEditScreenState createState() => _GeneralEditScreenState();
}

class _GeneralEditScreenState extends State<GeneralEditScreen> {
  EditOption editOption;

  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      editOption = ModalRoute.of(context).settings.arguments as EditOption;
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          editOption == EditOption.product
              ? 'Products'
              : editOption == EditOption.category
                  ? 'Categories'
                  : 'Notifications',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => editOption == EditOption.product
                    ? EditProductScreen(null)
                    : editOption == EditOption.category
                        ? EditCategoryScreen(null)
                        : EditNotificationScreen(null),
              ),
            ),
            child: Icon(Icons.add),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
        child: editOption == EditOption.product
            ? EditProductsListView()
            : editOption == EditOption.category
                ? EditCategoriesListView()
                : EditNotificationsListView(),
      ),
    );
  }
}
