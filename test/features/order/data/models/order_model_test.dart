import 'package:flutter_test/flutter_test.dart';
import 'package:the/tdd/features/order/data/models/order_model.dart';
import 'package:the/tdd/features/order/domain/entities/order_method.dart';

void main() {
  final now = DateTime.now();

  final OrderModel orderModel = OrderModel(
    id: 'id',
    orderAddress: 'orderAddress',
    orderMethod: OrderMethod.Delivery,
    orderValue: 0,
    isDelivered: true,
    recipientId: 'recipientId',
    recipientName: 'recipientName',
    recipientPhone: 'recipientPhone',
    promotionId: 'promotionId',
    orderTime: now,
  );

  final Map<String, dynamic> mappedOrder = {
    'id': 'id',
    'orderAddress': 'orderAddress',
    'orderMethod': 'Delivery',
    'orderValue': 0,
    'delivered': true,
    'userId': 'recipientId',
    'recipientName': 'recipientName',
    'recipientPhone': 'recipientPhone',
    'promotionId': 'promotionId',
    'orderTime': now,
  };

  // test('should to map return valid map', () async {
  //   // arrange

  /// TODO have not test to map yet because it depends on FirebaseAuth.currentUser.uid
  //   // act
  //   final result = orderModel.toMap;

  //   //assert
  //   expect(result, {...mappedOrder}..remove('id'));
  // });

  test('should parsing from map to valid model', () async {
    // arrange

    // act
    final result = OrderModel.fromMap(mappedOrder);
    //assert
    expect(result, orderModel);
  });
}
