import 'package:flutter/material.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/features/address/domain/usecases/get_delivery_detail_list.dart';
import 'package:the/tdd/features/address/domain/usecases/save_new_delivery_detail.dart';

class AddressProvider with ChangeNotifier {
  final GetDeliveryDetailList getDeliveryDetailList;
  final SaveNewDeliveryDetail saveNewDeliveryDetail;
  AddressProvider(this.getDeliveryDetailList, this.saveNewDeliveryDetail);

  List<DeliveryDetail> _deliveryDetailList = [];

  List<DeliveryDetail> get deliveryDetailList => [..._deliveryDetailList];

  void getDeliveryDetails() async {
    final result = await getDeliveryDetailList(NoParams());
    result.fold((l) => null, (list) {
      _deliveryDetailList = list;
      notifyListeners();
    });
  }

  Future<void> saveNewAddressDeliveryDetai({
    @required String name,
    @required String phone,
    @required String address,
    @required String note,
  }) async {
    final result = await saveNewDeliveryDetail(SaveNewDeliveryDetailParams(
      recipientName: name,
      recipientPhone: phone,
      address: address,
      note: note,
    ));
    if (result.isRight()) {
      getDeliveryDetails();
    }
  }
}
