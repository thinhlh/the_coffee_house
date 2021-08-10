import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';

class StoreModel extends Store {
  StoreModel({
    @required String id,
    @required String address,
    @required String name,
    @required LatLng coordinate,
    @required String imageUrl,
  }) : super(
          id: id,
          name: name,
          address: address,
          coordinate: coordinate,
          imageUrl: imageUrl,
        );

  StoreModel.fromMap(Map<String, Object> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.address = map['address'];

    var point;
    if (map['coordinate'] is GeoPoint) {
      point = map['coordinate'] as GeoPoint;
    } else {
      point = map['coordinate'] as LatLng;
    }

    this.coordinate = LatLng(point.latitude, point.longitude);
    this.imageUrl = map['imageUrl'];
  }

  Map<String, Object> toMap() {
    return {
      'name': this.name,
      'address': this.address,
      'coordinate': this.coordinate,
      'imageUrl': this.imageUrl,
    };
  }
}
