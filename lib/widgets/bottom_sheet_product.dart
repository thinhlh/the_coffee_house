import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../providers/user_provider.dart';
import '../utils/const.dart' as Constant;

class BottomSheetProduct extends StatefulWidget {
  final productId;
  BottomSheetProduct(this.productId);

  @override
  _BottomSheetProductState createState() => _BottomSheetProductState();
}

class _BottomSheetProductState extends State<BottomSheetProduct> {
  Product product;

  Image image;

  int quantity = 1;

  @override
  void initState() {
    product = Provider.of<Products>(context, listen: false)
        .getProductById(widget.productId);
    image = Image.network(
      product.imageUrl,
      errorBuilder: (_, exception, stackTrace) => Center(
        child: Text(
          'Unable to load image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(141, 89, 43, 1),
              Color.fromRGBO(240, 150, 74, 1),
              Color.fromRGBO(141, 89, 43, 1),
            ],
          ),
        ),
        padding: EdgeInsets.all(
          Platform.isIOS
              ? 2 * Constant.GENERAL_PADDING
              : Constant.GENERAL_PADDING,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$quantity món ${product.title}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: 'vi-VN',
                      decimalDigits: 0,
                    ).format(product.price * quantity),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: GestureDetector(
                onTap: () {
                  Provider.of<Cart>(context, listen: false).addCartItem(
                    CartItem(
                      productId: product.id,
                      title: product.title,
                      unitPrice: product.price,
                      quantity: quantity,
                      note: _controller.text,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Chip(
                  backgroundColor: Colors.white,
                  label: Text(
                    'Chọn món',
                    style: TextStyle(
                      color: Color.fromRGBO(202, 118, 53, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          physics: PageScrollPhysics(),
          children: [
            image,
            Container(
              padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                maxLines: 3,
                                overflow: TextOverflow.clip,
                              ),
                              Text(
                                product.formattedPrice,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Constant.SIZED_BOX_HEIGHT,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Consumer<UserProvider>(
                              builder: (_, userProvider, child) {
                                return TextButton(
                                  onPressed: () {
                                    userProvider
                                        .toggleFavoriteStatus(widget.productId);
                                  },
                                  child: userProvider
                                          .isFavorite(widget.productId)
                                      ? Icon(
                                          Icons.favorite_rounded,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Icon(
                                          Icons.favorite_border_rounded,
                                          color: Colors.black,
                                        ),
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                );
                              },
                            ),
                            Text(
                              'YÊU THÍCH',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      product.description,
                      softWrap: true,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Yêu cầu khác',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Chip(
                        label: Text('TÙY CHỌN'),
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                    child: BottomSheetTextField(),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: Constant.GENERAL_PADDING),
                    padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                    width: (2 / 3).sw,
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        leading: IconButton(
                            splashColor: Colors.transparent,
                            icon: Icon(
                              FlutterIcons.dash_oct,
                            ),
                            onPressed: () {
                              if (quantity <= 1) return;
                              setState(() => quantity--);
                            }),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => setState(() => quantity++),
                        ),
                        title: Column(
                          children: [
                            Text(
                              quantity.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
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
    );
  }
}

TextEditingController _controller = TextEditingController();

class BottomSheetTextField extends StatefulWidget {
  @override
  _BottomSheetTextFieldState createState() => _BottomSheetTextFieldState();
}

class _BottomSheetTextFieldState extends State<BottomSheetTextField> {
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLength: 40,
      decoration: InputDecoration(
        hintText: 'Ví dụ: Ít đá, nhiều đường...',
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
        ),
      ),
    );
  }
}
