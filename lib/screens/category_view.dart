import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../activity_controller/activity_controller.dart';
import 'add_edit_activity_view.dart';
import 'package:get/get.dart';

class CategoryView extends StatefulWidget {
  final String category;

  CategoryView({required this.category});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final ActivityController _controller = ActivityController();
  late List<Map<String, dynamic>> _activities = [];

  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    final activities = await _controller.getActivitiesByCategory(widget.category); // important
    setState(() {
      _activities = activities;
    });
  }



  Future<void> _refreshActivities() async {
    await _fetchActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Activities'),
      ),
      body: _activities.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No activities found for ${widget.category}!',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
      onRefresh: _refreshActivities,
      child: ListView.builder(
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                'Title: ${activity['title']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8),
                  Text(
                    'Description: ${activity['description']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: activity['location'] != null && activity['location'].isNotEmpty
                        ? FlutterMap(
                      options: MapOptions(
                        center: _parseLocation(activity['location']),
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
                              point: _parseLocation(activity['location']),
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
                  SizedBox(height: 8),
                  Text(
                    "Category: ${activity['category']}",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              trailing: InkWell(
                onTap: () async {
                  bool value = !(activity['done'] == 1);
                  await _controller.handleMarkActivityAsDone(activity['id'], value);
                  _refreshActivities();
                  String message = value ? 'Activity marked as done' : 'Activity marked as not done';
                  Get.snackbar('PlanMyWeek', message, margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10), icon: Icon(Icons.info));
                },
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: activity['done'] == 1 ? Colors.green : Colors.blue),
                  ),
                  child: Icon(
                    activity['done'] == 1 ? Icons.check : Icons.check_box_outline_blank,
                    color: activity['done'] == 1 ? Colors.green : Colors.blue,
                    size: 30,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditActivityView(activity: activity),
                  ),
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Activity edited')),
                  );
                });
              },
            ),
          );
        },
      ),
    ),
    );
  }

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
}
