import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/order_card_navigation_provider.dart';
import '../../utils/global_vars.dart';
import '../admin_screens/admin_home_screen.dart';
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
    AdminHomeScreen.routeName: AdminHomeScreen(),
  };
  int _selectedPageIndex = 0;

  void navigateToScreen(String routeName, bool isDelivery) {
    final screenIndex =
        _pages.keys.toList().indexWhere((element) => element == routeName);

    Provider.of<OrderCardNavigationProvider>(context, listen: false)
        .checkAndUpdateOption(isDelivery);

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
            onPressed: () => sharedPref.deleteAllViewedNotifications(),
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
            label: 'Cửa Hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chrome_reader_mode_outlined),
            label: 'Reward',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_rounded),
            label: 'Others',
          ),
          //Hide admin screen from normal user
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            label: 'Admin',
          ),
        ],
      ),
      body: _pages.values.toList()[_selectedPageIndex],
    );
    // },
    //);
  }
}
