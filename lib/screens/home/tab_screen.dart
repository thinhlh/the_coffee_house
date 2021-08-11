import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:the/providers/cart.dart';
import 'package:the/providers/categories.dart';
import 'package:the/providers/notifications.dart';
import 'package:the/providers/user_orders.dart';
import 'package:the/providers/products.dart';
import 'package:the/providers/promotions.dart';
import 'package:the/providers/stores.dart';

import 'package:the/screens/home/others_screen.dart';
import 'package:the/services/categories_api.dart';
import 'package:the/services/notifications_api.dart';
import 'package:the/services/user_orders_api.dart';
import 'package:the/services/products_api.dart';
import 'package:the/services/promotions_api.dart';
import 'package:the/services/stores_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the/widgets/user_info_card.dart';

import '../../utils/global_vars.dart';
import 'home_screen.dart';
import 'order_screen.dart';
import 'others_screen.dart';
import 'reward_screen.dart';
import 'stores_screen.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/tab_screen';

  const TabScreen({Key key}) : super(key: key);

  @override
  TabScreenState createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen> {
  Map<String, Widget> _pages = {
    HomeScreen.routeName: HomeScreen(),
    OrderScreen.routeName: OrderScreen(),
    StoresScreen.routeName: StoresScreen(),
    RewardScreen.routeName: RewardScreen(),
    OthersScreen.routeName: OthersScreen(),
  };
  int _selectedPageIndex = 0;

  void navigateToScreen(String routeName) {
    final screenIndex =
        _pages.keys.toList().indexWhere((element) => element == routeName);

    setState(() {
      _selectedPageIndex = screenIndex;
    });
  }

  void _navigate(int index) {
    setState(() => _selectedPageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Image.asset('assets/images/the-coffee-house-logo.jpg',
            fit: BoxFit.cover, width: 1.6.sw),
        actions: [
          TextButton(
            onPressed: () async {
              // sharedPref.deleteDeliveryAndTakeAwayLocation();
              // sharedPref.deleteAllViewedNotifications();
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: UserInfoCard(),
                ),
              );
            },
            child: Icon(
              FlutterIcons.credit_card_alt_faw,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _navigate,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIcons.cup_sli),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chrome_reader_mode_outlined),
            label: 'Reward',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_rounded),
            label: 'Others',
          ),
        ],
      ),
      body: _pages.values.toList()[_selectedPageIndex],
    );
  }
}
