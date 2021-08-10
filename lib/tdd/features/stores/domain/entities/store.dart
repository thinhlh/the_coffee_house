import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Store extends Equatable {
  String id;
  String address;
  String name;
  LatLng coordinate;
  String imageUrl;

  Store({
    @required this.id,
    @required this.address,
    @required this.coordinate,
    @required this.name,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [this.id];
}
