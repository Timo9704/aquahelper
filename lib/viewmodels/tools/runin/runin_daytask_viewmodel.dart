import 'dart:collection';
import 'dart:io';

import 'package:aquahelper/util/runin_calender.dart';
import 'package:flutter/material.dart';

import '../../../model/runin_daytask.dart';

class RunInDayTaskViewModel extends ChangeNotifier {
  final DateTime startDate;
  final int day;
  final LinkedHashMap<DateTime, List<Event>> events;
  String infoText = "";
  String detailedInfoText = "";
  List<Event> eventsForDay = [];

  RunInDayTaskViewModel(this.startDate, this.day, this.events) {
    RunInDayTaskModel task = RunInDayTaskModel(1,"", "");
    task = task.getTaskById(day, dayTasksData);
    infoText = task.runInDayDescription;
    detailedInfoText = task.runInDayDetailedDescription;

    DateTime selectedDate = startDate.add(Duration(days: day)); //
    if(day == 1){
      selectedDate = DateTime.now();
    }
    eventsForDay = events[selectedDate] ?? [];
  }

}
