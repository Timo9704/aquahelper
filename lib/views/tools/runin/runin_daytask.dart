import 'dart:collection';

import 'package:aquahelper/util/runin_calender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '../../../util/scalesize.dart';
import '../../../viewmodels/tools/runin/runin_daytask_viewmodel.dart';

class RunInDayTask extends StatelessWidget {
  final DateTime startDate;
  final int day;
  final LinkedHashMap<DateTime, List<Event>> events;

  const RunInDayTask(
      {super.key,
      required this.startDate,
      required this.day,
      required this.events});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => RunInDayTaskViewModel(startDate, day, events),
      child: Consumer<RunInDayTaskViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
              title: const Text("6-Wochen Einfahrphase"),
              backgroundColor: Colors.lightGreen),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  Text("Starten wir den ${viewModel.day}.ten Tag ...",
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  MarkdownBody(
                    data: viewModel.infoText,
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
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                        const SizedBox(height: 10),
                        ...viewModel.eventsForDay.map((event) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_box_outlined,
                                      color: Colors.lightGreen),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Text(event.title,
                                        textScaler:
                                            TextScaler.linear(textScaleFactor),
                                        style: const TextStyle(
                                            fontSize: 14,
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
                      data: viewModel.detailedInfoText,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
