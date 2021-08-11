import 'package:flutter/material.dart';

import 'accumulative_point_tab_screen.dart';
import 'promotion_tab_screen.dart';

// ignore: must_be_immutable
class RewardScreen extends StatefulWidget {
  static const routeName = '/reward_screen';
  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  int initialIndex = 0;
  void navigateToScreen(int index) {
    setState(() => initialIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                labelColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(
                    text: 'TÍCH ĐIỂM',
                  ),
                  Tab(
                    text: 'PHIẾU ƯU ĐÃI',
                  ),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AccumlativePointTabScreen(),
            PromotionTabScreen(),
          ],
        ),
      ),
    );
  }
}
