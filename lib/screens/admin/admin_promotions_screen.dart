import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/helpers/search_promotion.dart';
import 'package:the/models/promotion.dart';
import 'package:the/providers/notifications.dart';
import 'package:the/providers/promotions.dart';
import 'package:the/screens/admin/product_edit_screen.dart';
import 'package:the/screens/admin/promotion_edit_screen.dart';
import 'package:the/services/notifications_api.dart';
import 'package:the/services/promotions_api.dart';
import '/utils/const.dart' as Constant;

class AdminPromotionsScreen extends StatelessWidget {
  static const routeName = '/admin-promotions-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promotions Management'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => showSearch(
            context: context,
            delegate: SearchPromotion(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PromotionEditScreen(null),
              ),
            ),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<Promotions>(
          builder: (_, promotionsProvider, child) => ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                itemBuilder: (_, index) =>
                    AdminPromotionCard(promotionsProvider.promotions[index]),
                itemCount: promotionsProvider.promotions.length,
              )),
    );
  }
}

class AdminPromotionCard extends StatelessWidget {
  final Promotion promotion;
  AdminPromotionCard(this.promotion);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      background: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.shade200,
          borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            child: Icon(
              Icons.delete,
              size: 30,
            ),
            margin: const EdgeInsets.only(right: 20),
          ),
        ),
      ),
      confirmDismiss: (direction) => showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('Delete this promotion?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              isDefaultAction: false,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              child: Text('Proceed'),
              isDefaultAction: true,
              onPressed: () => PromotionsAPI()
                  .delete(promotion.id)
                  .then((value) => Navigator.of(context).pop(true)),
            ),
          ],
        ),
      ).then((value) => value),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => PromotionEditScreen(
              promotion.id,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: Constant.GENERAL_PADDING / 2,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
            ),
            elevation: Constant.ELEVATION,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Constant.GENERAL_PADDING / 3,
                        horizontal: Constant.GENERAL_PADDING / 2,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          promotion.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, exception, stackTrace) => Center(
                            child: Text(
                              'Unable to load image',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          isThreeLine: true,
                          title: Text(
                            promotion.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Constant.TEXT_SIZE,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  promotion.formattedExpityDate,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                promotion.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
