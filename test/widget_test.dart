// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:aquahelper/main.dart';
import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

Future main() async {
  sqfliteTestInit();
  await DBHelper.db.initDB();

  testWidgets('Startscreen is empty and shows adding statement', (tester) async {

    await tester.pumpWidget(const AquaHelper());

    final titleFinder = find.text('Lege dein erstes Aquarium an!');

    expect(titleFinder, findsOneWidget);
  });

  testWidgets('Insert aquarium', (tester) async {

    print('M;mm');

    await tester.pumpWidget(const AquaHelperStartPage());

    final titleFinder = find.text('Alpen 60P');

    expect(titleFinder, findsOneWidget);
  });
}
