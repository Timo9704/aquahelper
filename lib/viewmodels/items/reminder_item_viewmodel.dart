import 'package:flutter/material.dart';

class ReminderItemViewModel extends ChangeNotifier {
  int daysBetween = 0;
  int epoch1 = 0;
  int epoch2 = 0;

  void init(int epoch1, int epoch2) {
    this.epoch1 = epoch1;
    this.epoch2 = epoch2;
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
}
