import 'dart:async';

import 'package:aquahelper/model/user_settings.dart';
import 'package:aquahelper/util/firebasehelper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/measurement.dart';

import '../model/activity.dart';
import '../model/components/filter.dart';
import '../model/components/heater.dart';
import '../model/components/lighting.dart';
import '../model/custom_timer.dart';
import '../model/task.dart';

class DBHelper {
  static const newDbVersion = 10;

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
          if (version >= 2) {
            await _databaseVersion2(db);
          }
          if (version >= 3) {
            await _databaseVersion3(db);
          }
          if (version >= 4) {
            await _databaseVersion4(db);
          }
          if (version >= 5) {
            await _databaseVersion5(db);
          }
          if (version >= 6) {
            await _databaseVersion6(db);
          }
          if (version >= 7) {
            await _databaseVersion7(db);
          }
          if (version >= 8) {
            await _databaseVersion8(db);
          }
          if (version >= 9) {
            await _databaseVersion9(db);
          }
          if (version >= 10) {
            await _databaseVersion10(db);
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
      case 3:
        await _databaseVersion3(db);
        break;
      case 4:
        await _databaseVersion4(db);
        break;
      case 5:
        await _databaseVersion5(db);
        break;
      case 6:
        await _databaseVersion6(db);
        break;
      case 7:
        await _databaseVersion7(db);
        break;
      case 8:
        await _databaseVersion8(db);
        break;
      case 9:
        await _databaseVersion9(db);
        break;
      case 10:
        await _databaseVersion10(db);
        break;
    }
  }

  _databaseVersion2(Database db) {
    db.execute("ALTER TABLE measurement ADD conductance REAL");
    db.execute("UPDATE measurement SET conductance = 0.0");
  }

  _databaseVersion3(Database db) {
    db.execute('''
            CREATE TABLE usersettings(
              measurementItems TEXT
            )''');
  }

  _databaseVersion4(Database db) {
    db.execute("ALTER TABLE tasks ADD scheduled TEXT");
    db.execute("ALTER TABLE tasks ADD scheduledDays TEXT");
    db.execute("ALTER TABLE tasks ADD scheduledTime TEXT");
    db.execute("UPDATE tasks SET scheduled = '0'");
    db.execute("UPDATE tasks SET scheduledDays = '[false,false,false,false,false,false,false]'");
    db.execute("UPDATE tasks SET scheduledTime = '00:00'");
  }

  _databaseVersion5(Database db) {
    db.execute('''
            CREATE TABLE customtimer(
              id TEXT,
              name TEXT,
              seconds INTEGER
            )''');
  }

  _databaseVersion6(Database db) {
    db.execute('''CREATE TABLE newCustomTimer(
        id TEXT PRIMARY KEY,
        name TEXT,
        seconds INTEGER
    )''');

    db.execute('INSERT INTO newCustomTimer(id, name, seconds) SELECT id, name, seconds FROM customTimer');

    db.execute('DROP TABLE customTimer');

    db.execute('ALTER TABLE newCustomTimer RENAME TO customTimer');
  }

  _databaseVersion7(Database db) {
    db.execute('''CREATE TABLE filter(
        filterId TEXT PRIMARY KEY,
        aquariumId TEXT,
        manufacturerModelName TEXT,
        filterType INTEGER,
        power REAL,
        flowRate REAL,
        lastMaintenance INTEGER,
        FOREIGN KEY(aquariumId) REFERENCES tank(aquariumId) ON DELETE CASCADE
    )''');

    db.execute('''CREATE TABLE lighting(
        lightingId TEXT PRIMARY KEY,
        aquariumId TEXT,
        manufacturerModelName TEXT,
        lightingType INTEGER,
        brightness INTEGER,
        onTime REAL,
        power REAL,
        FOREIGN KEY(aquariumId) REFERENCES tank(aquariumId) ON DELETE CASCADE
    )''');

    db.execute('''CREATE TABLE heater(
        heaterId TEXT PRIMARY KEY,
        aquariumId TEXT,
        manufacturerModelName TEXT,
        power REAL,
        FOREIGN KEY(aquariumId) REFERENCES tank(aquariumId) ON DELETE CASCADE
    )''');
  }

  _databaseVersion8(Database db) {
    db.execute('''CREATE TABLE activities(
        id TEXT PRIMARY KEY,
        aquariumId TEXT,
        activities TEXT,
        notes TEXT,
        date INTEGER,
        FOREIGN KEY(aquariumId) REFERENCES tank(aquariumId) ON DELETE CASCADE
    )''');
  }

  _databaseVersion9(Database db) {
    db.execute('''CREATE TABLE user(
        privacypolicy TEXT
    )''');
  }

  _databaseVersion10(Database db) {
    db.execute("ALTER TABLE measurement ADD silicate REAL");
    db.execute("UPDATE measurement SET silicate = 0.0");
  }

  //-------------------------Methods for Aquarium-object-----------------------//

  Future<List<Aquarium>> getAquariums() async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("tank");
    List<Aquarium> list = res.isNotEmpty ? res.map((c) => Aquarium.fromMap(c)).toList() : [];
    list.sort((a, b) => a.name.compareTo(b.name));
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

  Future<List<Measurement>> getMeasurmentsForAquarium(Aquarium aquarium) async {
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

  Future<List<Task>> checkRepeatableTasks(Aquarium aquarium) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("tasks", where: 'scheduled = ? AND aquariumId = ?', whereArgs: ['1', aquarium.aquariumId]);
    List<Task> tasks = res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    List<Task> tasksToday = [];
    int weekdayNow = DateTime.now().weekday;

    for(int i = 0; i < tasks.length; i++){
      TimeOfDay scheduledTime = TimeOfDay(
          hour: int.parse(tasks[i].scheduledTime.split(":")[0]),
          minute: int.parse(tasks[i].scheduledTime.split(":")[1]));
      List<bool> scheduledDaysBool = stringToBoolList(tasks[i].scheduledDays);
      for(int i = 0; i < scheduledDaysBool.length; i++){
        if(scheduledDaysBool[i] && i == weekdayNow-1 && isBeforeLatestDayTime(scheduledTime) && isNotInPast(scheduledTime)){
          tasksToday.add(tasks[i]);
        }
      }
    }
    return tasksToday;
  }

  List<bool> stringToBoolList(String str) {
    String trimmedStr = str.substring(1, str.length - 1);
    List<String> strList = trimmedStr.split(', ');
    List<bool> boolList = strList.map((s) => s.toLowerCase() == 'true').toList();

    return boolList;
  }

  isBeforeLatestDayTime(TimeOfDay scheduledTime) {
    TimeOfDay latestDayTime = const TimeOfDay(hour: 23, minute: 59);
    if(latestDayTime.hour > scheduledTime.hour){
      return true;
    } else if(latestDayTime.hour == scheduledTime.hour && latestDayTime.minute > scheduledTime.minute){
      return true;
    }
    return false;
  }

  isNotInPast(TimeOfDay scheduledTime) {
    TimeOfDay now = TimeOfDay.now();
    if(now.hour <= scheduledTime.hour && now.minute < scheduledTime.minute){
      return true;
    }
    return false;
  }


  //-------------------------Methods for user settings-----------------------//

  Future<List<UserSettings>> getUserSettings() async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("usersettings");
    List<UserSettings> list = res.isNotEmpty ? res.map((c) => UserSettings.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> saveUserSettings(UserSettings us) async {
    final db = await openDatabase('aquarium_database.db');
    if((await db.query("usersettings")).isEmpty){
      await db.insert(
          'usersettings',
          us.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }else{
      await db.update('usersettings',
          us.toMap(),
          conflictAlgorithm: ConflictAlgorithm.rollback);
    }
  }

  Future<bool> checkLatestPrivacyPolicy() async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("user");
    if(res.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  Future<void> updateLatestPrivacyPolicy() async {
    final db = await openDatabase('aquarium_database.db');
    await db.insert('user',
        {'privacypolicy': DateTime.now().millisecondsSinceEpoch},
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }


  //-------------------------Methods for import and export-----------------------//

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

    List<Map<String, dynamic>> customTimers = await db.query('customtimer');
    fileContent.add('## CustomTimers ##');
    for (var customTimer in customTimers) {
      fileContent.add(customTimer.values.join(','));
    }

    List<Map<String, dynamic>> activities = await db.query('activities');
    fileContent.add('## Activities ##');
    for (var activity in activities) {
      fileContent.add(activity.values.join(','));
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
              'imagePath': values[13],
              'conductance': values.length == 15 ? values[14] : 0.0
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
        else if (currentTable == '## CustomTimers ##') {
            await db.insert('customtimer', {
              'id': values[0],
              'name': values[1],
              'seconds': values[2]
            });
          }
          else if (currentTable == '## Activities ##') {
            await db.insert('activities', {
              'id': values[0],
              'aquariumId': values[1],
              'activities': values[2],
              'notes': values[3],
              'date': values[4]
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

  uploadDataToFirebase() async {
    final db = await openDatabase('aquarium_database.db');
    User user = FirebaseAuth.instance.currentUser!;
    await FirebaseHelper.db.initializeUser(user);
    FirebaseHelper.db.user = user;

    try {
      List<Map<String, dynamic>> tanks = await db.query('tank');
      for (var element in tanks) {
        Aquarium aquarium = Aquarium.fromMap(element);
        if(aquarium.imagePath != 'assets/images/aquarium.jpg'){
          String newImagePath = await uploadImageToFirebase(user, aquarium.imagePath);
          aquarium.imagePath = newImagePath;
        }
        FirebaseHelper.db.insertAquarium(aquarium);
      }

      List<Map<String, dynamic>> measurements = await db.query('measurement');
      for (var element in measurements) {
        Measurement measurement = Measurement.fromMap(element);
        if(measurement.imagePath != 'assets/images/aquarium.jpg') {
          String newImagePath = await uploadImageToFirebase(
              user, measurement.imagePath);
          measurement.imagePath = newImagePath;
        }
        FirebaseHelper.db.insertMeasurement(measurement);
      }

      List<Map<String, dynamic>> tasks = await db.query('tasks');
      for (var element in tasks) {
        FirebaseHelper.db.insertTask(Task.fromMap(element));
      }

      List<Map<String, dynamic>> userSettings = await db.query('usersettings');
      for (var element in userSettings) {
        FirebaseHelper.db.saveUserSettings(UserSettings.fromMap(element));
      }

      List<Map<String, dynamic>> customTimers = await db.query('customtimer');
      for (var element in customTimers) {
        FirebaseHelper.db.insertCustomTimer(CustomTimer.fromMap(element));
      }

      List<Map<String, dynamic>> activities = await db.query('activities');
      for (var element in activities) {
        FirebaseHelper.db.addActivity(Activity.fromMap(element));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  uploadImageToFirebase(User user, String imagePath) async {
    String imageName = imagePath.split('/').last;
    final storageRef = fbs.FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('${user.uid}/$imageName');
    final file = File(imagePath);
    await imageRef.putFile(file);
    final path = await imageRef.getDownloadURL();
    return path;
  }

  deleteLocalDbAfterUpload() async {
    final db = await openDatabase('aquarium_database.db');
    await db.delete("tank");
    await db.delete("measurement");
    await db.delete("tasks");
    await db.delete("usersettings");
    await db.delete("customtimer");
  }

//-------------------------Methods for custom-timer-----------------------//

  getCustomTimer() async{
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("customtimer");
    List<CustomTimer> list = res.isNotEmpty ? res.map((c) => CustomTimer.fromMap(c)).toList() : [];
    return list;
  }

  insertCustomTimer(CustomTimer timer) async {
    final db = await openDatabase('aquarium_database.db');
    await db.insert(
        'customtimer',
        timer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteCustomTimer(CustomTimer timer) async {
    final db = await openDatabase('aquarium_database.db');
    await db.delete("customtimer", where: "id = ?", whereArgs: [timer.id]);
  }

//-------------------------Methods for components-----------------------//

  getFilterByAquarium(String aquariumId) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("filter", where: 'aquariumId = ?', whereArgs: [aquariumId]);
    List<Filter> list = res.isNotEmpty ? res.map((c) => Filter.fromMap(c)).toList() : [];
    return list;
  }

  updateFilter(Filter filter) async {
    final db = await openDatabase('aquarium_database.db');
    await db.insert(
        'filter',
        filter.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteFilter(Filter filter) async {
    final db = await openDatabase('aquarium_database.db');
    await db.delete("filter", where: "filterId = ?", whereArgs: [filter.filterId]);
  }

  getLightingByAquarium(String aquariumId) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("lighting", where: 'aquariumId = ?', whereArgs: [aquariumId]);
    List<Lighting> list = res.isNotEmpty ? res.map((c) => Lighting.fromMap(c)).toList() : [];
    return list;
  }


  updateLighting(Lighting lighting) async {
    final db = await openDatabase('aquarium_database.db');
    await db.insert(
        'lighting',
        lighting.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteLighting(Lighting lighting) async {
    final db = await openDatabase('aquarium_database.db');
    await db.delete("lighting", where: "lightingId = ?", whereArgs: [lighting.lightingId]);
  }

  getHeaterByAquarium(String aquariumId) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("heater", where: 'aquariumId = ?', whereArgs: [aquariumId]);
    List<Heater> list = res.isNotEmpty ? res.map((c) => Heater.fromMap(c)).toList() : [];
    return list;
  }


  updateHeater(Heater heater) async {
    final db = await openDatabase('aquarium_database.db');
    await db.insert(
        'heater',
        heater.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteHeater(Heater heater) async {
    final db = await openDatabase('aquarium_database.db');
    await db.delete("heater", where: "heaterId = ?", whereArgs: [heater.heaterId]);
  }

  getActivitiesByAquarium(String aquariumId) async {
    final db = await openDatabase('aquarium_database.db');
    var res = await db.query("activities", where: 'aquariumId = ?', whereArgs: [aquariumId]);
    List<Activity> list = res.isNotEmpty ? res.map((c) => Activity.fromMap(c)).toList() : [];
    return list;
  }

  insertActivity(Activity activity) async {
    final db = await openDatabase('aquarium_database.db');
    await db.insert(
        'activities',
        activity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteActivity(Activity activity) async {
    final db = await openDatabase('aquarium_database.db');
    await db.delete("activities", where: "id = ?", whereArgs: [activity.id]);
  }

  updateActivity(Activity activity) async {
    final db = await openDatabase('aquarium_database.db');
    await db.update("activities",
        activity.toMap(),
        where: 'id = ?',
        whereArgs: [activity.id],
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }

}
