import 'package:flutter/material.dart';

import '../model/aquarium.dart';
import '../model/task.dart';
import '../screens/reminder.dart';

class ReminderItem extends StatefulWidget {
  const ReminderItem({super.key, required this.task, required this.aquarium});

  final Aquarium aquarium;
  final Task task;

  @override
  State<ReminderItem> createState() => ReminderItemState();
}

class ReminderItemState extends State<ReminderItem> {
  int daysBetween = 0;

  @override
  void initState() {
    super.initState();
    daysBetween = calculateDaysBetweenEpochs(DateTime.now().millisecondsSinceEpoch, widget.task.taskDate);
  }


  int calculateDaysBetweenEpochs(int epoch1, int epoch2) {
    DateTime date1 = DateTime.fromMillisecondsSinceEpoch(epoch1);
    DateTime date2 = DateTime.fromMillisecondsSinceEpoch(epoch2);

    DateTime dateOnly1 = DateTime(date1.year, date1.month, date1.day);
    DateTime dateOnly2 = DateTime(date2.year, date2.month, date2.day);

    Duration difference = dateOnly2.difference(dateOnly1);
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all(5.0)),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Reminder(task: widget.task, aquarium: widget.aquarium)));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.task.title, style: const TextStyle(fontSize: 15, color: Colors.black)),
              daysBetween == 0 ?
              const Text('heute fällig',
                  style: TextStyle(fontSize: 10, color: Colors.black)):
              daysBetween == 1 ? const Text('fällig in 1 Tag',
                  style: TextStyle(fontSize: 10, color: Colors.black)):
              Text('fällig in $daysBetween Tagen',
                  style: const TextStyle(fontSize: 10, color: Colors.black))
            ],
          ),
        ));
  }
}
