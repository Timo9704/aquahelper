import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../model/aquarium.dart';
import '../model/measurement.dart';
import '../model/task.dart';
import '../model/user_settings.dart';
import 'dbhelper.dart';
import 'firebasehelper.dart';

class Datastore {

  static final Datastore db = Datastore._();

  Datastore._();

  User? user = FirebaseAuth.instance.currentUser;


  getAquariums() async {
    if (user == null) {
      return await DBHelper.db.getAquariums();
    } else {
      return await FirebaseHelper.db.getAllAquariums();
    }
  }

  insertAquarium(Aquarium aquarium) async {
    if (user == null) {
      await DBHelper.db.insertAquarium(aquarium);
    } else {
      await FirebaseHelper.db.insertAquarium(aquarium);
    }
  }

  updateAquarium(Aquarium aquarium) async {
    if (user == null) {
      await DBHelper.db.updateAquarium(aquarium);
    } else {
      await FirebaseHelper.db.updateAquarium(aquarium);
    }
  }

  deleteAquarium(String aquariumId) async {
    if (user == null) {
      await DBHelper.db.deleteAquarium(aquariumId);
    } else {
      await FirebaseHelper.db.deleteAquarium(aquariumId);
    }
  }

  //-------------------------Methods for Measurement-object-----------------------//

  getMeasurementsForAquarium(Aquarium aquarium) async {
    if (user == null) {
      return await DBHelper.db.getMeasurmentsForAquarium(aquarium);
    } else {
      return await FirebaseHelper.db.getMeasurementsForAquarium(aquarium.aquariumId);
    }
  }

  getMeasurementById(String aquariumId, String measurementId) async {
    if (user == null) {
      return await DBHelper.db.getMeasurementById(measurementId);
    } else {
      return await FirebaseHelper.db.getMeasurementById(aquariumId, measurementId);
    }
  }

  getMeasurementsByInterval(String aquariumId, int startInterval, int endInterval) async {
    if (user == null) {
      return await DBHelper.db.getMeasurementsByInterval(aquariumId, startInterval, endInterval);
    } else {
      return await FirebaseHelper.db.getMeasurementsByInterval(aquariumId, startInterval, endInterval);
    }
  }

  getMeasurementAmountByAllTime() async {
    if (user == null) {
      return await DBHelper.db.getMeasurementAmountByAllTime();
    } else {
      return await FirebaseHelper.db.getMeasurementAmountByAllTime();
    }
  }

  getMeasurementAmountByLast30Days(int now, int endInterval) async {
    if (user == null) {
      return await DBHelper.db.getMeasurementAmountByLast30Days(now, endInterval);
    } else {
      return await FirebaseHelper.db.getMeasurementAmountByLast30Days(now, endInterval);
    }
  }

  insertMeasurement(Measurement measurement) async {
    if (user == null) {
      await DBHelper.db.insertMeasurement(measurement);
    } else {
      await FirebaseHelper.db.insertMeasurement(measurement);
    }
  }

  updateMeasurement(Measurement measurement) async {
    if (user == null) {
      await DBHelper.db.updateMeasurement(measurement);
    } else {
      await FirebaseHelper.db.updateMeasurement(measurement);
    }
  }

  deleteMeasurement(String aquariumId, String measurementId) async {
    if (user == null) {
      await DBHelper.db.deleteMeasurement(measurementId);
    } else {
      await FirebaseHelper.db.deleteMeasurement(aquariumId, measurementId);
    }
  }

  getSortedMeasurmentsList(Aquarium aquarium) async {
    if (user == null) {
      return await DBHelper.db.getSortedMeasurmentsList(aquarium);
    } else {
      return await FirebaseHelper.db.getSortedMeasurmentsList(aquarium);
    }
  }

  //-------------------------Methods for Tasks-object-----------------------//

  getTasksForAquarium(Aquarium aquarium) async {
    if (user == null) {
      return await DBHelper.db.getTasksForAquarium(aquarium.aquariumId);
    } else {
      return await FirebaseHelper.db.getAllTasksForAquarium(aquarium);
    }
  }

  insertTask(Task task) async {
    if (user == null) {
      await DBHelper.db.insertTask(task);
    } else {
      await FirebaseHelper.db.insertTask(task);
    }
  }

  updateTask(Aquarium aquarium, Task task) async {
    if (user == null) {
      await DBHelper.db.updateTask(task);
    } else {
      await FirebaseHelper.db.updateTask(aquarium, task);
    }
  }

  deleteTask(Aquarium aquarium, String taskId) async {
    if (user == null) {
      await DBHelper.db.deleteTask(taskId);
    } else {
      await FirebaseHelper.db.deleteTask(aquarium, taskId);
    }
  }

  getTasksForCurrentDayForAquarium(Aquarium aquarium) async {
    if (user == null) {
      return await DBHelper.db.getTasksForCurrentDayForAquarium(aquarium.aquariumId);
    } else {
      return await FirebaseHelper.db.getTasksForCurrentDayForAquarium(aquarium.aquariumId);
    }
  }

  getAllTasksForCurrentDay() async {
    if (user == null) {
      return await DBHelper.db.getTasksForCurrentDay();
    } else {
      return await FirebaseHelper.db.getTasksForCurrentDay();
    }
  }

  //-------------------------Methods for UserSettings-object-----------------------//


  Future<List<UserSettings>> getUserSettings() async {
    if (user == null) {
      return await DBHelper.db.getUserSettings();
    } else {
      return await FirebaseHelper.db.getUserSettings();
    }
  }

  Future<void> saveUserSettings(UserSettings userSettings) async {
    if (user == null) {
      return await DBHelper.db.saveUserSettings(userSettings);
    } else {
      return await FirebaseHelper.db.saveUserSettings(userSettings);
    }
  }

  saveImages(File file){
    final ref = firebase_storage.FirebaseStorage.instance.ref().child('images/${file.path}');
    ref.putFile(file);
  }

  getImage(String path){
    final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
    return ref.getDownloadURL();
  }

}