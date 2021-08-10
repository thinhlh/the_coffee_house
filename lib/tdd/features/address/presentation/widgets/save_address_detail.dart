import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/utils/const.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedAddressDetail extends StatelessWidget {
  final DeliveryDetail _deliveryDetail;
  SavedAddressDetail(this._deliveryDetail);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(_deliveryDetail),
      child: Dismissible(
        background: Container(
          padding: EdgeInsets.all(AppDimens.MEDIUM_PADDING),
          color: Colors.redAccent[200],
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
            ),
          ),
        ),
        direction: DismissDirection.endToStart,

        ///TODO on dimiss
        // onDismissed: (direction) => sharedPref.deleteDeliveryDetail(
        //   sharedPref.savedDeliveryDetail[index],
        // ),
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
            _deliveryDetail.address,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimens.SMALL_TEXT_SIZE,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _deliveryDetail.recipientName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                _deliveryDetail.recipientPhone,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimens.EXTRA_SMALL_TEXT_SIZE,
                ),
              ),
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
