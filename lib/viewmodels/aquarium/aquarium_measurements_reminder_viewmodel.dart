import 'dart:io';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/measurement.dart';
import 'package:aquahelper/model/task.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:flutter/material.dart';

class AquariumMeasurementReminderViewModel extends ChangeNotifier {
  Aquarium? aquarium;
  int taskAmount = 0;
  List<Measurement> measurementList = [];
  List<Task> taskList = [];

  void initAquarium(Aquarium initAquarium) {
    aquarium = initAquarium;
    refresh();
  }

  void refresh() {
    loadTasks();
    loadMeasurements();
  }

  void loadMeasurements() async {
    List<Measurement> dbMeasurements =
    await Datastore.db.getMeasurementsForAquarium(aquarium!);
    measurementList = dbMeasurements.reversed.toList();
    notifyListeners();
  }

  void loadTasks() async {
    taskList.clear();
    notifyListeners();
    taskList = await Task.task.getTaskListByAquarium(aquarium!);
    notifyListeners();
  }

  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(aquarium!.imagePath), fit: BoxFit.cover);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fitWidth);
    }
  }
}






