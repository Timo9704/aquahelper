import 'package:aquahelper/model/activity.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class CreateOrEditActivityViewModel extends ChangeNotifier {
  double textScaleFactor = 0;
  Set<String> selectedTags = <String>{};
  DateTime? selectedDate;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController customTagController = TextEditingController();
  bool createMode = true;
  List<String> tags = [
    'Wasserwechsel',
    'Filterreinigung',
    'Düngung',
    'Rückschnitt',
    'CO2',
    'Fütterung',
    'Bodengrund mulmen',
    'Wasserwerte messen',
    'sonstiges'
  ];
  Activity activity;
  String aquariumId = "";

  CreateOrEditActivityViewModel(this.activity, this.aquariumId) {
    if (activity.id.isNotEmpty) {
      selectedTags = activity.activities.split(",").toSet();
      checkAndAddCustomTags();
      selectedDate = DateTime.fromMillisecondsSinceEpoch(activity.date);
      noteController.text = activity.notes;
      createMode = false;
    }else{
      selectedDate = DateTime.now();
    }
  }

  void checkAndAddCustomTags() {
    for (String tag in selectedTags) {
      if (!tags.contains(tag)) {
        tags.add(tag);
      }
    }
    notifyListeners();
  }

  void onTagSelected(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    notifyListeners();
  }

  void onAddCustomTag() {
    if (customTagController.text.isNotEmpty) {
      tags.add(customTagController.text);
      selectedTags.add(customTagController.text);
      customTagController.clear();
      notifyListeners();
    }
  }

  Future<void> saveActivity(BuildContext context) async {
    if (selectedTags.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text("Bitte mindestens eine Aufgabe und ein Datum auswählen!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Activity activity = Activity(
      const Uuid().v4().toString(),
      aquariumId,
      selectedTags.join(","),
      selectedDate!.millisecondsSinceEpoch,
      noteController.text,
    );

    logEvent("Activity_Created");

    await Datastore.db.addActivity(activity);
    if(context.mounted){
      Navigator.pop(context, true);
    }
  }

  Future<void> updateActivity(BuildContext context) async {
    if (selectedTags.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text("Bitte mindestens eine Aufgabe und ein Datum auswählen!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Activity activity = Activity(
      this.activity.id,
      aquariumId,
      selectedTags.join(","),
      selectedDate!.millisecondsSinceEpoch,
      noteController.text,
    );

    await Datastore.db.updateActivity(activity);
    if(context.mounted){
      Navigator.pop(context, true);
    }
  }

  void deleteActivity(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Warnung"),
          content:  const Text("Willst du diese Aktivität wirklich löschen?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Nein"),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
                  onPressed: () async {
                    await Datastore.db.deleteActivity(activity);
                    if(context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    }
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

  setSelectedDate(DateTime selectedDate) {
    this.selectedDate = selectedDate;
    notifyListeners();
  }

  Future<void> logEvent(String logFunction) async {
    await FirebaseAnalytics.instance
        .logEvent(name: logFunction, parameters: null);
  }

}
