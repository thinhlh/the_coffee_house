import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  static const routeName = '/google_map_screen';

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.768526189983133, 106.69884304016306),
    zoom: 13,
  );

  Future<void> _goToPosition({
    CameraPosition cameraPosition = const CameraPosition(
      target: LatLng(10.7, 106.7),
      zoom: 13,
    ),
  }) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      compassEnabled: true,
      markers: Set<Marker>.from([
        Marker(
          zIndex: 5,
          position: LatLng(10.771291878774353, 106.68106218194482),
          markerId: MarkerId('1'),
          onTap: () async => _goToPosition(
            cameraPosition: CameraPosition(
              target: LatLng(10.771291878774353, 106.68106218194482),
              zoom: 17,
            ),
          ),
        ),
        Marker(
          zIndex: 5,
          position: LatLng(10.77420964819986, 106.66849804016307),
          markerId: MarkerId('2'),
          onTap: () async => _goToPosition(
            cameraPosition: CameraPosition(
              target: LatLng(10.77420964819986, 106.66849804016307),
              zoom: 17,
            ),
          ),
        ),
      ]),
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
