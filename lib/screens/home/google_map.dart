import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the/models/store.dart';
import 'package:the/providers/stores.dart';

class GoogleMapWidget extends StatefulWidget {
  static const routeName = '/google_map_screen';

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(10.768526189983133, 106.69884304016306),
    zoom: 13,
  );

  Future<void> _goToPosition(LatLng target) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: 17,
        ),
      ),
    );
  }

  List<Marker> _fromStores(List<Store> stores) {
    return stores
        .map<Marker>(
          (store) => Marker(
            infoWindow: InfoWindow(
              title: 'The coffee house ' + store.name,
              snippet: store.address,
            ),
            markerId: MarkerId(store.id),
            zIndex: 5,
            position: store.location,
            onTap: () async {
              _goToPosition(store.location);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Stores>(
      builder: (_, stores, child) => GoogleMap(
        compassEnabled: true,
        markers: _fromStores(stores.stores).toSet(),
        mapType: MapType.normal,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
