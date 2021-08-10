import 'package:flutter/material.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/features/address/domain/usecases/get_latest_delivery_detail.dart';
import 'package:the/tdd/features/address/domain/usecases/get_latest_take_away_location.dart';
import 'package:the/tdd/features/order/domain/entities/cart_item.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';

class CartProvider with ChangeNotifier {
  final GetLatestDeliveryDetail _getLatestDeliveryDetail;
  final GetLatestTakeAwayLocation _getLatestTakeAwayLocation;

  CartProvider(this._getLatestDeliveryDetail, this._getLatestTakeAwayLocation);

  //Properties

  List<CartItem> _cartItems = [];
  Promotion _promotion;
  bool _isPreferDelivered = false;
  DeliveryDetail _choosenDeliveryDetail;
  String _choosenTakeAwayStoreId;

  /// Getter & Setter

  List<CartItem> get cartItems => _cartItems;

  Promotion get promotion => _promotion;
  set promotion(Promotion _promotion) {
    this._promotion = _promotion;
    notifyListeners();
  }

  DeliveryDetail get choosenDeliveryDetail => _choosenDeliveryDetail;
  set choosenDeliveryDetail(DeliveryDetail deliveryDetail) {
    _choosenDeliveryDetail = deliveryDetail;
    notifyListeners();
  }

  String get choosenTakeAwayStoreId => _choosenTakeAwayStoreId;
  set choosenTakeAwayStoreId(String storeId) {
    _choosenTakeAwayStoreId = storeId;
    notifyListeners();
  }

  bool get isPreferDelivered => _isPreferDelivered;
  set isPreferDelivered(bool isPreferDelivred) {
    _isPreferDelivered = isPreferDelivred;
    notifyListeners();
  }

  ///Functions

  Future<void> getLatestOrderAddress() async {
    final deliveryDetailResult = await _getLatestDeliveryDetail(NoParams());
    final takeAwayResult = await _getLatestTakeAwayLocation(NoParams());

    deliveryDetailResult.fold((l) => null,
        (deliveryDetail) => _choosenDeliveryDetail = deliveryDetail);
    takeAwayResult.fold(
        (l) => null, (storeId) => _choosenTakeAwayStoreId = storeId);

    notifyListeners();
  }

  void addItemToCart(CartItem cartItem) {
    int index = cartItems.indexOf(cartItem);

    if (index >= 0) {
      cartItems[index].quantity += cartItem.quantity;
    } else {
      _cartItems.add(cartItem);
    }

    notifyListeners();
  }

  void deleteCartItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _promotion = null;
    notifyListeners();
  }

  /// Get additional values
  bool get isEmpty => _cartItems.isEmpty;

  int get numberOfItems => cartItems.fold(
      0, (previousValue, element) => previousValue += element.quantity);

  int get totalOrderValue {
    if (_promotion == null) {
      return totalCartValue;
    } else {
      if (_promotionValue <= 100) {
        return (totalCartValue * (1 - _promotionValue / 100)).toInt();
      } else
        return totalCartValue - _promotionValue;
    }
  }

  int get _promotionValue {
    String promotionValue = _promotion.value;
    if (promotionValue.contains('%')) {
      return int.parse(promotionValue.substring(0, promotionValue.length - 1));
    } else {
      return int.parse(promotionValue);
    }
  }

  int get totalCartValue => cartItems.fold(
      0,
      (previousValue, cartItem) =>
          previousValue + cartItem.quantity * cartItem.unitPrice);
}
