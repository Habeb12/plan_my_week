import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../activity_controller/activity_controller.dart';
import 'add_edit_activity_view.dart';
import 'package:get/get.dart';
import 'dart:io';

class ActivityDetailsView extends StatefulWidget {
   Map<String, dynamic> activity;

  ActivityDetailsView({required this.activity});

  @override
  _ActivityDetailsViewState createState() => _ActivityDetailsViewState();
}

class _ActivityDetailsViewState extends State<ActivityDetailsView> {
  bool _isDone = false;
  final ActivityController _controller = ActivityController();

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
  void initState() {
    super.initState();
    _isDone = widget.activity['done'] == 1;
    print('Initial _isDone: $_isDone');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditActivityView(activity: widget.activity),
                ),
              ).then((value) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Activity edited')),
                );
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool confirmed = await _showDeleteConfirmationDialog(context);
              if (confirmed) {
                await _controller.handleDeleteButtonClick(widget.activity['id']);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title: ${widget.activity['title']}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Description: ${widget.activity['description']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'Category: ${widget.activity['category']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: widget.activity['location'] != null && widget.activity['location'].isNotEmpty
                    ? FlutterMap(
                  options: MapOptions(
                    initialCenter: _parseLocation(widget.activity['location']),
                    minZoom: 13,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 30.0,
                          height: 30.0,
                          point: _parseLocation(widget.activity['location']),
                          child: Icon(Icons.location_on, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                )
                    : Container(
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(child: Text('No location data')),
                ),
              ),
              SizedBox(height: 16),
              widget.activity['image'] != null && widget.activity['image'].isNotEmpty
                  ? Image.file(File(widget.activity['image']))
                  : Text('No image available'),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Done: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Checkbox(
                    value: _isDone,
                    onChanged: (bool? value) async {
                      if (value != null) {
                        print('Checkbox changed: $value');
                        await _controller.handleMarkActivityAsDone(widget.activity['id'], value);
                        setState(() {
                          _isDone = value;
                          // Create a new map with updated 'done' value
                          widget.activity = Map<String, dynamic>.from(widget.activity);
                          widget.activity['done'] = value ? 1 : 0;
                        });


                        print('Updated _isDone: $_isDone');
                        String message = value ? 'Activity marked as done' : 'Activity marked as not done';
                        Get.snackbar('PlanMyWeek', message, margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10), icon: Icon(Icons.info));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Activity'),
          content: Text('Are you sure you want to delete this activity?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
