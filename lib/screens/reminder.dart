import 'package:aquahelper/screens/aquarium_overview.dart';
import 'package:aquahelper/util/dbhelper.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../model/aquarium.dart';
import '../model/task.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.task!.taskDate);
      selectedDateInital = DateTime.fromMillisecondsSinceEpoch(widget.task!.taskDate);
      createMode = false;
    }
  }

  void _submitReminder() {
    if(createMode) {
      Task task = Task(
          const Uuid().v4().toString(),
          widget.aquarium.aquariumId,
          _titleController.text,
          _descriptionController.text,
          selectedDate.millisecondsSinceEpoch);
      DBHelper.db.insertTask(task);

      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: selectedDate.millisecondsSinceEpoch ~/ 1000,
              channelKey: "0",
              title: task.title,
              body: task.description),
          schedule: NotificationCalendar.fromDate(date: selectedDate));
      }else{
          Task task = Task(
              widget.task!.taskId,
              widget.aquarium.aquariumId,
              _titleController.text,
              _descriptionController.text,
              selectedDate.millisecondsSinceEpoch);
          DBHelper.db.updateTask(task);
          AwesomeNotifications().cancel(selectedDateInital.millisecondsSinceEpoch ~/ 1000);
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: selectedDate.millisecondsSinceEpoch ~/ 1000,
                  channelKey: "0",
                  title: task.title,
                  body: task.description),
              schedule: NotificationCalendar.fromDate(date: selectedDate));
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  AquariumOverview(aquarium: widget.aquarium)));

  }

  void _deleteReminder() {
    if (widget.task != null) {
      DBHelper.db.deleteTask(widget.task!.taskId);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                const SizedBox(height: 20),
                Text(
                  'Datum und Uhrzeit: ${DateFormat('dd.MM.yyyy – kk:mm').format(selectedDate)}',
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen)),
                  onPressed: _presentDatePicker,
                  child: const Text('Datum und Uhrzeit wählen'),
                ),
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
    );
  }
}
