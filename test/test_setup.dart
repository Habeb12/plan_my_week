import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupSqfliteForTests() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
