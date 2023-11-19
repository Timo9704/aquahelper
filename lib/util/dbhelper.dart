import 'package:aquahelper/model/measurement.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/aquarium.dart';

class DBHelper {
  static final DBHelper db = DBHelper._();
  DBHelper._();

  initDB() async {
    String path = join(await getDatabasesPath(), 'aquarium_database.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE tank(aquariumId INTEGER PRIMARY KEY, name TEXT, liter INTEGER, waterType INTEGER, imageUrl TEXT)');
          await db.execute('CREATE TABLE measurement(measurementId INTEGER PRIMARY KEY, aquariumId INTEGER, temp FLOAT, ph FLOAT, gh FLOAT, kh FLOAT, no2 FLOAT, no3 FLOAT, po4 FLOAT, k FLOAT, mg FLOAT, FOREIGN KEY(aquariumId) REFERENCES tank(aquariumId))');
        });
  }

  Future<List<Aquarium>> getAquariums() async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("tank");
    List<Aquarium> list = res.isNotEmpty ? res.map((c) => Aquarium.fromMap(c)).toList() : [];
    return list;
  }

  // Define a function that inserts dogs into the database
  Future<void> insertAquarium(Aquarium aquarium) async {
    final db = await openDatabase('aquarium_database.db');

    await db.insert(
      'tank',
      aquarium.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateAquarium(Aquarium aquarium) async {
    final db = await openDatabase('aquarium_database.db');
    await db.update("tank",
        aquarium.toMap(),
        where: 'aquariumId = ?',
        whereArgs: [aquarium.aquariumId],
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  Future<void> deleteAquarium(aquariumId) async {
    final db = await openDatabase('aquarium_database.db');
    await db.delete("tank",
        where: "aquariumId = ?",
        whereArgs: [aquariumId]);
  }

  // Define a function that inserts dogs into the database
  Future<void> insertMeasurement(Measurement measurement) async {
    final db = await openDatabase('aquarium_database.db');
    await db.insert(
      'measurement',
      measurement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Aquarium>> getMeasurmentValues(Aquarium aquarium) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("measurement", where: 'aquariumId = ?', whereArgs: [aquarium.aquariumId]);
    List<Aquarium> list = res.isNotEmpty ? res.map((c) => Aquarium.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Measurement>> getMeasurmentsList(Aquarium aquarium) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("measurement", where: 'aquariumId = ?', whereArgs: [aquarium.aquariumId]);
    List<Measurement> list = res.isNotEmpty ? res.map((c) => Measurement.fromMap(c)).toList() : [];
    return list;
  }

  // Define a function that inserts dogs into the database
  Future<void> insertAquarien() async {
    final db = await openDatabase('aquarium_database.db');

    Map<String, dynamic> aquariumMap = {
      "aquariumId": 1,
      "name": "Alpen 60P",
      "liter": 80,
      "waterType": 0,
      "imageUrl": "assets/images/aquarium.jpg"
    };
    Map<String, dynamic> aquariumMap1 = {
      "aquariumId": 2,
      "name": "Dragon Mini M",
      "liter": 20,
      "waterType": 0,
      "imageUrl": "assets/images/aquarium.jpg"
    };

    await db.insert(
      'tank',
      aquariumMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(
      'tank',
      aquariumMap1,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}