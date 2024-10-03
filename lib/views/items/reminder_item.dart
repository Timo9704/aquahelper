import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/aquarium.dart';
import '../../model/task.dart';
import '../../screens/reminder.dart';
import '../../viewmodels/items/reminder_item_viewmodel.dart';

class ReminderItem extends StatelessWidget {
  final Task task;
  final Aquarium aquarium;

  const ReminderItem({super.key, required this.task, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReminderItemViewModel(),
      child: Consumer<ReminderItemViewModel>(
        builder: (context, viewModel, child) => Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                elevation: MaterialStateProperty.all(2.0)),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Reminder(task: task, aquarium: aquarium)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(task.title,
                    style: const TextStyle(fontSize: 15, color: Colors.black)),
                viewModel.daysBetween == 0
                    ? const Text('heute fällig',
                        style: TextStyle(fontSize: 10, color: Colors.black))
                    : viewModel.daysBetween == 1
                        ? const Text('fällig in 1 Tag',
                            style: TextStyle(fontSize: 10, color: Colors.black))
                        : task.scheduled == '0'
                            ? Text('fällig in ${viewModel.daysBetween} Tagen',
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.black))
                            : const Text("wiederkehrend",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
