import 'dart:collection';
import 'package:aquahelper/model/aquarium.dart';
import 'package:flutter/material.dart';

import '../../../util/datastore.dart';
import '../../../util/runin_calender.dart';
import '../../../views/aquarium/aquarium_overview.dart';

class RunInCalenderViewModel extends ChangeNotifier {
  Aquarium aquarium;
  late ValueNotifier<List<Event>> selectedEvents;
  late LinkedHashMap<DateTime, List<Event>> events;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? preSelectedDay;
  int runInDays = 1;
  double runInDaysPercentage = 0.0;

  RunInCalenderViewModel(BuildContext context, this.aquarium) {
    selectedDay = focusedDay;
    events = allRunInEvents(DateTime.fromMillisecondsSinceEpoch(aquarium.runInStartDate));
    selectedEvents = ValueNotifier(events[selectedDay] ?? []);
    calculateRunInDays();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(aquarium.runInStatus == 1 && ((DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(aquarium.runInStartDate)).inDays) > 0)) {
        showEndOfRunIn(context);
      }
    });
  }

  Future<void> showEndOfRunIn(BuildContext context) async {
    aquarium.runInStatus = 0;
    await Datastore.db.updateAquarium(aquarium);
    if (context.mounted){
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
                            AquariumOverview(aquarium: aquarium)),
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
    DateTime.fromMillisecondsSinceEpoch(aquarium.runInStartDate);
    DateTime currentDate = DateTime.now();
    runInDays = currentDate.difference(startDate).inDays + 1;
    runInDaysPercentage = runInDays / 60;
  }

  int calculateRunInDayFromSelectedDay(DateTime selectedDay) {
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(aquarium.runInStartDate);
    return selectedDay.difference(startDate).inDays+1;
  }


}
