import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;
import 'package:the_coffee_house/providers/products.dart';

class BottomSheetProduct extends StatelessWidget {
  final productId;
  final double topPadding;
  BottomSheetProduct(this.productId, this.topPadding);

  @override
  Widget build(BuildContext context) {
    final product =
        Provider.of<Products>(context, listen: false).getProductById(productId);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ListView(
              children: [
                Image.network(product.imageUrl),
                Padding(
                  padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    NumberFormat.currency(
                                      locale: 'vi-VN',
                                      decimalDigits: 0,
                                    ).format(product.price),
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
                            _FavoriteButton(() {}),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        height: 10,
                        color: Colors.grey.shade200,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(
                FlutterIcons.cross_ent,
                color: Colors.black,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  CircleBorder(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final handler;

  bool isClicked;

  _FavoriteButton(this.handler, {this.isClicked = false});

  @override
  __FavoriteButtonState createState() => __FavoriteButtonState();
}

class __FavoriteButtonState extends State<_FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          child: Icon(
            widget.isClicked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            setState(
              () {
                widget.isClicked = !widget.isClicked;
                widget.handler();
              },
            );
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
        Text(
          'YÊU THÍCH',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class BottomSheetTextField extends StatefulWidget {
  @override
  _BottomSheetTextFieldState createState() => _BottomSheetTextFieldState();
}

class _BottomSheetTextFieldState extends State<BottomSheetTextField> {
  TextEditingController _controller;

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
