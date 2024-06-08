import '../activity_manager/activity_manager.dart';

class ActivityController {
  final ActivityManager _activityManager = ActivityManager();

  Future<void> handleAddButtonClick(String title, String description, DateTime date, String location, String category, String? imagePath) async {
    await _activityManager.createActivity(title, description, date, location, category, imagePath);
  }

  Future<void> handleEditButtonClick(int id, String title, String description, DateTime date, String location, String category, bool done, String? imagePath) async {
    await _activityManager.editActivity(id, title, description, date, location, category, done ? 1 : 0, imagePath); // Convert bool to int
  }

  Future<void> handleDeleteButtonClick(int id) async {
    await _activityManager.removeActivity(id);
  }

  Future<List<Map<String, dynamic>>> handleListActivities() async {
    return await _activityManager.listActivities();
  }

  Future<void> handleMarkActivityAsDone(int id, bool isDone) async {
    await _activityManager.markActivityAsDone(id, isDone);
  }

  Future<List<Map<String, dynamic>>> getActivitiesByCategory(String category) async {
    return await _activityManager.listActivitiesByCategory(category);
  }

  Future<List<Map<String, dynamic>>> getActivitiesByDate(String date) async {
    return await _activityManager.listActivitiesByDate(date);
  }
}
