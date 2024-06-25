import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
// import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart'; // Ensure this package is included

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LocationData? _currentLocation;
  Location _location = Location();
  LatLng? _selectedPosition; // Track the selected position

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      var location = await _location.getLocation();
      setState(() {
        _currentLocation = location;
      });
    } catch (e) {
      print('Failed to get location: $e');
    }
  }

  void _onTap(TapPosition tapPosition, LatLng position) {
    // Set the selected position when tapped
    setState(() {
      _selectedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body:
      FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation != null
              ? LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)
              : LatLng(51, 10), // Default center
          minZoom: 10, // Default zoom level
          onTap: _onTap, // Call _onTap when the map is tapped
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          if (_currentLocation != null)
            MarkerLayer(
              markers: [
                if (_selectedPosition != null)
                  Marker(
                    width: 30.0,
                    height: 30.0,
                    point: _selectedPosition!,
                    child: Icon(Icons.location_on, color: Colors.blue),
                  ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Return the selected position to the previous screen
          if (_selectedPosition != null) {
            Navigator.pop(context, _selectedPosition);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select a location')),
            );
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
