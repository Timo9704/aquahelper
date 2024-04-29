import 'package:aquahelper/screens/runin/runin_daytask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../util/runin_calender.dart';

class RunInCalender extends StatefulWidget {
  const RunInCalender({super.key});

  @override
  State<RunInCalender> createState() => _RunInCalenderState();
}

class _RunInCalenderState extends State<RunInCalender> {
  late ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("60-Tage Einfahrphase"),
          backgroundColor: Colors.lightGreen),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Dein Überblick",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              const Text("Hier findest du alle wichtigen Termine und Aufgaben für die nächsten 60-Tage deiner Einfahrphase.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black)),
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Tag 1 von 60",
                              style:
                              TextStyle(fontSize: 25, color: Colors.black)),
                          CircularProgressIndicator(
                            value: 0.3,
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightGreen),
                            strokeWidth: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(child: Text(""), flex: 1),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  //border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TableCalendar(
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
                          offset: const Offset(
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
                    titleTextStyle: TextStyle(
                        fontSize: 25,
                        color: Colors.black),
                  ),
                  eventLoader: _getEventsForDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));// update `_focusedDay` here as well
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
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
                            onTap: () => print('${value[index]}'),
                            title: Text('${value[index]}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RunInDayTask()))
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Starte die Einlaufphase jetzt!",
                        style: TextStyle(fontSize: 20)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
