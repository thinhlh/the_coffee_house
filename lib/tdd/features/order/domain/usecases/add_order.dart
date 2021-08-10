import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/order/domain/entities/cart_item.dart';
import 'package:the/tdd/features/order/domain/entities/order_method.dart';
import 'package:the/tdd/features/order/domain/repositories/order_repository.dart';

class AddOrder extends BaseUseCase<void, AddOrderParams> {
  OrderRepository _repository;
  AddOrder(this._repository);

  @override
  Future<Either<Failure, void>> call(AddOrderParams params) =>
      _repository.addOrder(params);
}

class AddOrderParams extends Equatable {
  final String orderAddress;
  final OrderMethod orderMethod;
  final String promotionId;
  final String recipientName;
  final String recipientPhone;
  final List<CartItem> cartItems;
  final int orderValue;

  AddOrderParams({
    @required this.orderAddress,
    @required this.orderMethod,
    @required this.cartItems,
    @required this.recipientName,
    @required this.orderValue,
    @required this.promotionId,
    this.recipientPhone,
  });

  @override
  List<Object> get props => [
        this.orderAddress,
        this.orderMethod,
        this.recipientName,
        this.recipientPhone,
        this.cartItems,
      ];
}
