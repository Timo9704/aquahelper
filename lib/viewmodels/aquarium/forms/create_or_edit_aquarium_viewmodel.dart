import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:aquahelper/model/task.dart' as model;
import 'package:uuid/uuid.dart';

import '../../../model/aquarium.dart';
import '../../../model/user.dart';
import '../../../util/datastore.dart';


class CreateOrEditAquariumViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final literController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final depthController = TextEditingController();
  int waterType = 0;
  int co2Type = 0;
  double textScaleFactor = 0;
  bool createMode = true;
  String imagePath = "assets/images/aquarium.jpg";
  Aquarium aquarium;
  User user = Datastore.db.user as User;

  CreateOrEditAquariumViewModel(this.aquarium) {
    if (aquarium.aquariumId != "") {
      aquarium = aquarium!;
      imagePath = aquarium.imagePath;
      waterType = aquarium.waterType;
      co2Type = aquarium.co2Type;
      nameController.text = aquarium.name;
      literController.text = aquarium.liter.toString();
      widthController.text = aquarium.width.toString();
      heightController.text = aquarium.height.toString();
      depthController.text = aquarium.depth.toString();
      createMode = false;
    }
  }

  void syncValuesToObject() {
    if (aquarium == null) {
      String uuid = const Uuid().v4().toString();
      aquarium = Aquarium(
          uuid,
          nameController.text,
          int.parse(
              literController.text.isEmpty ? "0" : literController.text),
          waterType,
          co2Type,
          int.parse(
              widthController.text.isEmpty ? "0" : widthController.text),
          int.parse(
              heightController.text.isEmpty ? "0" : heightController.text),
          int.parse(
              depthController.text.isEmpty ? "0" : depthController.text),
          int.parse("0"),
          int.parse("0"),
          int.parse("0"),
          imagePath);
    } else {
      aquarium.waterType = waterType;
      aquarium.name = nameController.text;
      aquarium.liter = int.parse(
          literController.text.isEmpty ? "0" : literController.text);
      aquarium.co2Type = co2Type;
      aquarium.width = int.parse(
          widthController.text.isEmpty ? "0" : widthController.text);
      aquarium.height = int.parse(
          heightController.text.isEmpty ? "0" : heightController.text);
      aquarium.depth = int.parse(
          depthController.text.isEmpty ? "0" : depthController.text);
      aquarium.imagePath = imagePath;
    }
  }

  Future<void> deleteAndCancelReminder(Aquarium aquarium) async {
    List<model.Task> tasks = await Datastore.db.getTasksForAquarium(aquarium);
    if (tasks.isNotEmpty) {
      for (var task in tasks) {
        if (task.scheduled == "1") {
          List<bool> daysOfWeek = stringToBoolList(task.scheduledDays);
          cancelRecurringNotifications(
              task,
              daysOfWeek
                  .asMap()
                  .entries
                  .where((entry) => entry.value)
                  .map((entry) => entry.key + 1)
                  .toList());
          Datastore.db.deleteTask(aquarium, task.taskId);
        } else {
          AwesomeNotifications().cancelSchedule(task.taskDate ~/ 1000);
          Datastore.db.deleteTask(aquarium, task.taskId);
        }
      }
    }
  }

  void cancelRecurringNotifications(
      model.Task task, List<int> daysOfWeek) async {
    for (int dayOfWeek in daysOfWeek) {
      await AwesomeNotifications()
          .cancel((task.taskId + dayOfWeek.toString()).hashCode);
    }
  }

  List<bool> stringToBoolList(String str) {
    String trimmedStr = str.substring(1, str.length - 1);
    List<String> strList = trimmedStr.split(', ');
    List<bool> boolList =
    strList.map((s) => s.toLowerCase() == 'true').toList();

    return boolList;
  }
}
