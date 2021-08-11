import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the/models/promotion.dart';
import 'package:the/providers/promotions.dart';
import 'package:the/utils/const.dart' as Constant;
import 'package:the/widgets/promotion_card.dart';

class SearchPromotionBottomSheet extends StatefulWidget {
  @override
  _SearchPromotionBottomSheetState createState() =>
      _SearchPromotionBottomSheetState();
}

class _SearchPromotionBottomSheetState
    extends State<SearchPromotionBottomSheet> {
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
        title: Text('Nhập mã khuyến mãi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
        child: Center(
          child: isPromotionFound
              ? PromotionCard(
                  promotion,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bạn có thể nhập mã khuyến mãi để tìm kiếm voucher',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Constant.SUB_HEADING,
                      ),
                    ),
                    SizedBox(height: 2 * Constant.SIZED_BOX_HEIGHT),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: Constant.GENERAL_PADDING / 2,
                        horizontal: Constant.GENERAL_PADDING,
                      ),
                      child: TextField(
                        controller: promotionController,
                        textInputAction: TextInputAction.done,
                        focusNode: promotionNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập mã khuyến mãi',
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Constant.SIZED_BOX_HEIGHT,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          promotion =
                              Provider.of<Promotions>(context, listen: false)
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
                          style: TextStyle(
                            fontSize: Constant.TEXT_SIZE,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Constant.PRIMARY_COLOR,
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
