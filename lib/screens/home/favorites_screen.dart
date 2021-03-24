import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/const.dart' as Constant;

import '../../providers/products.dart';
import '../../widgets/product_card.dart';

class FavoriteScreen extends StatelessWidget {
  static const routeName = '/favorite_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Món yêu thích'),
      ),
      body: Provider.of<Products>(context, listen: false)
              .favoriteProducts
              .isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 50,
                    ),
                    backgroundColor: Colors.grey.withAlpha(50),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Bạn chưa có món yêu thích',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
              child: Consumer<Products>(
                builder: (_, provider, child) => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) =>
                      ProductCard(provider.favoriteProducts[index]),
                  itemCount: provider.favoriteProducts.length,
                ),
              ),
            ),
    );
  }
}