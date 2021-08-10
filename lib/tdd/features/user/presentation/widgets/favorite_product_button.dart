import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/auth/presentation/providers/auth_provider.dart';
import 'package:the/tdd/features/auth/presentation/providers/user_provider.dart';
import 'package:the/tdd/features/user/domain/usecases/toggle_favorite_product.dart';
import 'package:the/utils/values/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteProductButton extends StatelessWidget {
  final String productId;
  FavoriteProductButton(this.productId);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final favoriteProducts =
            context.read<UserProvider>().user.favoriteProducts;
        if (favoriteProducts.contains(productId))
          favoriteProducts.remove(productId);
        else
          favoriteProducts.add(productId);

        context.read<UserProvider>().toggleFavoriteProduct(
              ToggleFavoriteProductParams(favoriteProducts),
            );
      },
      child: context.select<UserProvider, bool>(
              (provider) => provider.user.isProductFavorited(productId))
          ? Icon(
              Icons.favorite_rounded,
              color: AppColors.PRIMARY_COLOR,
              size: 24.w,
            )
          : Icon(
              Icons.favorite_border_rounded,
              color: Colors.black,
              size: 24.w,
            ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
    );
  }
}
