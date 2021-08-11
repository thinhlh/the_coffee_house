import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:the/screens/admin/admin_categories_screen.dart';
import 'package:the/screens/admin/admin_dashboard.dart';
import 'package:the/screens/admin/admin_notifications_screen.dart';
import 'package:the/screens/admin/admin_orders_screen.dart';
import 'package:the/screens/admin/admin_products_screen.dart';
import 'package:the/screens/admin/admin_promotions_screen.dart';
import 'package:the/screens/admin/admin_stores_screen.dart';
import 'package:the/screens/admin/admin_users_screen.dart';

class AdminTabScreen extends StatefulWidget {
  @override
  _AdminTabScreenState createState() => _AdminTabScreenState();
}

class _AdminTabScreenState extends State<AdminTabScreen> {
  Map<String, Widget> _pages = {
    AdminDashboard.routeName: AdminDashboard(),
    AdminOrdersScreen.routeName: AdminOrdersScreen(),
    AdminNotificationsScreen.routeName: AdminNotificationsScreen(),
    AdminPromotionsScreen.routeName: AdminPromotionsScreen(),
    AdminUsersScreen.routeName: AdminUsersScreen(),
  };

  int _selectedPageIndex = 0;

  void _navigate(int index) {
    setState(() => _selectedPageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _navigate,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIcons.chrome_reader_mode_mdi),
            label: 'Promotions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
        ],
      ),
      body: _pages.values.toList()[_selectedPageIndex],
    );
  }
}
