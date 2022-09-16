import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../utils/const.dart' as Constant;
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
      body: Consumer<UserProvider>(builder: (_, userProvider, child) {
        return userProvider.user.favoriteProducts.isEmpty
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
            : ListView.separated(
                padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return ProductCard(userProvider.favoriteProducts[index]);
                },
                separatorBuilder: (_, index) => SizedBox(
                  height: Constant.SIZED_BOX_HEIGHT / 2,
                ),
                itemCount: userProvider.favoriteProducts.length,
              );
      }),
    );
  }
}
