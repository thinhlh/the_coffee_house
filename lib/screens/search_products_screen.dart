import 'package:flutter/material.dart';

import 'package:the_coffee_house/const.dart' as Constant;

class SearchProductsScreen extends StatefulWidget {
  static const routeName = '/search_products_screen';

  @override
  _SearchProductsScreenState createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: Constant.ELEVATION,
        titleSpacing: 0,
        centerTitle: true,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.all(Constant.GENERAL_PADDING),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey.shade300,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
                    borderSide: BorderSide.none,
                  ),
                  // icon: Icon(
                  //   Icons.search,
                  //   color: Colors.grey.shade600,
                  // ),
                  hintText: 'Tìm kiếm...',
                ),
              ),
            ),
            TextButton(
              child: Text(
                'Đóng',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
