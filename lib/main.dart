import 'package:flutter/material.dart';
import 'screens/main_activity_view.dart';
import 'screens/add_edit_activity_view.dart';
import 'screens/map_view.dart';
import 'package:get/get.dart';


void main() {
  runApp(PlanMyWeekApp());
}

class PlanMyWeekApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PlanMyWeek',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainActivityView(),
      routes: {
        '/add': (context) => AddEditActivityView(),
        '/edit': (context) => AddEditActivityView(activity: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/map': (context) => MapView(),
      },
    );

  }
}
