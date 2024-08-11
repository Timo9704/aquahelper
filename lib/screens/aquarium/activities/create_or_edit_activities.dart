import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../model/activity.dart';
import '../../../util/datastore.dart';

class CreateOrEditActivities extends StatefulWidget {
  final String aquariumId;
  final Activity activity;

  const CreateOrEditActivities(
      {super.key, required this.aquariumId, required this.activity});

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
      selectedTags = widget.activity.activities.split(",").toSet();
      selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.activity.date);
      _noteController.text = widget.activity.notes;
      createMode = false;
    }
  }

  void saveActivity() {
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
      widget.aquariumId,
      selectedTags.join(","),
      selectedDate!.millisecondsSinceEpoch,
      _noteController.text,
    );

    logEvent("Activity_Created");

    Datastore.db.addActivity(activity);
    Navigator.pop(context, true);
  }

  void updateActivity() {
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
    DateTime? tempSelectedDate = selectedDate;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.white,
        title: const Text('Wähle ein Datum'),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 400,
                    child: TableCalendar(
                      firstDay: DateTime.utc(2010, 1, 1),
                      lastDay: DateTime.utc(2030, 1, 1),
                      focusedDay: tempSelectedDate ?? DateTime.now(),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.lightGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                      ),
                      selectedDayPredicate: (day) {
                        return isSameDay(tempSelectedDate, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setStateDialog(() {
                          tempSelectedDate = selectedDay;
                        });
                      },
                    ),
                  ),
                ),
              );
            }
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightGreen,
            ),
            child: const Text('OK'),
            onPressed: () {
              if (tempSelectedDate != null) {
                setState(() {
                  selectedDate = tempSelectedDate;
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }


  Future<void> logEvent(String logFunction) async {
    await FirebaseAnalytics.instance
        .logEvent(name: logFunction, parameters: null);
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
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10.0,
                        children: tags
                            .map((tag) => FilterChip(
                                  label: Text(tag,
                                      style: const TextStyle(fontSize: 14)),
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
                          style: TextStyle(fontSize: 20, color: Colors.black)),
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
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              createMode
                  ? ElevatedButton(
                      onPressed: saveActivity,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text("Aktivität speichern",
                          style: TextStyle(fontSize: 18)))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: deleteActivity,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text("Löschen",
                                style: TextStyle(fontSize: 18))),
                        ElevatedButton(
                            onPressed: updateActivity,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text("Aktualisieren",
                                style: TextStyle(fontSize: 18)))
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
