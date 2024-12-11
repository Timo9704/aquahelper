import 'package:aquahelper/model/task.dart';
import 'package:flutter/material.dart';

class ReminderItemViewModel extends ChangeNotifier {
  late Task task;
  int daysBetween = 0;
  int epoch1 = 0;
  int epoch2 = 0;

  ReminderItemViewModel(this.task) {
    epoch1 = DateTime.now().millisecondsSinceEpoch;
    epoch2 = task.taskDate;
    calculateDaysBetweenEpochs(epoch1, epoch2);
  }

  void calculateDaysBetweenEpochs(int epoch1, int epoch2) {
    DateTime date1 = DateTime.fromMillisecondsSinceEpoch(epoch1);
    DateTime date2 = DateTime.fromMillisecondsSinceEpoch(epoch2);

    DateTime dateOnly1 = DateTime(date1.year, date1.month, date1.day);
    DateTime dateOnly2 = DateTime(date2.year, date2.month, date2.day);

    Duration difference = dateOnly2.difference(dateOnly1);
    daysBetween = difference.inDays;
    notifyListeners();
  }

  int getUpdatedDaysBetween(epoch1, epoch2) {
    DateTime date1 = DateTime.fromMillisecondsSinceEpoch(epoch1);
    DateTime date2 = DateTime.fromMillisecondsSinceEpoch(epoch2);

    DateTime dateOnly1 = DateTime(date1.year, date1.month, date1.day);
    DateTime dateOnly2 = DateTime(date2.year, date2.month, date2.day);

    Duration difference = dateOnly2.difference(dateOnly1);
    return difference.inDays;
  }
}