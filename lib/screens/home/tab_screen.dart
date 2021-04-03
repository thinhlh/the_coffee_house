import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'package:the_coffee_house/providers/order_card_navigation_provider.dart';
import 'package:the_coffee_house/providers/user_provider.dart';

import 'package:the_coffee_house/screens/home/home_screen.dart';
import 'package:the_coffee_house/screens/home/order_screen.dart';
import 'package:the_coffee_house/screens/home/others_screen.dart';
import 'package:the_coffee_house/screens/admin_screens/admin_home_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key key}) : super(key: key);

  @override
  TabScreenState createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen> {
  Map<String, Widget> _pages = {
    HomeScreen.routeName: HomeScreen(),
    OrderScreen.routeName: OrderScreen(),
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
        titleSpacing: 0,
        title: Image.asset(
          'assets/images/the-coffee-house-logo.jpg',
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 1.6,
        ),
        actions: [
          TextButton(
            onPressed: () => print(
                Provider.of<UserProvider>(context, listen: false)
                    .favoriteProducts),
            child: Icon(
              Icons.card_membership,
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIcons.cup_sli),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_rounded),
            label: 'Others',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
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
