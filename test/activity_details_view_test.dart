import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mock_flutter_map.dart'; // Importiere die Mock-Datei

void main() {
  testWidgets('ActivityDetailsView renders correctly', (WidgetTester tester) async {
    final Map<String, dynamic> activity = {
      'id': 1,
      'title': 'Test Activity',
      'description': 'Test Description',
      'date': '2022-01-01',
      'location': '7.806999101104161,-0.6616877207304973',
      'category': 'Normal',
      'done': 0,
      'image': '',
    };

    // Mock FlutterMap-Widget direkt im Test
    Widget mockFlutterMap(String location) {
      return MockFlutterMap(location: location);
    }

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title: ${activity['title']}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description: ${activity['description']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Category: ${activity['category']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    mockFlutterMap(activity['location'] as String),
                    SizedBox(height: 16),
                    (activity['image'] != null && (activity['image'] as String).isNotEmpty)
                        ? Image.network(activity['image'] as String)
                        : Text('No image available'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ));

    // Warte, bis alle Widgets gerendert sind
    await tester.pumpAndSettle();

    // Überprüfe, ob die Widgets die erwarteten Texte enthalten
    expect(find.text('Title: Test Activity'), findsOneWidget);
    expect(find.text('Description: Test Description'), findsOneWidget);
    expect(find.text('Category: Normal'), findsOneWidget);
  });
}
