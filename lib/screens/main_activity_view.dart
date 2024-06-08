import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:plan_my_week/screens/selected_date_view.dart';
import '../activity_controller/activity_controller.dart';
import 'activity_details.dart';
import 'add_edit_activity_view.dart';
import 'category_view.dart';
import 'package:get/get.dart';
import 'dart:io';

class MainActivityView extends StatefulWidget {
  @override
  _MainActivityViewState createState() => _MainActivityViewState();
}

class _MainActivityViewState extends State<MainActivityView> {
  final ActivityController _controller = ActivityController();
  late List<Map<String, dynamic>> _activities = [];
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _fetchActivities() async {
    final activities = await _controller.handleListActivities();
    if (!_isDisposed) {
      setState(() {
        _activities = activities;
      });
    }
  }

  Future<void> _refreshActivities() async {
    await _fetchActivities();
  }
  //
  void _navigateToCategory(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryView(category: category),
      ),
    );
  }

  void _navigateToDate(BuildContext context, String date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateView(date: date),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlanMyWeek'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 28),
            onPressed: _refreshActivities,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Select Category',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.today, 'Today', () {
              Navigator.pop(context);
              _navigateToDate(context, 'Today');
            }),
            Divider(),
            _buildDrawerItem(Icons.today, 'This Week', () {
              Navigator.pop(context);
              _navigateToDate(context, 'This Week');
            }),
            Divider(),
            _buildDrawerItem(Icons.today, 'This Month', () {
              Navigator.pop(context);
              _navigateToDate(context, 'This Month');
            }),
            Divider(),
            _buildDrawerItem(Icons.label_important, 'Important Activities', () {
              Navigator.pop(context);
              _navigateToCategory(context, 'Important');
            }),
            Divider(),
            _buildDrawerItem(Icons.check_circle, 'Normal Activities', () {
              Navigator.pop(context);
              _navigateToCategory(context, 'Normal');
            }),
            Divider(),
            _buildDrawerItem(Icons.circle_sharp, 'Optional Activities', () {
              Navigator.pop(context);
              _navigateToCategory(context, 'Optional');
            }),
          ],
        ),
      ),
      body: _activities.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No activities found!',
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
            return Dismissible(
              key: Key(activity['id'].toString()),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                _controller.handleDeleteButtonClick(activity['id']);
                setState(() {
                  _activities.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Activity deleted')),
                );
              },
              child: InkWell(
                onTap: () {
                  // Navigate to a new view showing the item details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityDetailsView(activity: activity),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8),
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
                          'Title: ${activity['title']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description: ${activity['description']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Date: ${activity['date']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        // Show the category
                        Text(
                          'Category: ${activity['category']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        // Add a button to navigate to the edit screen
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Button to navigate to the edit screen
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditActivityView(activity: activity),
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
                                bool value = !(activity['done'] == 1);
                                await _controller.handleMarkActivityAsDone(activity['id'], value);
                                _refreshActivities();
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
                                      color: activity['done'] == 1 ? Colors.green : Colors.blue),
                                ),
                                child: Icon(
                                  activity['done'] == 1 ? Icons.check : Icons.check_box_outline_blank,
                                  color: activity['done'] == 1 ? Colors.green : Colors.blue,
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

            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditActivityView(),
            ),
          ).then((value) {
            _refreshActivities();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      onTap: onTap,
    );
  }

}

