import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Store {
  String id = '';
  String address = '';
  String name = '';
  LatLng location = LatLng(10, 106);
  String imageUrl = '';

  Store({
    @required this.id,
    @required this.address,
    @required this.name,
    @required this.location,
    @required this.imageUrl,
  });

  Store.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.address = json['address'];
    GeoPoint point = json['coordinate'];
    location = new LatLng(point.latitude, point.longitude);
    this.name = json['name'];
    this.imageUrl = json['imageUrl'];
  }

  Map<String, Object> toJson() {
    return {
      'name': this.name,
      'address': this.address,
      'coordinate': GeoPoint(
        this.location.latitude,
        this.location.longitude,
      ),
      'imageUrl': this.imageUrl,
    };
  }
}
