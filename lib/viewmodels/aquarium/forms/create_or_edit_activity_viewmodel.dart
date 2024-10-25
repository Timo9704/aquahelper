import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../model/activity.dart';
import '../../../util/datastore.dart';


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

  void saveActivity(BuildContext context) {
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

    Datastore.db.addActivity(activity);
    Navigator.pop(context, true);
  }

  void updateActivity(BuildContext context) {
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

    Datastore.db.updateActivity(activity);
    Navigator.pop(context, true);
  }

  void deleteActivity(BuildContext context) {
    Datastore.db.deleteActivity(activity);
    Navigator.pop(context, true);
  }

  Future<void> logEvent(String logFunction) async {
    await FirebaseAnalytics.instance
        .logEvent(name: logFunction, parameters: null);
  }

}
