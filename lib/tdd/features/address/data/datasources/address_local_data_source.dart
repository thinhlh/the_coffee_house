import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/shared_preferences/app_shared_preferences.dart';
import 'package:the/tdd/features/address/data/models/delivery_detail_model.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/features/address/domain/usecases/save_new_delivery_detail.dart';

abstract class AddressLocalDataSource {
  Future<List<DeliveryDetail>> getDeliveryDetailList();
  Future<void> saveNewDeliveryDetail(SaveNewDeliveryDetailParams params);
  Future<DeliveryDetailModel> getLatestDeliveryDetail();
  Future<String> getLatestTakeAwayLocation();
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  @override
  Future<List<DeliveryDetail>> getDeliveryDetailList() async {
    return AppSharedPreferences.getSavedDeliveryDetailList()
        .map((map) => DeliveryDetailModel.fromMap(map))
        .toList();
  }

  @override
  Future<void> saveNewDeliveryDetail(SaveNewDeliveryDetailParams params) {
    return AppSharedPreferences.saveNewDeliveryDetail(
      DeliveryDetailModel(
        recipientName: params.recipientName,
        recipientPhone: params.recipientPhone,
        address: params.address,
        note: params.note,
      ),
    );
  }

  @override
  Future<DeliveryDetailModel> getLatestDeliveryDetail() async {
    final result = AppSharedPreferences.getLatestDeliveryDetail();
    if (result == null) throw CacheNotFoundException();
    return DeliveryDetailModel.fromMap(result);
  }

  @override
  Future<String> getLatestTakeAwayLocation() async {
    final result = AppSharedPreferences.getTakeAwayLocation();
    if (result == null) throw CacheNotFoundException();
    return result;
  }
}
