import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the/tdd/features/stores/data/models/store_model.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';

void main() {
  final storeModel = StoreModel(
    id: 'id',
    address: 'address',
    name: 'name',
    coordinate: LatLng(0, 0),
    imageUrl: 'imageUrl',
  );

  final Map<String, Object> map = {
    'id': 'id',
    'address': 'address',
    'name': 'name',
    'coordinate': LatLng(0, 0),
    'imageUrl': 'imageUrl',
  };

  test('should store model is a subclass of store', () async {
    expect(storeModel, isA<Store>());
  });

  test('should return valid store model from map', () async {
    // arrange

    // act
    final result = StoreModel.fromMap(map);
    //assert
    expect(result, storeModel);
  });

  test('should return valid map from model', () async {
    // arrange

    // act
    final result = storeModel.toMap();
    //assert
    expect(result, {...map}..remove('id'));
  });
}
