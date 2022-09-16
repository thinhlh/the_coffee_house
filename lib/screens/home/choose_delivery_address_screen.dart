import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:the/screens/home/add_new_delivery_address.dart';
import 'package:the/utils/global_vars.dart';
import 'package:the/utils/const.dart' as Constant;
import 'package:the/widgets/base_divider.dart';

class ChooseDeliveryAddress extends StatefulWidget {
  @override
  _ChooseDeliveryAddressState createState() => _ChooseDeliveryAddressState();
}

class _ChooseDeliveryAddressState extends State<ChooseDeliveryAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn địa chỉ giao hàng'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () => showBarModalBottomSheet(
              context: context,
              builder: (_) => AddNewDeliveryAddress(),
            ).then((value) => setState(() {})),
            trailing: Icon(
              Icons.add,
              color: Colors.black,
            ),
            title: Text(
              'Thêm địa chỉ mới',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Constant.TEXT_SIZE,
              ),
            ),
          ),
          Divider(
            color: Colors.black54,
          ),
          Padding(
            padding: const EdgeInsets.all(2 * Constant.GENERAL_PADDING),
            child: Text(
              'Địa chỉ đã lưu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Constant.TEXT_SIZE,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2 * Constant.GENERAL_PADDING),
            child: BaseDivider(),
          ),
          ListView.separated(
            separatorBuilder: (_, index) => Divider(
              color: Colors.black87,
            ),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: Constant.GENERAL_PADDING,
            ),
            itemBuilder: (_, index) => GestureDetector(
              onTap: () => Navigator.of(context).pop(
                sharedPref.savedDeliveryDetail[index],
              ),
              child: Dismissible(
                background: Container(
                  padding: const EdgeInsets.all(Constant.GENERAL_PADDING),
                  color: Colors.redAccent[200],
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete,
                    ),
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => sharedPref.deleteDeliveryDetail(
                  sharedPref.savedDeliveryDetail[index],
                ),
                confirmDismiss: (direction) => showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: Text('Delete this address?'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('Cancel'),
                        isDefaultAction: false,
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      CupertinoDialogAction(
                        child: Text('Continue'),
                        isDefaultAction: true,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                ).then((value) => value),
                //delete delivery address
                key: Key('Delivery Address'),
                child: ListTile(
                  title: Text(
                    sharedPref.savedDeliveryDetail[index].address,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Constant.SUB_HEADING,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sharedPref.savedDeliveryDetail[index].recipientName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        sharedPref.savedDeliveryDetail[index].recipientPhone,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              ),
            ),
            itemCount: sharedPref.savedDeliveryDetail.length,
          ),
        ],
      ),
    );
  }
}
