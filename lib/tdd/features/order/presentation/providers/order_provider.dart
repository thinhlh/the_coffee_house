import 'package:the/tdd/core/base/base_provider.dart';
import 'package:the/tdd/features/order/domain/usecases/add_order.dart';

class OrderProvider extends BaseProvider {
  final AddOrder _addOrder;

  OrderProvider(this._addOrder);

  Future<void> addOrder(AddOrderParams params) async {
    showLoading();
    await _addOrder(params);
    dispatchLoading();
  }
}
