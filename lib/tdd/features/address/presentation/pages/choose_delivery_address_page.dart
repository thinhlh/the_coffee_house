import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/common/presentation/widgets/base_divider.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/features/address/presentation/pages/add_new_delivery_detail_page.dart';
import 'package:the/tdd/features/address/presentation/providers/address_provider.dart';
import 'package:the/tdd/features/address/presentation/widgets/save_address_detail.dart';
import 'package:the/utils/values/dimens.dart';

class ChooseDeliveryAddressPage extends StatefulWidget {
  static const routeName = '/choose_delivery_address_page';

  @override
  _ChooseDeliveryAddressPageState createState() =>
      _ChooseDeliveryAddressPageState();
}

class _ChooseDeliveryAddressPageState extends State<ChooseDeliveryAddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn địa chỉ giao hàng'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () => showBarModalBottomSheet(
                context: context,
                builder: (_) => AddNewDeliveryDetailPage(),
              ).then((value) => setState(() {})),
              trailing: Icon(
                Icons.add,
                color: Colors.black,
              ),
              title: Text(
                'Thêm địa chỉ mới',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                ),
              ),
            ),
            Divider(
              color: Colors.black54,
            ),
            Padding(
              padding: EdgeInsets.all(AppDimens.LARGE_PADDING),
              child: Text(
                'Địa chỉ đã lưu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimens.MEDIUM_TEXT_SIZE,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: AppDimens.MEDIUM_TEXT_SIZE),
              child: BaseDivider(),
            ),
            Selector<AddressProvider, List<DeliveryDetail>>(
              selector: (_, provider) => provider.deliveryDetailList,
              builder: (_, deliveryDetails, __) => ListView.separated(
                separatorBuilder: (_, index) => Divider(
                  color: Colors.black87,
                ),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.MEDIUM_PADDING,
                ),
                itemBuilder: (_, index) =>
                    SavedAddressDetail(deliveryDetails[index]),
                itemCount: deliveryDetails.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
