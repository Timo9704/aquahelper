import 'package:aquahelper/main.dart';
import 'package:aquahelper/util/dbhelper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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

    await tester.pumpWidget(const AquaHelperStartPage());

    final titleFinder = find.text('Alpen 60P');

    expect(titleFinder, findsOneWidget);
  });
}
