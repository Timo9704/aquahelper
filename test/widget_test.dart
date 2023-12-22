import 'package:aquahelper/widget/dashboard_health_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

void main() {
  sqfliteTestInit();

  testWidgets('Startscreen shows dashboard', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardHealthStatus()));
    expect(find.text("Health Status:"), findsOneWidget);
  });
}
