import 'package:flutter/material.dart';

import '../../model/task.dart';
import '../../util/dbhelper.dart';

class DashboardReminder extends StatefulWidget {
  const DashboardReminder({super.key});

  @override
  State<DashboardReminder> createState() => DashboardReminderState();
}

class DashboardReminderState extends State<DashboardReminder> {
  List<Task> taskList = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    List<Task> dbTasks = await DBHelper.db.getTasksForCurrentDay();
    setState(() {
      taskList = dbTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 120,
        decoration: BoxDecoration(
          /*border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),*/
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const Text('Erinnerungen',
                style: TextStyle(fontSize: 17, color: Colors.black)),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 10, 2, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  taskList.isEmpty ?
                  const Text('Für heute keine Erinnerungen!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 19, color: Colors.black)):
                  taskList.length >= 2 ?
                  Text('Noch ${taskList.length} Aufgaben zu erledigen!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 19, color: Colors.black)):
                  Text('Noch ${taskList.length} Aufgabe zu erledigen!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 19, color: Colors.black))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
