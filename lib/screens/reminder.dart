import 'package:aquahelper/screens/aquarium_overview.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../model/aquarium.dart';
import '../model/task.dart';
import '../util/datastore.dart';

class Reminder extends StatefulWidget {
  final Aquarium aquarium;
  final Task? task;

  const Reminder({super.key, required this.task, required this.aquarium});

  @override
  ReminderState createState() => ReminderState();
}

class ReminderState extends State<Reminder> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now().add(const Duration(minutes: 5));
  DateTime selectedDateInital = DateTime.now().add(const Duration(minutes: 5));
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool createMode = true;
  String? _selectedTemplate;

  bool _repeat = false;
  String _selectedSchedule = '0';
  List<bool> _selectedDays = List.filled(7, false);
  List<bool> _previousSelectedDays = List.filled(7, false);
  final List<String> _daysOfWeek = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
  TimeOfDay selectedTime = const TimeOfDay(hour: 0, minute: 0);

  Map<String, String> templates = {
    'Wasserwechsel': 'Wasserwechsel für ',
    'Fütterung': 'Fütterung für ',
    'Filterreinigung': 'Filterreinigung für ',
    'Pflanzenpflege': 'Pflanzenpflege für ',
    'Medikamentengabe': 'Medikamentengabe für ',
    'Sonstiges': 'Sonstiges für '
  };

  List<String> templatesDropdown = [
    'Wasserwechsel',
    'Fütterung',
    'Filterreinigung',
    'Pflanzenpflege',
    'Medikamentengabe',
    'Sonstiges'
  ];

  @override
  void initState() {
    super.initState();
    _selectedSchedule = '0';
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDays = stringToBoolList(widget.task!.scheduledDays);
      _previousSelectedDays = stringToBoolList(widget.task!.scheduledDays);
      _selectedSchedule = widget.task!.scheduled;
      widget.task!.scheduled == '1' ? _repeat = true : _repeat = false;
      selectedTime = TimeOfDay(
          hour: int.parse(widget.task!.scheduledTime.split(":")[0]),
          minute: int.parse(widget.task!.scheduledTime.split(":")[1]));
      selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.task!.taskDate);
      selectedDateInital = DateTime.fromMillisecondsSinceEpoch(widget.task!.taskDate);
      createMode = false;
    }
  }

  List<bool> stringToBoolList(String str) {
    String trimmedStr = str.substring(1, str.length - 1);
    List<String> strList = trimmedStr.split(', ');
    List<bool> boolList = strList.map((s) => s.toLowerCase() == 'true').toList();

    return boolList;
  }


  void _submitReminder() {
    if(createMode) {
      if(_repeat){
        selectedDate = DateTime(9999, 12, 31, 00, 00);
      }
      Task task = Task(
          const Uuid().v4().toString(),
          widget.aquarium.aquariumId,
          _titleController.text,
          _descriptionController.text,
          selectedDate.millisecondsSinceEpoch,
          _selectedSchedule,
          _selectedDays.toString(),
          "${selectedTime.hour}:${selectedTime.minute}",
      );
      Datastore.db.insertTask(task);

      if(_repeat) {
        createRecurringNotification(_selectedDays
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => entry.key + 1)
            .toList(),
            "${selectedTime.hour}:${selectedTime.minute}", task.title,
            task.description);
        }else {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: selectedDate.millisecondsSinceEpoch ~/ 1000,
                  channelKey: "0",
                  title: task.title,
                  body: task.description),
              schedule: NotificationCalendar.fromDate(date: selectedDate));
        }
      }else{
          Task task = Task(
              widget.task!.taskId,
              widget.aquarium.aquariumId,
              _titleController.text,
              _descriptionController.text,
              selectedDate.millisecondsSinceEpoch,
              _selectedSchedule,
              _selectedDays.toString(),
              "${selectedTime.hour}:${selectedTime.minute}",
          );
          Datastore.db.updateTask(widget.aquarium, task);
          if(_repeat){
            cancelRecurringNotifications(_previousSelectedDays.asMap().entries.where((entry) => entry.value).map((entry) => entry.key+1).toList());
            createRecurringNotification(_selectedDays.asMap().entries.where((entry) => entry.value).map((entry) => entry.key+1).toList(), "${selectedTime.hour}:${selectedTime.minute}", task.title,
                task.description);
          }else {
            AwesomeNotifications().cancel(
                selectedDateInital.millisecondsSinceEpoch ~/ 1000);
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: selectedDate.millisecondsSinceEpoch ~/ 1000,
                    channelKey: "0",
                    title: task.title,
                    body: task.description),
                schedule: NotificationCalendar.fromDate(date: selectedDate));
          }
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  AquariumOverview(aquarium: widget.aquarium)));
  }

  void createRecurringNotification(List<int> daysOfWeek, String time, String title, String description) async {
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    for (int dayOfWeek in daysOfWeek) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: (widget.task!.taskId+dayOfWeek.toString()).hashCode,
          channelKey: "0",
          title: title,
          body: description,
        ),
        schedule: NotificationCalendar(
          weekday: dayOfWeek,
          hour: hour,
          minute: minute,
          second: 0,
          repeats: true,
          allowWhileIdle: true
        ),
      );
    }
  }

  void cancelRecurringNotifications(List<int> daysOfWeek) async {
    for (int dayOfWeek in daysOfWeek) {
      await AwesomeNotifications().cancel((widget.task!.taskId+dayOfWeek.toString()).hashCode);
    }
  }

  void _deleteReminder() {
    if (widget.task != null) {
      Datastore.db.deleteTask(widget.aquarium, widget.task!.taskId);
      AwesomeNotifications().cancelSchedule(widget.task!.taskDate ~/ 1000);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  AquariumOverview(aquarium: widget.aquarium)));
    }
  }

  void _presentDatePicker() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().add(const Duration(minutes: 5)),
      maxTime: DateTime(2100, 12, 31),
      onConfirm: (date) {
        setState(() {
          selectedDate = date;
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.de,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neue Erinnerung erstellen'),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        children: [
        Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  const Text("Vorlage wählen:",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedTemplate,
                    hint: const Text('Wähle deine Vorlage' ,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.normal)),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTemplate = newValue;
                        _titleController.text = templates.entries.firstWhere((element) => element.key == newValue).key;
                        _descriptionController.text = templates[newValue]! + widget.aquarium.name;
                      });
                    },
                    items: templatesDropdown.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ],),
                TextFormField(
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.grey,
                      floatingLabelStyle: TextStyle(color: Colors.lightGreen),
                      labelText: 'Titel'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte einen Titel eingeben';
                    }
                    return null;
                  },
                  controller: _titleController,
                ),
                TextFormField(
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.grey,
                      floatingLabelStyle: TextStyle(color: Colors.lightGreen),
                      labelText: 'Beschreibung'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte einen Titel eingeben';
                    }
                    return null;
                  },
                  controller: _descriptionController,
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
                                contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                horizontalTitleGap: 0,
                                dense: true,
                                title: const Text('Einmalig'),
                                leading: Radio<String>(
                                  activeColor: Colors.lightGreen,
                                  value: '0',
                                  groupValue: _selectedSchedule,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedSchedule = value!;
                                      _repeat = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                title: const Text('Wiederholungen'),
                                contentPadding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                selectedColor: Colors.lightGreen,
                                horizontalTitleGap: 0,
                                dense: true,
                                leading: Radio<String>(
                                  activeColor: Colors.lightGreen,
                                  value: '1',
                                  visualDensity: VisualDensity.compact,
                                  groupValue: _selectedSchedule,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedSchedule = value!;
                                      _repeat = true;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_repeat) // Zeige die Wochentage in einer Reihe und verberge den Button für Datum und Uhrzeit
                          Column(
                            children: [
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List<Widget>.generate(7, (int index) {
                                    return FilterChip(
                                      padding: const EdgeInsets.all(2.0),
                                      label: Text(_daysOfWeek[index]),
                                      selected: _selectedDays[index],
                                      onSelected: (bool selected) {
                                        setState(() {
                                          _selectedDays[index] = selected;
                                        });
                                      },
                                      backgroundColor: Colors.grey,
                                      selectedColor: Colors.lightGreen,
                                      checkmarkColor: Colors.transparent,
                                      showCheckmark: false,
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Wiederholung: ${_selectedDays.every((selected) => !selected) ? 'Keine Tage ausgewählt' :
                                    '${_selectedDays.asMap().entries.where((entry) => entry.value).map((entry) => _daysOfWeek[entry.key]).join(', ')} um ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} Uhr'}',
                              ),
                              const SizedBox(height: 10),
                              if (_repeat) // Nur die Uhrzeit anzeigen, wenn "Einmalig" ausgewählt ist
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(Colors.lightGreen)),
                                  onPressed: () async {
                                    final TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime: selectedTime,

                                      builder: (context, child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                          child: child ?? Container(),
                                        );
                                      },
                                    );
                                    if (picked != null && picked != selectedTime) {
                                      setState(() {
                                        selectedTime = picked;
                                      });
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
                if (!_repeat)
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightGreen)),
                    onPressed: _presentDatePicker,
                    child: const Text('Datum und Uhrzeit wählen'),
                  ),
                const SizedBox(height: 10),
                if (!_repeat)
                  Text(
                    'Datum und Uhrzeit: ${DateFormat('dd.MM.yyyy – kk:mm')
                        .format(selectedDate)}',
                    textAlign: TextAlign.center,
                  ),
                if(!_repeat)
                  const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    if(!createMode)
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2 - 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: _deleteReminder,
                          child: const Text('Löschen'),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2 - 20,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.lightGreen)),
                          onPressed: _submitReminder,
                          child: const Text('Speichern'),
                        ),
                      )
                    ]),
              ]),
        ),
      ),
        ]),
    );
  }
}
