import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../activity_controller/activity_controller.dart';
import 'add_edit_activity_view.dart';
import 'package:get/get.dart';
import 'dart:io';

class ActivityDetailsView extends StatefulWidget {
  final Map<String, dynamic> activity;

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
      return LatLng(0, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title: ${widget.activity['title']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Description: ${widget.activity['description']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Date: ${widget.activity['date']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  if (widget.activity['image'] != null)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(widget.activity['image'])),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: widget.activity['location'] != null &&
                              widget.activity['location'].isNotEmpty
                              ? FlutterMap(
                            options: MapOptions(
                              center: _parseLocation(widget.activity['location']),
                              zoom: 10,
                            ),
                            layers: [
                              TileLayerOptions(
                                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: ['a', 'b', 'c'],
                              ),
                              MarkerLayerOptions(
                                markers: [
                                  Marker(
                                    width: 30.0,
                                    height: 30.0,
                                    point: _parseLocation(widget.activity['location']),
                                    builder: (ctx) => Container(
                                      child: Icon(Icons.location_on, color: Colors.red),
                                    ),
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
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Category: ${widget.activity['category']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditActivityView(activity: widget.activity),
                            ),
                          ).then((value) {
                            Get.snackbar('PlanMyWeek', 'Activity edited',
                                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                snackPosition: SnackPosition.BOTTOM,
                                icon: Icon(Icons.info));
                          });
                        },
                        child: Text('Edit'),
                      ),
                      InkWell(
                        onTap: () async {
                          bool value = !(_isDone);
                          await _controller.handleMarkActivityAsDone(widget.activity['id'], value);
                          setState(() {
                            _isDone = value;
                          });
                          String message = value ? 'Activity marked as done' : 'Activity marked as not done';
                          Get.snackbar('PlanMyWeek', message,
                              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                              icon: Icon(Icons.info));
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 2,
                                color: _isDone ? Colors.green : Colors.blue),
                          ),
                          child: Icon(
                            _isDone ? Icons.check : Icons.check_box_outline_blank,
                            color: _isDone ? Colors.green : Colors.blue,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
