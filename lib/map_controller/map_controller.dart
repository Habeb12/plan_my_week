import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController {
  GoogleMapController? _controller;

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void updateLocation(LatLng position) {
    _controller?.animateCamera(CameraUpdate.newLatLng(position));
  }
}
