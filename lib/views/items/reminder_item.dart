import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/task.dart';
import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/viewmodels/items/reminder_item_viewmodel.dart';
import 'package:aquahelper/views/aquarium/forms/create_or_edit_reminder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReminderItem extends StatelessWidget {
  final Task task;
  final Aquarium aquarium;

  const ReminderItem({super.key, required this.task, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
        create: (context) => ReminderItemViewModel(task),
    child: Consumer<ReminderItemViewModel>(
        builder: (context, viewModel, child) => Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                elevation: WidgetStateProperty.all(2.0)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CreateOrEditReminder(task: task, aquarium: aquarium)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(task.title,
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
                viewModel.daysBetween == 0
                    ? const Text('heute fällig',
                        style: TextStyle(fontSize: 8, color: Colors.black))
                    : viewModel.daysBetween == 1
                        ? const Text('fällig in 1 Tag',
                            style: TextStyle(fontSize: 8, color: Colors.black))
                        : task.scheduled == '0'
                            ? Text('fällig in ${viewModel.daysBetween} Tagen',
                                style: const TextStyle(
                                    fontSize: 8, color: Colors.black))
                            : const Text("wiederkehrend",
                                style: TextStyle(
                                    fontSize: 8, color: Colors.black)),
              ],
            ),
          ),
        ),
      ),);
  }
}
