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
          await db.execute('CREATE TABLE tank(aquariumId TEXT PRIMARY KEY, name TEXT, liter INTEGER, waterType INTEGER, imagePath TEXT)');
          await db.execute('CREATE TABLE measurement(measurementId TEXT PRIMARY KEY, aquariumId INTEGER, temperature REAL, ph REAL, totalHardness REAL, carbonateHardness REAL, nitrite REAL, nitrate REAL, phosphate REAL, potassium REAL, iron REAL, magnesium REAL, measurementDate INTEGER, imagePath TEXT, FOREIGN KEY(aquariumId) REFERENCES tank(aquariumId))');
        });
  }

  //-------------------------Methods for Aquarium-object-----------------------//

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
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateAquarium(Aquarium aquarium) async {
    final db = await openDatabase('aquarium_database.db');
    await db.update("tank",
        aquarium.toMap(),
        where: 'aquariumId = ?',
        whereArgs: [aquarium.aquariumId],
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  Future<void> deleteAquarium(String aquariumId) async {
    final db = await openDatabase('aquarium_database.db');
    await db.delete("tank",
        where: "aquariumId = ?",
        whereArgs: [aquariumId]);
  }

  //-------------------------Methods for Measurement-object-----------------------//

  Future<Measurement> getMeasurementById(String measurementId) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("measurement", where: 'measurementId = ?', whereArgs: [measurementId]);
    List<Measurement> measurement = res.isNotEmpty ? res.map((c) => Measurement.fromMap(c)).toList() : [];
    return measurement.first;
  }

  Future<List<Measurement>> getMeasurmentsList(Aquarium aquarium) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("measurement", where: 'aquariumId = ?', whereArgs: [aquarium.aquariumId]);
    List<Measurement> list = res.isNotEmpty ? res.map((c) => Measurement.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Measurement>> getMeasurementsByInterval(String aquariumId, int intervalStart, int endInterval) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("measurement", where: 'aquariumId = ? AND measurementDate BETWEEN ? AND ?', whereArgs: [aquariumId, endInterval, intervalStart]);
    List<Measurement> list = res.isNotEmpty ? res.map((c) => Measurement.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> insertMeasurement(Measurement measurement) async {
    final db = await openDatabase('aquarium_database.db');
      await db.insert(
        'measurement',
        measurement.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateMeasurement(Measurement measurement) async {
    final db = await openDatabase('aquarium_database.db');
    await db.update("measurement",
        measurement.toMap(),
        where: 'measurementId = ?',
        whereArgs: [measurement.measurementId],
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  Future<void> deleteMeasurement(String measurementId) async {
    final db = await openDatabase('aquarium_database.db');
    await db.delete("measurement",
        where: "measurementId = ?",
        whereArgs: [measurementId]);
  }
}