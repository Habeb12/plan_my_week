import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_week/screens/activity_details.dart';

void main() {
  testWidgets('ActivityDetailsView renders correctly', (WidgetTester tester) async {
    final activity = {
      'id': 1,
      'title': 'Test Activity',
      'description': 'Test Description',
      'date': '2022-01-01',
      'location': '7.806999101104161,-0.6616877207304973',
      'category': 'Normal',
      'done': 0,
      'image': '',
    };

    await tester.pumpWidget(MaterialApp(
      home: ActivityDetailsView(activity: activity),
    ));

    expect(find.text('Test Activity'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('2022-01-01'), findsOneWidget);
    expect(find.text('34.0522,-118.2437'), findsOneWidget);
    expect(find.text('Normal'), findsOneWidget);
  });
}
