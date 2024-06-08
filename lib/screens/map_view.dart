import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

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

  void _onTap(LatLng position) {
    // Set the selected position when tapped
    print('Tapped position: $position'); // Add this line to check if onTap is called
    setState(() {
      _selectedPosition = position;
    });
    print('Selected position: $_selectedPosition'); // Add this line to check the selected position
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _currentLocation != null
              ? LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)
              : LatLng(0, 0), // Default center
          zoom: 10, // Default zoom level
          onTap: _onTap, // Call _onTap when the map is tapped
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          if (_currentLocation != null)
            MarkerLayerOptions(
              markers: [
                if (_selectedPosition != null)
                  Marker(
                    width: 30.0,
                    height: 30.0,
                    point: _selectedPosition!,
                    builder: (ctx) => Container(
                      child: Icon(Icons.location_on, color: Colors.blue),
                    ),
                  ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Return the selected position to the previous screen
          if (_selectedPosition != null) {
            Navigator.pop(context, _selectedPosition); // Corrected line
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
