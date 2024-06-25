import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_week/activity_controller/activity_controller.dart';
import 'test_setup.dart'; // Importiere die Setup-Datei

void main() {
  setupSqfliteForTests(); // Initialisiere die databaseFactory

  group('ActivityController', () {
    late ActivityController controller;

    setUp(() {
      controller = ActivityController();
    });

    test('handleAddButtonClick adds activity to database', () async {
      final initialActivities = await controller.handleListActivities();
      await controller.handleAddButtonClick(
        'Test Activity',
        'Test Description',
        DateTime.now(),
        '7.806999101104161,-0.6616877207304973',
        'Normal',
        '', // No image
      );
      final activitiesAfterCreate = await controller.handleListActivities();

      expect(initialActivities.length + 1, activitiesAfterCreate.length);
    });

    test('handleEditButtonClick updates activity in database', () async {
      final newDescription = 'Updated Description';
      final initialActivities = await controller.handleListActivities();
      final activityToUpdate = initialActivities.first;
      await controller.handleEditButtonClick(
        activityToUpdate['id'],
        activityToUpdate['title'],
        newDescription,
        DateTime.now(),
        activityToUpdate['location'],
        activityToUpdate['category'],
        activityToUpdate['done'] == 1, // Convert 1 to true, 0 to false
        activityToUpdate['image'],
      );
      final activitiesAfterEdit = await controller.handleListActivities();

      expect(
        activitiesAfterEdit.firstWhere((activity) => activity['id'] == activityToUpdate['id'])['description'],
        newDescription,
      );
    });

    // Weitere Tests für andere Methoden hinzufügen
  });
}
