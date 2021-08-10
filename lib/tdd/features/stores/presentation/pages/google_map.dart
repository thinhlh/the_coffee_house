import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';
import 'package:the/tdd/features/stores/presentation/providers/stores_provider.dart';

class GoogleMapPage extends StatefulWidget {
  static const routeName = '/google_map_page';

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
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
            position: store.coordinate,
            onTap: () async {
              _goToPosition(store.coordinate);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<StoresProvider, List<Store>>(
      selector: (_, provider) => provider.stores,
      builder: (_, stores, child) => GoogleMap(
        compassEnabled: true,
        markers: _fromStores(stores).toSet(),
        mapType: MapType.normal,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
