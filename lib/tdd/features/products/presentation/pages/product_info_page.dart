import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/tdd/features/order/presentation/providers/cart_provider.dart';
import 'package:the/tdd/features/order/domain/entities/cart_item.dart';
import 'package:the/tdd/features/products/domain/entities/product.dart';
import 'package:the/tdd/features/products/presentation/providers/product_info_provider.dart';
import 'package:the/tdd/features/user/presentation/widgets/favorite_product_button.dart';
import 'package:the/utils/helpers/currency_helper.dart';
import 'package:the/utils/values/colors.dart';
import 'package:the/utils/values/dimens.dart';
import 'package:provider/provider.dart';

class ProductInfoPage extends StatelessWidget {
  static const routeName = '/product_info_page';

  final Product _product;

  ProductInfoPage(this._product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.BOTTOM_SHEET_NAVIGATION_COLOR,
          ),
        ),
        padding: EdgeInsets.all(
          Platform.isIOS ? AppDimens.LARGE_PADDING : AppDimens.MEDIUM_PADDING,
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
                  FittedBox(
                    child: Text(
                      '1 món ${_product.title}',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimens.SMALL_TEXT_SIZE,
                      ),
                    ),
                  ),
                  Text(
                    CurrencyHelper.formatPrice(
                      _product.price *
                          context.select<ProductInfoProvider, int>(
                            (provider) => provider.quantity,
                          ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimens.SMALL_TEXT_SIZE,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: GestureDetector(
                onTap: () {
                  context.read<CartProvider>().addItemToCart(
                        CartItem(
                          productId: _product.id,
                          title: _product.title,
                          unitPrice: _product.price,
                          quantity:
                              context.read<ProductInfoProvider>().quantity,
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
                      fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
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
          physics: PageScrollPhysics(),
          shrinkWrap: true,
          children: [
            Image.network(
              _product.imageUrl,
              errorBuilder: (_, exception, stackTrace) => Center(
                child: Text(
                  'Unable to load image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
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
                                _product.title,
                                style: TextStyle(
                                  fontSize: AppDimens.LARGE_TEXT_SIZE,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                              ),
                              SizedBox(
                                  height: AppDimens.SMALL_SIZED_BOX_HEIGHT),
                              Text(
                                CurrencyHelper.formatPrice(_product.price),
                                style: TextStyle(
                                  fontSize: AppDimens.SMALL_TEXT_SIZE,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppDimens.SIZED_BOX_WIDTH),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// TODO show heart and implement functionality
                            FavoriteProductButton(_product.id),
                            Text(
                              'YÊU THÍCH',
                              style: TextStyle(
                                fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                  Flexible(
                    flex: 2,
                    child: Text(
                      _product.description,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: AppDimens.SMALL_TEXT_SIZE,
                      ),
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
              padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
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
                          fontSize: AppDimens.SMALL_TEXT_SIZE,
                        ),
                      ),
                      Chip(
                        labelPadding: EdgeInsets.symmetric(
                          horizontal: AppDimens.MEDIUM_PADDING,
                          vertical: AppDimens.SMALL_PADDING,
                        ),
                        label: Text(
                          'TÙY CHỌN',
                          style: TextStyle(
                            fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                          ),
                        ),
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                    child: BottomSheetTextField(),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: AppDimens.MEDIUM_PADDING),
                    padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                    width: (2 / 3).sw,
                    child: Card(
                      elevation: AppDimens.ELEVATION,
                      shadowColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Consumer<ProductInfoProvider>(
                        builder: (_, provider, __) => ListTile(
                          leading: IconButton(
                              splashColor: Colors.transparent,
                              icon: Icon(
                                FlutterIcons.dash_oct,
                              ),
                              onPressed: () {
                                if (provider.quantity <= 1) return;
                                provider.quantity--;
                              }),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            splashColor: Colors.transparent,
                            onPressed: () => provider.quantity++,
                          ),
                          title: Text(
                            provider.quantity.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppDimens.SMALL_TEXT_SIZE,
                            ),
                          ),
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
      style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
      decoration: InputDecoration(
        hintText: 'Ví dụ: Ít đá, nhiều đường...',
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS),
        ),
      ),
    );
  }
}
