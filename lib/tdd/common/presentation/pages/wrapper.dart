import 'package:flutter/material.dart';
import 'package:the/tdd/common/presentation/pages/tab_screen.dart';
import 'package:the/tdd/common/presentation/pages/waiting_page.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/auth/presentation/providers/auth_provider.dart';
import 'package:the/tdd/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:the/tdd/features/products/presentation/providers/products_provider.dart';
import 'package:the/tdd/features/promotion/presentation/providers/promotions_provider.dart';
import 'package:the/tdd/features/stores/presentation/providers/stores_provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) return TabScreen(key: tabScreenState);
        return WaitingPage();
      },
      future: Future.wait([
        context.read<AuthProvider>().fetchUser(),
        context.read<ProductsProvider>().fetchProducts(),
        context.read<NotificationsProvider>().fetchNotifications(),
        context.read<StoresProvider>().fetchStore(),
        context.read<PromotionsProvider>().fetchPromotions(),
      ]),
    );
  }
}
