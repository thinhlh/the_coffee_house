import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:the_coffee_house/screens/admin_screens/admin_home_screen.dart';

import 'package:the_coffee_house/screens/home_screen.dart';
import 'package:the_coffee_house/screens/order_screen.dart';
import 'package:the_coffee_house/screens/others_screen.dart';

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
  //bool _isDelivery;

  void navigateToScreen(String routeName, {bool isDelivery = true}) {
    final screenIndex =
        _pages.keys.toList().indexWhere((element) => element == routeName);

    //_isDelivery = isDelivery;
    _pages[routeName] = OrderScreen();
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
      appBar: GeneralAppBar(context),
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
            icon: Icon(Icons.explore_rounded),
            label: 'Admin',
          ),
        ],
      ),
      body: _pages.values.toList()[_selectedPageIndex],
    );
  }
}

class GeneralAppBar extends AppBar {
  final BuildContext context;
  GeneralAppBar(this.context);

  @override
  Widget get title => Image.asset(
        'assets/images/the-coffee-house-logo.jpg',
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width * 10 / 7,
      );
  @override
  List<Widget> get actions => [
        TextButton(
          onPressed: () {},
          child: Icon(
            Icons.card_membership,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ];
  @override
  Color get backgroundColor => Colors.white;
}
