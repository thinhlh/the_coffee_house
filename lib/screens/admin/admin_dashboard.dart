import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:the/screens/admin/admin_categories_screen.dart';
import 'package:the/screens/admin/admin_products_screen.dart';
import 'package:the/screens/admin/admin_stores_screen.dart';
import 'package:the/services/admin_dashboard_service.dart';
import 'package:the/services/auth_api.dart';
import 'package:the/services/user_api.dart';
import 'package:the/utils/base_date_formatter.dart';
import 'package:the/widgets/admin/admin_bar_chart.dart';
import 'package:the/widgets/admin/admin_line_chart.dart';
import 'package:the/widgets/navigative_action_card.dart';
import '/utils/const.dart' as Constant;

class AdminDashboard extends StatelessWidget {
  static const routeName = '/admin-dash-board';

  TextEditingController _fromDateController =
      TextEditingController(text: BaseDateFomatter.formatDate(DateTime.now()));
  TextEditingController _toDateController =
      TextEditingController(text: BaseDateFomatter.formatDate(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminDashboardProvider(),
      builder: (_, child) => Scaffold(
        appBar: AppBar(
          title: Text('Admin Dashboard'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Revenue',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(height: Constant.SIZED_BOX_HEIGHT),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'From Date',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            splashColor: Colors.transparent,
                            onPressed: () => showDatePicker(
                              helpText: 'Select From Date',
                              context: context,
                              initialDate: BaseDateFomatter.fromString(
                                  _fromDateController.text),
                              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                              lastDate: DateTime.now(),
                              fieldLabelText: 'From Date',
                            ).then(
                              (value) => _fromDateController.text =
                                  BaseDateFomatter.formatDate(value),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.BORDER_RADIUS,
                            ),
                          ),
                        ),
                        controller: _fromDateController,
                        readOnly: true,
                      ),
                    ),
                    SizedBox(width: Constant.SIZED_BOX_HEIGHT),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'To Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.BORDER_RADIUS,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => showDatePicker(
                              context: context,
                              helpText: 'Select To Date',
                              initialDate: BaseDateFomatter.fromString(
                                  _toDateController.text),
                              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                              lastDate: DateTime.now(),
                            ).then(
                              (value) => _toDateController.text =
                                  BaseDateFomatter.formatDate(value),
                            ),
                            splashColor: Colors.transparent,
                          ),
                        ),
                        controller: _toDateController,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Constant.SIZED_BOX_HEIGHT,
                ),
                Divider(),
                Consumer<AdminDashboardProvider>(
                  builder: (_, provider, child) => Column(
                    children: [
                      provider.waiting == null
                          ? Center(
                              child: FittedBox(
                                child: Text(
                                  'Choose Date Range To View Profit',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            )
                          : provider.waiting
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Constant.BORDER_RADIUS),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  2 * Constant.GENERAL_PADDING),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Total Profit',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.red.shade400,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Constant
                                                        .SIZED_BOX_HEIGHT,
                                                  ),
                                                  Text(
                                                    NumberFormat.currency(
                                                      locale: 'vi-VN',
                                                      decimalDigits: 0,
                                                    ).format(
                                                      provider.total,
                                                    ),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize:
                                                          Constant.TEXT_SIZE,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Constant.BORDER_RADIUS),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  2 * Constant.GENERAL_PADDING),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Total Orders',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .purple.shade600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Constant
                                                        .SIZED_BOX_HEIGHT,
                                                  ),
                                                  Text(
                                                    provider.numberOfOrders
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize:
                                                          Constant.TEXT_SIZE,
                                                      color: Colors.purple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Constant.SIZED_BOX_HEIGHT,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Constant.BORDER_RADIUS,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                2 * Constant.GENERAL_PADDING,
                                              ),
                                              child: Column(children: [
                                                Text(
                                                  'Delivered',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.amber.shade700,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      Constant.SIZED_BOX_HEIGHT,
                                                ),
                                                Text(
                                                  provider.deliveredOrders
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize:
                                                        Constant.TEXT_SIZE,
                                                    color:
                                                        Colors.amber.shade800,
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Constant.BORDER_RADIUS),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  2 * Constant.GENERAL_PADDING),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Pending',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.teal.shade800,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Constant
                                                        .SIZED_BOX_HEIGHT,
                                                  ),
                                                  Text(
                                                    (provider.numberOfOrders -
                                                            provider
                                                                .deliveredOrders)
                                                        .toString(),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize:
                                                          Constant.TEXT_SIZE,
                                                      color:
                                                          Colors.teal.shade800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //AdminLineChart(),
                                    //AdminPieChart(),
                                  ],
                                ),
                      SizedBox(
                        height: Constant.SIZED_BOX_HEIGHT,
                      ),
                      ElevatedButton(
                        onPressed: () async => provider.fetchProfit(
                          DateFormat('dd-MM-yyyy')
                              .parse(_fromDateController.text),
                          DateFormat('dd-MM-yyyy')
                              .parse(_toDateController.text),
                        ),
                        child: Text('View Revenue'),
                      ),
                    ],
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Constant.SIZED_BOX_HEIGHT),
          Row(
            children: [
              Expanded(
                child: NavigativeActionCard(
                  icon: Icons.coffee_rounded,
                  title: 'Products',
                  color: Colors.brown.shade400,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AdminProductsScreen.routeName),
                ),
              ),
              Expanded(
                child: NavigativeActionCard(
                  icon: Icons.category,
                  title: 'Categories',
                  color: Colors.green,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AdminCategoriesScreen.routeName),
                ),
              ),
            ],
          ),
          SizedBox(height: Constant.SIZED_BOX_HEIGHT),
          Row(
            children: [
              Expanded(
                child: NavigativeActionCard(
                  icon: Icons.store,
                  title: 'Stores',
                  color: Colors.blue,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AdminStoresScreen.routeName),
                ),
              ),
              Expanded(
                child: NavigativeActionCard(
                  icon: Icons.logout,
                  title: 'Log out',
                  color: Colors.black87,
                  onPressed: () => AuthAPI().signOut(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminDashboardProvider with ChangeNotifier {
  bool waiting;
  int total;
  int numberOfOrders;
  int deliveredOrders;
  List<int> dailyProfit;

  Future<void> fetchProfit(DateTime fromDate, DateTime toDate) async {
    waiting = true;
    notifyListeners();
    Map<String, Object> result =
        await AdminDashboardService().fetchProfit(fromDate, toDate);
    total = result['total'];
    numberOfOrders = result['numberOfOrders'];
    deliveredOrders = result['deliveredOrders'];
    waiting = false;
    notifyListeners();
  }
}
