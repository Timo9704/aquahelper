import 'dart:io';

import 'package:aquahelper/model/aquarium.dart';
import 'package:flutter/material.dart';
import '../../model/measurement.dart';
import '../../model/task.dart';
import '../../util/datastore.dart';

class AquariumMeasurementReminderViewModel extends ChangeNotifier {
  Aquarium aquarium;
  int taskAmount = 0;
  List<Measurement> measurementList = [];
  List<Task> taskList = [];

  AquariumMeasurementReminderViewModel(this.aquarium) {
    loadTasks();
    loadMeasurements();
  }

  void loadMeasurements() async {
    List<Measurement> dbMeasurements =
    await Datastore.db.getMeasurementsForAquarium(aquarium);
    measurementList = dbMeasurements.reversed.toList();
    notifyListeners();
  }

  void loadTasks() async {
    taskList = await Task.task.getTaskListByAquarium(aquarium);
    notifyListeners();
  }

  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(aquarium.imagePath), fit: BoxFit.cover);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fitWidth);
    }
  }
}






