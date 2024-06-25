import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MockFlutterMap extends StatelessWidget {
  final String location;

  MockFlutterMap({required this.location});

  LatLng _parseLocation(String location) {
    try {
      final parts = location.split(',');
      if (parts.length != 2) {
        throw FormatException("Invalid location format");
      }
      final latitude = double.parse(parts[0]);
      final longitude = double.parse(parts[1]);
      return LatLng(latitude, longitude);
    } catch (e) {
      print('Failed to parse location: $e');
      return LatLng(0, 0); // Default location in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: _parseLocation(location),
          minZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', // Dummy URL
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 30.0,
                height: 30.0,
                point: _parseLocation(location),
                child: Icon(Icons.location_on, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
