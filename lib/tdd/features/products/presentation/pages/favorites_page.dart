import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/auth/presentation/providers/user_provider.dart';
import 'package:the/tdd/features/products/presentation/providers/products_provider.dart';
import 'package:the/tdd/features/products/presentation/widgets/product_card.dart';
import 'package:the/utils/values/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritePage extends StatelessWidget {
  static const routeName = '/favorite_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Món yêu thích'),
      ),
      body: Selector<UserProvider, List<String>>(
          selector: (_, userProvider) => userProvider.user.favoriteProducts,
          builder: (_, favoriteProducts, child) {
            return favoriteProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40.r,
                          child: Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 50.w,
                          ),
                          backgroundColor: Colors.grey.withAlpha(50),
                        ),
                        SizedBox(height: AppDimens.LARGE_SIZED_BOX_HEIGHT),
                        Text(
                          'Bạn chưa có món yêu thích',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return ProductCard(
                        context
                            .read<ProductsProvider>()
                            .getProductById(favoriteProducts[index]),
                      );
                    },
                    separatorBuilder: (_, index) => SizedBox(
                      height: AppDimens.SMALL_SIZED_BOX_HEIGHT,
                    ),
                    itemCount: favoriteProducts.length,
                  );
          }),
    );
  }
}
