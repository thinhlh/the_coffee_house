import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Store {
  String id = '';
  String address = '';
  LatLng location = LatLng(10, 106);
  List<String> imageUrls = [];

  Store({
    @required this.id,
    @required this.address,
    @required this.location,
    @required this.imageUrls,
  });

  Store.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.address = json['address'];
    GeoPoint point = json['coordinate'];
    location = new LatLng(point.latitude, point.longitude);
    this.imageUrls = (json['imageUrls'] as List<dynamic>).cast<String>();
  }
}
