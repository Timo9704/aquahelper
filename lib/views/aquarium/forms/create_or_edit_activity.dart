import 'package:aquahelper/model/activity.dart';
import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/viewmodels/aquarium/forms/create_or_edit_activity_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';


class CreateOrEditActivity extends StatelessWidget {
  final String aquariumId;
  final Activity activity;

  const CreateOrEditActivity(
      {super.key, required this.aquariumId, required this.activity});

  Future<void> selectDate(
      BuildContext context, CreateOrEditActivityViewModel viewModel) async {
    DateTime? tempSelectedDate = viewModel.selectedDate;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.white,
        title: const Text('Wähle ein Datum'),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
          return Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  focusedDay: tempSelectedDate ?? DateTime.now(),
                  startingDayOfWeek: StartingDayOfWeek.monday,
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
                  selectedDayPredicate: (day) {
                    return isSameDay(tempSelectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setStateDialog(() {
                      tempSelectedDate = selectedDay;
                    });
                  },
                ),
              ),
            ),
          );
        }),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightGreen,
            ),
            child: const Text('OK'),
            onPressed: () {
              if (tempSelectedDate != null) {
                viewModel.selectedDate = tempSelectedDate;
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => CreateOrEditActivityViewModel(activity, aquariumId),
      child: Consumer<CreateOrEditActivityViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text("Aktivität erstellen"),
            backgroundColor: Colors.lightGreen,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welche Aufgaben hast du erledigt?",
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 5.0,
                            children: viewModel.tags
                                .map((tag) => FilterChip(
                                      label: Text(tag,
                                          textScaler: TextScaler.linear(
                                              textScaleFactor),
                                          style: const TextStyle(fontSize: 12)),
                                      selected:
                                          viewModel.selectedTags.contains(tag),
                                      backgroundColor: Colors.white,
                                      selectedColor: Colors.lightGreen,
                                      checkmarkColor: Colors.white,
                                      showCheckmark: false,
                                      onSelected: (selected) => viewModel.onTagSelected(tag)
                                    ))
                                .toList(),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: viewModel.customTagController,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    hintText: "eigene Aufgabe hinzufügen",
                                    hintStyle: TextStyle(fontSize: 18),
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add,
                                    color: Colors.lightGreen, size: 30),
                                onPressed: () => viewModel.onAddCustomTag(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Notizen:",
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                          TextFormField(
                            maxLines: 5,
                            cursorColor: Colors.black,
                            controller: viewModel.noteController,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText:
                                  "Hier kannst du Notizen zu deiner Aktivität eintragen.",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => selectDate(context, viewModel),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),),
                    child: Text(
                      viewModel.selectedDate == null
                          ? 'Wähle ein Datum'
                          : 'Datum: ${DateFormat('dd.MM.yyyy').format(viewModel.selectedDate!)}',
                      textScaler: TextScaler.linear(textScaleFactor),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  viewModel.createMode
                      ? ElevatedButton(
                          onPressed: () => viewModel.saveActivity(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreen,
                              padding: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text(
                            "Aktivität speichern",
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(fontSize: 18),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  viewModel.deleteActivity(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                "Löschen",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  viewModel.updateActivity(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Aktualisieren",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
