import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';
import 'package:the/tdd/features/promotion/presentation/pages/promotions_tab_page.dart';
import 'package:the/tdd/features/promotion/presentation/providers/promotions_provider.dart';

class PromotionsPage extends StatelessWidget {
  static const routeName = '/promotions_page';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Selector<PromotionsProvider, List<Promotion>>(
        selector: (_, provider) => provider.promotions,
        builder: (_, promotions, __) => PromotionTabPage(),
      ),
    );
  }
}
