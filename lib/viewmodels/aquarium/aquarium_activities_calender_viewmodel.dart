import 'dart:collection';
import 'package:aquahelper/model/activity.dart';
import 'package:aquahelper/util/calender.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AquariumActivitiesCalenderViewModel extends ChangeNotifier {
  late ValueNotifier<List<Event>> selectedEvents;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  late LinkedHashMap<DateTime, List<Event>> kEvents;
  String aquariumId = "";

  AquariumActivitiesCalenderViewModel(){
    kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: (key) {
        return key.day * 1000000 + key.month * 10000 + key.year;
      },
    );
    selectedDay = focusedDay;
    selectedEvents = ValueNotifier(getEventsForDay(selectedDay!));
  }

  void init(String aquariumId) {
    this.aquariumId = aquariumId;
    getActivitiesFromDb();
  }

  void refresh() {
    getActivitiesFromDb();
  }

  void onDaySelected(calenderSelectedDay, calenderFocusedDay){
    selectedDay = calenderSelectedDay;
    focusedDay = calenderFocusedDay;
    notifyListeners();
  }

  int getHashCodeForDateTime(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  void addEventToMap(DateTime day, Event event) {
    final events = kEvents[day] ?? [];
    events.add(event);
    kEvents[day] = events;
    notifyListeners();
  }

  getActivitiesFromDb() async {
    kEvents.clear();
    await Datastore.db.getActivitiesForAquarium(aquariumId).then((value) {
      for (Activity activity in value) {
        activity.activities.split(",").forEach((element) {
          addEventToMap(DateTime.fromMillisecondsSinceEpoch(activity.date),
              Event(element, activity));
        });
      }
    });
    selectedEvents = ValueNotifier(getEventsForDay(selectedDay!));
    notifyListeners();
  }

  List<Event> getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }
}
