import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Store {
  String street = '';
  String district = '';
  String city = '';
  LatLng location = LatLng(10, 106);
  List<String> imageUrls = [];

  Store({
    @required this.street,
    @required this.district,
    @required this.city,
    @required this.location,
    @required this.imageUrls,
  });

  String get fullAddress =>
      this.street + ', ' + this.district + ', ' + this.city + ', Việt Nam';
}
