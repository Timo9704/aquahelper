import 'package:aquahelper/screens/reminder.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:aquahelper/model/aquarium.dart';

import '../model/measurement.dart';
import '../model/task.dart';
import '../util/dbhelper.dart';
import '../widget/measurement_item.dart';
import '../widget/reminder_item.dart';
import 'measurement_form.dart';

class AquariumMeasurementReminder extends StatefulWidget {
  const AquariumMeasurementReminder({super.key,  required this.aquarium});
  final Aquarium aquarium;

  final String title = 'AquaHelper';

  @override
  State<AquariumMeasurementReminder> createState() => _AquariumMeasurementReminderState();
}

class _AquariumMeasurementReminderState extends State<AquariumMeasurementReminder> {
  List<Measurement> measurementList = [];
  List<Task> taskList = [];

  @override
  void initState() {
    super.initState();
    loadMeasurements();
    loadTasks();
  }

  void loadMeasurements() async {
    List<Measurement> dbMeasurements =
    await DBHelper.db.getMeasurmentsList(widget.aquarium);
    setState(() {
      measurementList = dbMeasurements.reversed.toList();
    });
  }

  void loadTasks() async {
    List<Task> dbTasks =
    await DBHelper.db.getTasksForAquarium(widget.aquarium.aquariumId);
    setState(() {
      taskList = dbTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: widget.aquarium.imagePath.startsWith('assets/')
                  ? Image.asset(widget.aquarium.imagePath, fit: BoxFit.cover)
                  : Image.file(File(widget.aquarium.imagePath),
                  fit: BoxFit.cover)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Alle Erinnerungen:',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
              IconButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Reminder(task: null, aquarium: widget.aquarium)));
                },
                icon: const Icon(
                  Icons.notification_add,
                  color: Colors.lightGreen,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: taskList.isNotEmpty
                ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: taskList.length,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              itemBuilder: (context, index) {
                return ReminderItem(
                  task: taskList.elementAt(index),
                  aquarium: widget.aquarium,
                );
              },
            )
                : const Center(
              child: Text('Aktuell keine Aufgaben vorhanden!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  )),
            )),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Alle Messungen:',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => MeasurementForm(
                            measurementId: '', aquarium: widget.aquarium)),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.lightGreen,
                ),
              ),
            ],
          ),
        ),
        Container(
            padding: const EdgeInsets.all(5.0),
            height: MediaQuery.of(context).size.height * 0.32,
            child: measurementList.isNotEmpty ?
            ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: measurementList.length,
              itemBuilder: (context, index) {
                return MeasurementItem(
                    measurement: measurementList.elementAt(index),
                    aquarium: widget.aquarium);
              },
            ):
            const Center(
              child: Text('Aktuell keine Messungen vorhanden!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  )),
            )
        ),
      ],
    );
  }
}