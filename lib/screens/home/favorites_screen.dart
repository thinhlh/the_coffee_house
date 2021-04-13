import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/utils/const.dart' as Constant;
import 'package:the_coffee_house/providers/user_provider.dart';
import 'package:the_coffee_house/widgets/product_card.dart';

class FavoriteScreen extends StatelessWidget {
  static const routeName = '/favorite_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Món yêu thích'),
      ),
      body: Consumer<UserProvider>(
        builder: (_, userProvider, child) => userProvider
                .user.favoriteProducts.isEmpty
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                child: Consumer<UserProvider>(
                  builder: (_, userProvider, child) => ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) =>
                        ProductCard(userProvider.favoriteProducts[index]),
                    itemCount: userProvider.favoriteProducts.length,
                  ),
                ),
              ),
      ),
    );
  }
}
