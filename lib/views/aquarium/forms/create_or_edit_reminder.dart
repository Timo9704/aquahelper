import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/task.dart';
import 'package:aquahelper/viewmodels/aquarium/forms/create_or_edit_reminder_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateOrEditReminder extends StatelessWidget {
  final Aquarium aquarium;
  final Task? task;

  const CreateOrEditReminder({super.key, required this.aquarium, this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateOrEditReminderViewModel(aquarium, task),
      child: Consumer<CreateOrEditReminderViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Neue Erinnerung erstellen'),
            backgroundColor: Colors.lightGreen,
          ),
          body: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Vorlage wählen:",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black)),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: viewModel.selectedTemplate,
                            hint: const Text('Wähle deine Vorlage',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                            onChanged: (newValue) {
                              viewModel.selectedTemplate = newValue;
                              viewModel.titleController.text = viewModel
                                  .templates.entries
                                  .firstWhere(
                                      (element) => element.key == newValue)
                                  .key;
                              viewModel.descriptionController.text =
                                  viewModel.templates[newValue]! +
                                      viewModel.aquarium.name;
                            },
                            items: viewModel.templatesDropdown
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            fillColor: Colors.grey,
                            floatingLabelStyle:
                                TextStyle(color: Colors.lightGreen),
                            labelText: 'Titel'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte einen Titel eingeben';
                          }
                          return null;
                        },
                        controller: viewModel.titleController,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            fillColor: Colors.grey,
                            floatingLabelStyle:
                                TextStyle(color: Colors.lightGreen),
                            labelText: 'Beschreibung'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte einen Titel eingeben';
                          }
                          return null;
                        },
                        controller: viewModel.descriptionController,
                      ),
                      const SizedBox(height: 10),
                      ExpansionTile(
                        title: const Text('Wiederholungen & Zeitplan'),
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      horizontalTitleGap: 0,
                                      dense: true,
                                      title: const Text('Einmalig'),
                                      leading: Radio<String>(
                                        activeColor: Colors.lightGreen,
                                        value: '0',
                                        groupValue: viewModel.selectedSchedule,
                                        visualDensity: VisualDensity.compact,
                                        onChanged: (String? value) {
                                          viewModel.setRepeat(false, value!);
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ListTile(
                                      title: const Text('Wiederholungen'),
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      selectedColor: Colors.lightGreen,
                                      horizontalTitleGap: 0,
                                      dense: true,
                                      leading: Radio<String>(
                                        activeColor: Colors.lightGreen,
                                        value: '1',
                                        visualDensity: VisualDensity.compact,
                                        groupValue: viewModel.selectedSchedule,
                                        onChanged: (String? value) {
                                          viewModel.setRepeat(true, value!);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (viewModel.repeat)
                                Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    Wrap(
                                      spacing: -3.0,
                                      children:
                                          List<Widget>.generate(7, (int index) {
                                        return FilterChip(
                                          padding: const EdgeInsets.all(2.0),
                                          label:
                                              Text(viewModel.daysOfWeek[index]),
                                          selected:
                                              viewModel.selectedDays[index],
                                          onSelected: (bool selected) {
                                            viewModel.setSelectedDays(index, selected);
                                          },
                                          backgroundColor: Colors.grey,
                                          selectedColor: Colors.lightGreen,
                                          checkmarkColor: Colors.white,
                                          showCheckmark: false,
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Wiederholung: ${viewModel.selectedDays.every((selected) => !selected) ? 'Keine Tage ausgewählt' : '${viewModel.selectedDays.asMap().entries.where((entry) => entry.value).map((entry) => viewModel.daysOfWeek[entry.key]).join(', ')} um ${viewModel.selectedTime.hour.toString().padLeft(2, '0')}:${viewModel.selectedTime.minute.toString().padLeft(2, '0')} Uhr'}',
                                    ),
                                    const SizedBox(height: 10),
                                    if (viewModel.repeat)
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.lightGreen)),
                                        onPressed: () async {
                                          final TimeOfDay? picked =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: viewModel.selectedTime,
                                            builder: (context, child) {
                                              return MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        alwaysUse24HourFormat:
                                                            true),
                                                child: child ?? Container(),
                                              );
                                            },
                                          );
                                          if (picked != null &&
                                              picked !=
                                                  viewModel.selectedTime) {
                                            viewModel.selectedTime = picked;
                                          }
                                        },
                                        child: const Text('Uhrzeit wählen'),
                                      ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (!viewModel.repeat)
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.lightGreen)),
                          onPressed: () => viewModel.presentDatePicker(context),
                          child: const Text('Datum und Uhrzeit wählen'),
                        ),
                      const SizedBox(height: 10),
                      if (!viewModel.repeat)
                        Text(
                          'Datum und Uhrzeit: ${DateFormat('dd.MM.yyyy – kk:mm').format(viewModel.selectedDate)}',
                          textAlign: TextAlign.center,
                        ),
                      if (!viewModel.repeat) const SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (!viewModel.createMode)
                              SizedBox(
                                width:
                                    MediaQuery.sizeOf(context).width / 2 - 20,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: () =>
                                      viewModel.deleteReminder(context),
                                  child: const Text('Löschen'),
                                ),
                              ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2 - 20,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.lightGreen)),
                                onPressed: () =>
                                    viewModel.submitReminder(context),
                                child: const Text('Speichern'),
                              ),
                            ),
                          ]),
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
