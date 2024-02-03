import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/measurement.dart';

import '../model/task.dart';

class DBHelper {
  static const newDbVersion = 2;

  static final DBHelper db = DBHelper._();
  DBHelper._();

  initDB() async {
    String path = join(await getDatabasesPath(), 'aquarium_database.db');
    return await openDatabase(path, version: newDbVersion, onOpen: (db) async {},
        onCreate: (Database db, int version) async {
          await db.execute('PRAGMA foreign_keys = ON');
          await db.execute('''
            CREATE TABLE tank(
              aquariumId TEXT PRIMARY KEY, 
              name TEXT, 
              liter INTEGER, 
              waterType INTEGER, 
              co2Type INTEGER, 
              width INTEGER, 
              height INTEGER, 
              depth INTEGER, 
              healthStatus INTEGER, 
              imagePath TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE measurement(
              measurementId TEXT PRIMARY KEY, 
              aquariumId INTEGER, 
              temperature REAL, 
              ph REAL, 
              totalHardness REAL, 
              carbonateHardness REAL, 
              nitrite REAL, 
              nitrate REAL, 
              phosphate REAL, 
              potassium REAL, 
              iron REAL, 
              magnesium REAL, 
              measurementDate INTEGER, 
              imagePath TEXT, 
              FOREIGN KEY(aquariumId) REFERENCES tank(aquariumId) ON DELETE CASCADE
            )
          ''');
          await db.execute('''
            CREATE TABLE tasks(
              taskId TEXT PRIMARY KEY, 
              aquariumId INTEGER, 
              title TEXT, 
              description TEXT, 
              taskDate INTEGER
            )
          ''');
          if (version == 2) {
            await _databaseVersion2(db);
          }
    },
    onUpgrade: _upgradeDb
    );
  }

  Future<void>  _upgradeDb(Database  db, int  oldVersion, int  newVersion) async {
    for (int version = oldVersion; version < newVersion; version++) {
      await _performDbOperationsVersionWise(db, version + 1);
    }
  }

  _performDbOperationsVersionWise(Database db, int version) async {
    switch (version) {
      case 2:
        await _databaseVersion2(db);
        break;
    }
  }

  _databaseVersion2(Database db) {
    db.execute("ALTER TABLE measurement ADD conductance REAL");
    db.execute("UPDATE measurement SET conductance = 0.0");
  }

  //-------------------------Methods for Aquarium-object-----------------------//

  Future<List<Aquarium>> getAquariums() async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("tank");
    List<Aquarium> list = res.isNotEmpty ? res.map((c) => Aquarium.fromMap(c)).toList() : [];
    return list;
  }

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
    await db.execute('PRAGMA foreign_keys = ON');
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

  Future<List<Measurement>> getSortedMeasurmentsList(Aquarium aquarium) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("measurement", where: 'aquariumId = ?', whereArgs: [aquarium.aquariumId], orderBy: 'measurementDate ASC');
    List<Measurement> list = res.isNotEmpty ? res.map((c) => Measurement.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Measurement>> getMeasurmentsList(Aquarium aquarium) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("measurement", where: 'aquariumId = ?', whereArgs: [aquarium.aquariumId], orderBy: "measurementDate");
    List<Measurement> list = res.isNotEmpty ? res.map((c) => Measurement.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Measurement>> getMeasurementsByInterval(String aquariumId, int intervalStart, int endInterval) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("measurement", where: 'aquariumId = ? AND measurementDate BETWEEN ? AND ?', whereArgs: [aquariumId, endInterval, intervalStart]);
    List<Measurement> list = res.isNotEmpty ? res.map((c) => Measurement.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> getMeasurementAmountByAllTime() async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("measurement");
    List<Measurement> list = res.isNotEmpty ? res.map((c) => Measurement.fromMap(c)).toList() : [];
    return list.length;
  }

  Future<int> getMeasurementAmountByLast30Days(int intervalStart, int endInterval) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("measurement", where: 'measurementDate BETWEEN ? AND ?', whereArgs: [endInterval, intervalStart]);
    List<Measurement> list = res.isNotEmpty ? res.map((c) => Measurement.fromMap(c)).toList() : [];
    return list.length;
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

  //-------------------------Methods for Task-object-----------------------//

  Future<void> insertTask(Task task) async {
    final db = await openDatabase('aquarium_database.db');
    await db.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTask(Task task) async {
    final db = await openDatabase('aquarium_database.db');
    await db.update("tasks",
        task.toMap(),
        where: 'taskId = ?',
        whereArgs: [task.taskId],
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  Future<List<Task>> getTasksForCurrentDayForAquarium(String aquariumId) async {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59);
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("tasks", where: 'aquariumId = ? AND taskDate BETWEEN ? AND ?', orderBy: 'taskDate ASC', whereArgs: [aquariumId, now.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch]);
    List<Task> list = res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Task>> getTasksForAquarium(String aquariumId) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("tasks", where: 'aquariumId = ? AND taskDate >= ?', orderBy: 'taskDate ASC', whereArgs: [aquariumId, DateTime.now().millisecondsSinceEpoch]);
    List<Task> list = res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Task>> getTasksForCurrentDay() async {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59);
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("tasks", where: 'taskDate BETWEEN ? AND ?', whereArgs: [now.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch]);
    List<Task> list = res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteTask(String taskId) async {
    final db = await openDatabase('aquarium_database.db');
    await db.delete("tasks", where: "taskId = ?", whereArgs: [taskId]);
  }

  Future<String> exportAllData() async {
    final db = await openDatabase('aquarium_database.db');
    List<String> fileContent = [];

    List<Map<String, dynamic>> tanks = await db.query('tank');
    fileContent.add('## Tank ##');
    for (var tank in tanks) {
      fileContent.add(tank.values.join(','));
    }

    List<Map<String, dynamic>> measurements = await db.query('measurement');
    fileContent.add('## Measurement ##');
    for (var measurement in measurements) {
      fileContent.add(measurement.values.join(','));
    }

    List<Map<String, dynamic>> tasks = await db.query('tasks');
    fileContent.add('## Tasks ##');
    for (var task in tasks) {
      fileContent.add(task.values.join(','));
    }

    try {
      String? path = await FilePicker.platform.getDirectoryPath();

      DateTime time = DateTime.now();

      final DateFormat formatter = DateFormat('yyyy_MM_dd-HH_mm');
      final String formatted = formatter.format(time);

      String pathTxt = '$path/database_export_$formatted.txt';

      File file = File(pathTxt);
      await file.writeAsString(fileContent.join('\n'));
      return pathTxt;
    }catch(e){
      return "fail";
    }
  }

  Future<bool> importAllData() async {
    final db = await openDatabase('aquarium_database.db');
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        final lines = await file.readAsLines();
        String currentTable = '';

        for (var line in lines) {
          if (line.startsWith('##')) {
            currentTable = line;
            continue;
          }

          List<String> values = line.split(',');

          if (currentTable == '## Tank ##') {
            await db.insert('tank', {
              'aquariumId': values[0],
              'name': values[1],
              'liter': values[2],
              'waterType': values[3],
              'co2Type': values[4],
              'width': values[5],
              'height': values[6],
              'depth': values[7],
              'healthStatus': values[8],
              'imagePath': values[9]
            });
          } else if (currentTable == '## Measurement ##') {
            await db.insert('measurement', {
              'measurementId': values[0],
              'aquariumId': values[1],
              'temperature': values[2],
              'ph': values[3],
              'totalHardness': values[4],
              'carbonateHardness': values[5],
              'nitrite': values[6],
              'nitrate': values[7],
              'phosphate': values[8],
              'potassium': values[9],
              'iron': values[10],
              'magnesium': values[11],
              'measurementDate': values[12],
              'imagePath': values[13]
            });
          } else if (currentTable == '## Tasks ##') {
            await db.insert('tasks', {
              'taskId': values[0],
              'aquariumId': values[1],
              'title': values[2],
              'description': values[3],
              'taskDate': values[4]
            });
          }
        }
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }


}