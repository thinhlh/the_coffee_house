import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:the/tdd/features/user/presentation/widgets/user_info_card.dart';
import 'package:the/tdd/features/home/home_page.dart';
import 'package:the/tdd/features/others/presentation/pages/others_page.dart';
import 'package:the/tdd/features/products/presentation/pages/order_page.dart';
import 'package:the/tdd/features/promotion/presentation/pages/promotions_page.dart';
import 'package:the/tdd/features/stores/presentation/pages/stores_page.dart';

GlobalKey<TabScreenState> tabScreenState = GlobalKey<TabScreenState>();

class TabScreen extends StatefulWidget {
  static const routeName = '/tab_screen';

  const TabScreen({Key key}) : super(key: key);

  @override
  TabScreenState createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen> {
  Map<String, Widget> _pages = {
    HomePage.routeName: HomePage(),
    OrderPage.routeName: OrderPage(),
    StoresPage.routeName: StoresPage(),
    PromotionsPage.routeName: PromotionsPage(),
    OthersPage.routeName: OthersPage(),
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
        title: Image.asset(
          'assets/images/the-coffee-house-logo.jpg',
          fit: BoxFit.cover,
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
