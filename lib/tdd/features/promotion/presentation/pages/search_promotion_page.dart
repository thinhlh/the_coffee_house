import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';
import 'package:the/tdd/features/promotion/presentation/providers/promotions_provider.dart';
import 'package:the/tdd/features/promotion/presentation/widgets/promotion_card.dart';
import 'package:the/utils/const.dart';
import 'package:the/utils/values/dimens.dart';

class SearchPromotionPage extends StatefulWidget {
  final bool isUsedForChoosingPromotion;
  SearchPromotionPage({this.isUsedForChoosingPromotion = false});

  @override
  _SearchPromotionPageState createState() => _SearchPromotionPageState();
}

class _SearchPromotionPageState extends State<SearchPromotionPage> {
  TextEditingController promotionController = TextEditingController();

  FocusNode promotionNode = FocusNode();

  bool isPromotionFound = false;
  Promotion promotion;

  @override
  Widget build(BuildContext context) {
    promotionNode.requestFocus();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          'Nhập mã khuyến mãi',
          style: TextStyle(
            fontSize: AppDimens.MEDIUM_TEXT_SIZE,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppDimens.LARGE_PADDING),
        child: Center(
          child: isPromotionFound
              ? PromotionCard(
                  promotion,
                  isUsedForChoosingPromotion: widget.isUsedForChoosingPromotion,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bạn có thể nhập mã khuyến mãi để tìm kiếm voucher',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimens.SMALL_TEXT_SIZE,
                      ),
                    ),
                    SizedBox(height: AppDimens.LARGE_SIZED_BOX_HEIGHT),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppDimens.BORDER_RADIUS),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimens.SMALL_PADDING,
                        horizontal: AppDimens.MEDIUM_PADDING,
                      ),
                      child: TextField(
                        controller: promotionController,
                        style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                        textInputAction: TextInputAction.done,
                        focusNode: promotionNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập mã khuyến mãi',
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimens.SIZED_BOX_HEIGHT),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          promotion = context
                              .read<PromotionsProvider>()
                              .getPromotionByCode(promotionController.text);
                          if (promotion == null)
                            showDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                actions: [
                                  CupertinoActionSheetAction(
                                    isDefaultAction: true,
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      'Okay',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  )
                                ],
                                title: Text('Unable to find Voucher'),
                                content: Text(
                                  'Cannot find any voucher related to this code',
                                ),
                              ),
                            );
                          else {
                            setState(() {
                              isPromotionFound = true;
                            });
                          }
                        },
                        child: Text(
                          'Áp dụng',
                          style: TextStyle(fontSize: AppDimens.SMALL_TEXT_SIZE),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
