import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../db_manager/db_manager.dart';

class ActivityManager {
  final DatabaseManager _dbManager = DatabaseManager();

  Future<void> createActivity(String title, String description, DateTime date, String location, String category, String? imagePath) async {
    Map<String, dynamic> activity = {
      'title': title,
      'description': description,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'location': location,
      'category': category,
      'done': 0, // Default to not done
      'image': imagePath
    };
    await _dbManager.addActivity(activity);
  }

  Future<void> editActivity(int id, String title, String description, DateTime date, String location, String category, int done, String? imagePath) async {
    Map<String, dynamic> activity = {
      'title': title,
      'description': description,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'location': location,
      'category': category,
      'done': done,
      'image': imagePath
    };
    await _dbManager.updateActivity(id, activity);
  }

  Future<void> removeActivity(int id) async {
    await _dbManager.deleteActivity(id);
  }

  Future<List<Map<String, dynamic>>> listActivities() async {
    return await _dbManager.getAllActivities();
  }


  Future<void> markActivityAsDone(int id, bool isDone) async {
    final db = await _dbManager.database;
    await db.update(
      'activities',
      {'done': isDone ? 1 : 0}, // Convert boolean to integer (1 for true, 0 for false)
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> listActivitiesByCategory(String category) async {
    final db = await _dbManager.database;
    List<Map<String, dynamic>> result = await db.query(
      'activities',
      where: 'category = ?',
      whereArgs: [category],
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> listActivitiesByDate(String date) async {
    late DateTime startDate;
    late DateTime endDate;

    // Calculate start date and end date based on the provided date parameter
    if (date == 'Today') {
      final DateTime now = DateTime.now();
      startDate = DateTime(now.year, now.month, now.day); // Start of the current day
      endDate = DateTime(now.year, now.month, now.day + 1); // Start of the next day
    } else if (date == 'This Week') {
      final DateTime now = DateTime.now();
      final DateTime startOfWeek = DateTime(now.year, now.month, now.day - now.weekday);
      startDate = startOfWeek;
      endDate = DateTime(now.year, now.month, now.day + (7 - now.weekday)); // End of the current week
    } else if (date == 'This Month') {
      final DateTime now = DateTime.now();
      final DateTime startOfMonth = DateTime(now.year, now.month, 1);
      startDate = startOfMonth;
      endDate = DateTime(now.year, now.month + 1, 1); // Start of the next month
    } else {
      throw ArgumentError('Invalid date parameter');
    }

    // Format dates to match database format
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedStartDate = formatter.format(startDate);
    final String formattedEndDate = formatter.format(endDate);

    // Execute database query to fetch activities within the specified date range
    final db = await _dbManager.database;
    List<Map<String, dynamic>> result = await db.query(
      'activities',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [formattedStartDate, formattedEndDate],
    );

    return result;
  }

}
