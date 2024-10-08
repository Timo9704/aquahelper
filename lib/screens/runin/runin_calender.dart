import 'dart:collection';

import 'package:aquahelper/screens/runin/runin_daytask.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/aquarium.dart';
import '../../util/datastore.dart';
import '../../util/runin_calender.dart';
import '../../util/scalesize.dart';
import '../aquarium/aquarium_overview.dart';

class RunInCalender extends StatefulWidget {
  final Aquarium aquarium;

  const RunInCalender({super.key, required this.aquarium});

  @override
  State<RunInCalender> createState() => _RunInCalenderState();
}

class _RunInCalenderState extends State<RunInCalender> {
  double textScaleFactor = 0;
  late ValueNotifier<List<Event>> _selectedEvents;
  late LinkedHashMap<DateTime, List<Event>> _events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _preSelectedDay;
  int runInDays = 1;
  double runInDaysPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDay = _focusedDay;
      _events = allRunInEvents(DateTime.fromMillisecondsSinceEpoch(widget.aquarium.runInStartDate));
      _selectedEvents = ValueNotifier(_events[_selectedDay] ?? []);
      calculateRunInDays();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.aquarium.runInStatus == 1 && ((DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(widget.aquarium.runInStartDate)).inDays) > 0)) {
        showEndOfRunIn();
      }
    });
  }

  Future<void> showEndOfRunIn() async {
    widget.aquarium.runInStatus = 0;
    await Datastore.db.updateAquarium(widget.aquarium);
    if (mounted){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Herzlichen Glückwunsch!"),
            content: const SizedBox(
              height: 120,
              child: Column(
                children: [
                  Text(
                      "Deine Einfahrphase ist nun erstmal abgeschlossen. Du kannst nun mit der regulären Pflege deines Aquariums beginnen. Hast du noch Fragen oder benötigst Hilfe?"),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey)),
                child: const Text("Zurück zur Übersicht"),
                onPressed: () =>
                {
                  Navigator.pop(context),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AquariumOverview(aquarium: widget.aquarium)),
                  ),
                },
              ),
            ],
            elevation: 0,
          );
        },
      );
  }
  }

  void calculateRunInDays() {
    DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(widget.aquarium.runInStartDate);
    DateTime currentDate = DateTime.now();
    runInDays = currentDate.difference(startDate).inDays + 1;
    runInDaysPercentage = runInDays / 60;
  }
  
  int calculateRunInDayFromSelectedDay(DateTime selectedDay) {
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(widget.aquarium.runInStartDate);
    return selectedDay.difference(startDate).inDays+1;
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text("6-Wochen Einfahrphase"),
          backgroundColor: Colors.lightGreen),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              children: [
                Text(
                  "Hier findest du alle wichtigen Termine und Aufgaben für die nächsten 6 Wochen deiner Einfahrphase. Klicke auf die Tage oder Aufgaben, um mehr zu erfahren.",
                  textAlign: TextAlign.left,
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Tag $runInDays von 60",
                                textScaler: TextScaler.linear(textScaleFactor),
                                style: const TextStyle(
                                    fontSize: 28, color: Colors.black)),
                            CircularProgressIndicator(
                              value: runInDaysPercentage,
                              backgroundColor: Colors.grey,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.lightGreen),
                              strokeWidth: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Flexible(flex: 1, child: Text("")),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child:
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(
                        DateTime.now().year, DateTime.now().month, 1),
                    lastDay: DateTime.utc(
                        DateTime.now().year, DateTime.now().month + 2, 31),
                    focusedDay: DateTime.now(),
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.grey,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(
                              1.0,
                              1.0,
                            ),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.lightGreen,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.white),
                      todayTextStyle: TextStyle(color: Colors.white),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle:
                          TextStyle(fontSize: 25, color: Colors.black),
                    ),
                    eventLoader: (day) {
                      return _events[day] ?? [];
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _preSelectedDay = _selectedDay;
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedEvents = ValueNotifier(_events[_selectedDay] ?? []);
                      });
                      if(_selectedEvents.value.isNotEmpty && selectedDay == _preSelectedDay) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RunInDayTask(day: calculateRunInDayFromSelectedDay(selectedDay), events: _events, startDate: DateTime.fromMillisecondsSinceEpoch(widget.aquarium.runInStartDate))));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
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
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RunInDayTask(day: calculateRunInDayFromSelectedDay(_selectedDay!), events: _events, startDate: DateTime.fromMillisecondsSinceEpoch(widget.aquarium.runInStartDate))))
                                },
                                title: Text('${value[index]}'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
