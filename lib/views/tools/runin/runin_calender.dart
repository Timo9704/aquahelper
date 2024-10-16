import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/runin_calender.dart';
import 'package:aquahelper/views/tools/runin/runin_daytask.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';

import '../../../util/scalesize.dart';
import '../../../viewmodels/tools/runin/runin_calender_viewmodel.dart';

class RunInCalender extends StatelessWidget {
  final Aquarium aquarium;

  const RunInCalender({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => RunInCalenderViewModel(context, aquarium),
      child: Consumer<RunInCalenderViewModel>(
        builder: (context, viewModel, child) => Scaffold(
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
                                Text("Tag ${viewModel.runInDays} von 60",
                                    textScaler:
                                        TextScaler.linear(textScaleFactor),
                                    style: const TextStyle(
                                        fontSize: 28, color: Colors.black)),
                                CircularProgressIndicator(
                                  value: viewModel.runInDaysPercentage,
                                  backgroundColor: Colors.grey,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
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
                  child: Container(
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
                          lastDay: DateTime.utc(DateTime.now().year,
                              DateTime.now().month + 2, 31),
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
                            return viewModel.events[day] ?? [];
                          },
                          selectedDayPredicate: (day) {
                            return isSameDay(viewModel.selectedDay, day);
                          },
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          onDaySelected: (selectedDay, focusedDay) {
                            viewModel.preSelectedDay = viewModel.selectedDay;
                            viewModel.selectedDay = selectedDay;
                            viewModel.focusedDay = focusedDay;
                            viewModel.selectedEvents.value =
                                viewModel.events[viewModel.selectedDay] ?? [];
                            if (viewModel.selectedEvents.value.isNotEmpty &&
                                selectedDay == viewModel.preSelectedDay) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RunInDayTask(
                                          day: viewModel
                                              .calculateRunInDayFromSelectedDay(
                                                  selectedDay),
                                          events: viewModel.events,
                                          startDate: DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  aquarium.runInStartDate))));
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ValueListenableBuilder<List<Event>>(
                            valueListenable: viewModel.selectedEvents,
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
                                                builder: (context) => RunInDayTask(
                                                    day: viewModel
                                                        .calculateRunInDayFromSelectedDay(
                                                            viewModel
                                                                .selectedDay!),
                                                    events: viewModel.events,
                                                    startDate: DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            aquarium
                                                                .runInStartDate))))
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
        ),
      ),
    );
  }
}
