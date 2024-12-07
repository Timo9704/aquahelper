import 'dart:io';

import 'package:aquahelper/model/aquarium.dart';
import 'package:flutter/material.dart';
import '../../model/task.dart';
import '../../util/datastore.dart';

class AquariumItemViewModel extends ChangeNotifier {
  Aquarium aquarium;
  int taskAmount = 0;

  AquariumItemViewModel(this.aquarium) {
    loadTasks();
  }

  void loadTasks() async {
    List<Task> dbTasks =
    await Datastore.db.getTasksForCurrentDayForAquarium(aquarium);
    List<Task> repeatableTasks = await Datastore.db.checkRepeatableTasks(aquarium);
    dbTasks.addAll(repeatableTasks);
    taskAmount = dbTasks.length;
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
