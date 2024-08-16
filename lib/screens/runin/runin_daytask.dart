import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../model/runin_daytask.dart';
import '../../util/runin_calender.dart';
import '../../util/scalesize.dart';
class RunInDayTask extends StatefulWidget {
  final int day;
  const RunInDayTask({super.key, required this.day});

  @override
  State<RunInDayTask> createState() => _RunInDayTaskState();
}

class _RunInDayTaskState extends State<RunInDayTask> {
  double textScaleFactor = 0;
  String infoText = "";
  String detailedInfoText = "";
  List<Event> eventsForDay = [];

  @override
  void initState() {
    super.initState();
    RunInDayTaskModel task = RunInDayTaskModel(1,"", "");
    task = task.getTaskById(widget.day, dayTasksData);
    infoText = task.runInDayDescription;
    detailedInfoText = task.runInDayDetailedDescription;

    // Lade die Events für den spezifischen Tag
    DateTime selectedDate = kToday.add(Duration(days: widget.day)); //
    if(widget.day == 1){
      selectedDate = kToday;
    }
    eventsForDay = kEvents[selectedDate] ?? [];
  }


  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text("6-Wochen Einfahrphase"),
          backgroundColor: Colors.lightGreen),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            children: [
              Text("Starten wir den ${widget.day}.ten Tag ...",
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              MarkdownBody(
                data: infoText,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Deine To-Do-Liste für heute:",
                        textScaler: TextScaler.linear(textScaleFactor),
                        style: const TextStyle(fontSize: 28, color: Colors.black)),
                    const SizedBox(height: 10),
                    ...eventsForDay.map((event) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          const Icon(Icons.check_box_outlined,
                              color: Colors.lightGreen),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(event.title,
                                textScaler: TextScaler.linear(textScaleFactor),
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MarkdownBody(
                  data: detailedInfoText,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, color: Colors.black),
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
