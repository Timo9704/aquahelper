import 'package:aquahelper/main.dart';
import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:aquahelper/viewmodels/dashboard_viewmodel.dart';
import 'package:aquahelper/views/homepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:aquahelper/model/task.dart' as model;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


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
  DashboardViewModel dashboardViewModel;

  CreateOrEditAquariumViewModel(this.aquarium, this.dashboardViewModel) {
    if (aquarium.aquariumId != "") {
      aquarium = aquarium;
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

  setWaterType(int value) {
    waterType = value;
    notifyListeners();
  }

  setCo2Type(int value) {
    co2Type = value;
    notifyListeners();
  }

  void saveAquarium(BuildContext context) async {
    try {
      syncValuesToObject(context);

      if (createMode) {
        Datastore.db.insertAquarium(aquarium);
      } else {
        Datastore.db.updateAquarium(aquarium);
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const AquaHelper()));
    } catch (e) {
      createAquariumFailure(context);
    }
  }

  void deleteAquarium(BuildContext context, CreateOrEditAquariumViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Warnung"),
          content: const Text("Willst du dieses Aquarium wirklich löschen?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Nein"),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightGreen)),
                  onPressed: () async {
                    deleteAndCancelReminder(aquarium);
                    Datastore.db.deleteAquarium(aquarium.aquariumId);
                    Provider.of<DashboardViewModel>(context, listen: false).refresh();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const Homepage()),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text("Ja"),
                ),
              ],
            ),
          ],
          elevation: 0,
        );
      },
    );
  }

  void syncValuesToObject(BuildContext context) {
    if (aquarium.aquariumId == "") {
      aquarium = Aquarium(
          const Uuid().v4().toString(),
          nameController.text,
          int.parse(literController.text.isEmpty ? "0" : literController.text),
          waterType,
          co2Type,
          int.parse(widthController.text.isEmpty ? "0" : widthController.text),
          int.parse(
              heightController.text.isEmpty ? "0" : heightController.text),
          int.parse(depthController.text.isEmpty ? "0" : depthController.text),
          int.parse("0"),
          int.parse("0"),
          int.parse("0"),
          imagePath);
    } else {
      aquarium.waterType = waterType;
      aquarium.name = nameController.text;
      aquarium.liter =
          int.parse(literController.text.isEmpty ? "0" : literController.text);
      aquarium.co2Type = co2Type;
      aquarium.width =
          int.parse(widthController.text.isEmpty ? "0" : widthController.text);
      aquarium.height = int.parse(
          heightController.text.isEmpty ? "0" : heightController.text);
      aquarium.depth =
          int.parse(depthController.text.isEmpty ? "0" : depthController.text);
      aquarium.imagePath = imagePath;
    }
    dashboardViewModel.refresh();
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

  void createAquariumFailure(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Fehlerhafte Eingabe"),
          content: const SizedBox(
            height: 60,
            child: Column(
              children: [
                Text(
                    "Kontrolliere bitte deine Eingaben! Zahlenwerte sind immer ohne Komma und Leerzeichen einzugeben."),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey)),
              child: const Text("Schließen"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          elevation: 0,
        );
      },
    );
  }
}
