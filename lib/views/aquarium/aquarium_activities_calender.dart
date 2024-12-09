import 'package:aquahelper/model/activity.dart';
import 'package:aquahelper/util/calender.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_activities_calender_viewmodel.dart';
import 'package:aquahelper/views/aquarium/forms/create_or_edit_activity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AquariumActivitiesCalendar extends StatelessWidget {
  final String aquariumId;

  const AquariumActivitiesCalendar({super.key, required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    double rowHeight = MediaQuery.sizeOf(context).height / 22;
    var viewModel = Provider.of<AquariumActivitiesCalenderViewModel>(context,
        listen: false);
    if (viewModel.aquariumId != aquariumId) {
      viewModel.init(aquariumId);
    }
    return ChangeNotifierProvider(
      create: (context) => AquariumActivitiesCalenderViewModel(),
      child: Consumer<AquariumActivitiesCalenderViewModel>(
        builder: (context, viewModel, child) => Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Aktivitäten-Kalender",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateOrEditActivity(
                              aquariumId: viewModel.aquariumId,
                              activity: Activity("", "", "", 0, "")),
                        ),
                      );
                      if (result != null) {
                        viewModel.getActivitiesFromDb();
                      }
                    },
                    icon: const Icon(Icons.add_circle,
                        size: 30, color: Colors.lightGreen),
                  ),
                ],
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
                    rowHeight: rowHeight,
                    firstDay: DateTime.utc(2010, 1, 1),
                    lastDay: DateTime.utc(2030, 1, 1),
                    focusedDay: viewModel.focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(viewModel.selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      viewModel.onDaySelected(selectedDay, focusedDay);
                      viewModel.selectedEvents.value =
                          viewModel.getEventsForDay(selectedDay);
                    },
                    eventLoader: viewModel.getEventsForDay,
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
                                tileColor: Colors.white,
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateOrEditActivity(
                                              aquariumId: viewModel.aquariumId,
                                              activity: value[index].activity),
                                    ),
                                  );
                                  if (result == true) {
                                    viewModel.getActivitiesFromDb();
                                  }
                                },
                                title: Text('${value[index]}'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
