import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../model/activity.dart';
import '../../../util/calender.dart';
import '../../../util/datastore.dart';
import 'create_or_edit_activities.dart';

class ActivitiesCalendar extends StatefulWidget {
  const ActivitiesCalendar({super.key, required this.aquariumId});

  final String aquariumId;

  @override
  State<ActivitiesCalendar> createState() => _ActivitiesCalendarState();
}

class _ActivitiesCalendarState extends State<ActivitiesCalendar> {
  late ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late LinkedHashMap<DateTime, List<Event>> kEvents;

  @override
  void initState() {
    super.initState();
    kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: (key) {
        return key.day * 1000000 + key.month * 10000 + key.year;
      },
    );
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    getActivitiesFromDb();
  }

  int getHashCodeForDateTime(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  void addEventToMap(DateTime day, Event event) {
    final events = kEvents[day] ?? [];
    events.add(event);
    setState(() {
      kEvents[day] = events;
    });
  }

  getActivitiesFromDb() {
    kEvents.clear();
    Datastore.db.getActivitiesForAquarium(widget.aquariumId).then((value) {
      for (Activity activity in value) {
        activity.activitites.split(",").forEach((element) {
          addEventToMap(DateTime.fromMillisecondsSinceEpoch(activity.date),
              Event(element, activity));
        });
      }
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Aktivitäten-Kalender",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2030, 1, 1),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedEvents.value = _getEventsForDay(selectedDay);
                  });
                },
                eventLoader: _getEventsForDay,
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
                startingDayOfWeek: StartingDayOfWeek.monday,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            tileColor: Colors.white,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateOrEditActivities(
                                      aquariumId: widget.aquariumId,
                                      activity: value[index].activity
                                  ),
                                ),
                              );
                              if (result != null) {
                                getActivitiesFromDb();
                              }
                            },
                            title: Text('${value[index]}'),
                          ),
                        );
                      },
                    );
                  },
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateOrEditActivities(
                              aquariumId: widget.aquariumId,
                              activity: Activity("", "", "", 0, "")
                          ),
                        ),
                      );
                      if (result != null) {
                        getActivitiesFromDb();
                      }
                    },
                    backgroundColor: Colors.lightGreen,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
