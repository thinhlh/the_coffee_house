import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/common/presentation/pages/tab_screen.dart';
import 'package:the/tdd/common/presentation/pages/waiting_page.dart';
import 'package:the/tdd/common/presentation/pages/wrapper.dart';
import 'package:the/tdd/features/address/presentation/providers/address_provider.dart';
import 'package:the/tdd/features/auth/presentation/pages/sign_in_page.dart';
import 'package:the/tdd/features/auth/presentation/providers/auth_provider.dart';
import 'package:the/injection_container.dart';
import 'package:the/tdd/features/auth/presentation/providers/user_provider.dart';
import 'package:the/tdd/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:the/tdd/features/order/presentation/providers/cart_provider.dart';
import 'package:the/tdd/features/order/presentation/providers/order_provider.dart';
import 'package:the/tdd/features/products/presentation/providers/product_info_provider.dart';
import 'package:the/tdd/features/products/presentation/providers/products_provider.dart';
import 'package:the/tdd/features/promotion/presentation/providers/promotions_provider.dart';
import 'package:the/tdd/features/stores/presentation/providers/stores_provider.dart';
import 'package:the/utils/routes.dart';
import 'package:the/utils/const.dart';

class App extends StatelessWidget {
  final Widget materialApp = ScreenUtilInit(
    designSize: Size(360, 690),
    builder: () => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Coffee House',
      theme: ThemeData(
        primarySwatch: AppColors.PRIMARY_SWATCH as MaterialColor,
        primaryColor: AppColors.PRIMARY_COLOR,
        accentColor: AppColors.ACCENT_COLOR,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        dividerColor: Colors.grey.shade300,
      ),
      home: Consumer<User>(
        builder: (_, firebaseUser, __) => Selector<UserProvider, CustomUser>(
          builder: (context, user, __) {
            if (firebaseUser == null)
              return SignInPage();
            else {
              if (user == null) {
                return Wrapper();
              } // Not yet loaded or loaded failed
              else
                return TabScreen(key: tabScreenState);
            }
          },
          selector: (_, userProvider) => userProvider.user,
        ),
      ),
      routes: routes,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: FirebaseAuth.instance.currentUser,
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(sl(), sl(), sl(), sl()),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (_) => UserProvider(sl()),
          update: (_, authProvider, userProvider) =>
              userProvider..update(authProvider.user),
        ),
        ChangeNotifierProvider<ProductsProvider>(
          create: (_) => ProductsProvider(sl(), sl()),
        ),
        ChangeNotifierProvider<StoresProvider>(
          create: (_) => StoresProvider(sl()),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(sl()),
        ),
        ChangeNotifierProvider<NotificationsProvider>(
          create: (_) => NotificationsProvider(sl(), sl(), sl()),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(sl(), sl()),
        ),
        ChangeNotifierProvider<PromotionsProvider>(
          create: (_) => PromotionsProvider(sl()),
        ),
        ChangeNotifierProvider<AddressProvider>(
          create: (_) => AddressProvider(sl(), sl()),
        ),

        // Page provider
        ChangeNotifierProvider<ProductInfoProvider>(
          create: (_) => ProductInfoProvider(),
        ),
      ],
      child: materialApp,
    );
  }
}
