import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../model/activity.dart';
import '../../../util/datastore.dart';

class CreateOrEditActivities extends StatefulWidget {
  final String aquariumId;
  final Activity activity;

  const CreateOrEditActivities({super.key, required this.aquariumId, required this.activity});

  @override
  State<CreateOrEditActivities> createState() => _CreateOrEditActivitiesState();
}

class _CreateOrEditActivitiesState extends State<CreateOrEditActivities> {
  Set<String> selectedTags = <String>{};
  DateTime? selectedDate;
  final TextEditingController _noteController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    if (widget.activity.id.isNotEmpty) {
      selectedTags = widget.activity.activitites.split(",").toSet();
      selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.activity.date);
      _noteController.text = widget.activity.notes;
      createMode = false;
    }
  }

  void saveActivity() {
    if (selectedTags.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bitte mindestens eine Aufgabe und ein Datum auswählen!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Activity activity = Activity(
      const Uuid().v4().toString(),
      widget.aquariumId,
      selectedTags.join(","),
      selectedDate!.millisecondsSinceEpoch,
      _noteController.text,
    );

    Datastore.db.addActivity(activity);
    Navigator.pop(context, true);
  }

  void updateActivity() {
    if (selectedTags.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bitte mindestens eine Aufgabe und ein Datum auswählen!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Activity activity = Activity(
      widget.activity.id,
      widget.aquariumId,
      selectedTags.join(","),
      selectedDate!.millisecondsSinceEpoch,
      _noteController.text,
    );

    Datastore.db.updateActivity(activity);
    Navigator.pop(context, true);
  }

  void deleteActivity() {
    Datastore.db.deleteActivity(widget.activity);
    Navigator.pop(context, true);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aktivität erstellen"),
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Welche Aufgaben hast du erledigt?",
                          style: TextStyle(fontSize: 22, color: Colors.black)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10.0,
                        children: tags
                            .map((tag) => FilterChip(
                          label: Text(tag, style: const TextStyle(fontSize: 14)),
                          selected: selectedTags.contains(tag),
                          backgroundColor: Colors.white,
                          selectedColor: Colors.lightGreen,
                          checkmarkColor: Colors.white,
                          showCheckmark: false,
                          onSelected: (selected) {
                            setState(() {
                              selected
                                  ? selectedTags.add(tag)
                                  : selectedTags.remove(tag);
                            });
                          },
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Notizen:",
                          style: TextStyle(fontSize: 22, color: Colors.black)),
                      TextFormField(
                        maxLines: 5,
                        cursorColor: Colors.black,
                        controller: _noteController,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText:
                          "Hier kannst du Notizen zu deiner Aktivität eintragen.",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  selectedDate == null
                      ? 'Wähle ein Datum'
                      : 'Datum: ${DateFormat('dd.MM.yyyy').format(selectedDate!)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              createMode ?
              ElevatedButton(
                  onPressed: saveActivity,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text("Aktivität speichern",
                      style: TextStyle(fontSize: 20))) :
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: deleteActivity,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text("Löschen",
                          style: TextStyle(fontSize: 20))),
                  ElevatedButton(
                      onPressed: updateActivity,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text("Aktualisieren",
                          style: TextStyle(fontSize: 20)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
