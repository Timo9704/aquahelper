import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../model/aquarium.dart';
import '../../../model/task.dart';
import '../../../util/datastore.dart';
import '../../../views/aquarium/aquarium_overview.dart';

class CreateOrEditReminderViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now().add(const Duration(minutes: 5));
  DateTime selectedDateInital = DateTime.now().add(const Duration(minutes: 5));
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool createMode = true;
  String? selectedTemplate;

  bool repeat = false;
  String selectedSchedule = '0';
  List<bool> selectedDays = List.filled(7, false);
  List<bool> previousSelectedDays = List.filled(7, false);
  final List<String> daysOfWeek = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
  TimeOfDay selectedTime = const TimeOfDay(hour: 0, minute: 0);

  late Task task;
  Aquarium aquarium;

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

  CreateOrEditReminderViewModel(this.aquarium, task) {
    if (task != null) {
      selectedSchedule = '0';
      titleController.text = task.title;
      descriptionController.text = task.description;
      selectedDays = stringToBoolList(task.scheduledDays);
      previousSelectedDays = stringToBoolList(task.scheduledDays);
      selectedSchedule = task.scheduled;
      task.scheduled == '1' ? repeat = true : repeat = false;
      selectedTime = TimeOfDay(
          hour: int.parse(task.scheduledTime.split(":")[0]),
          minute: int.parse(task.scheduledTime.split(":")[1]));
      selectedDate = DateTime.fromMillisecondsSinceEpoch(task.taskDate);
      selectedDateInital = DateTime.fromMillisecondsSinceEpoch(task.taskDate);
      createMode = false;
    }
  }

  List<bool> stringToBoolList(String str) {
    String trimmedStr = str.substring(1, str.length - 1);
    List<String> strList = trimmedStr.split(', ');
    List<bool> boolList =
        strList.map((s) => s.toLowerCase() == 'true').toList();

    return boolList;
  }

  void submitReminder(BuildContext context) {
    if (createMode) {
      if (repeat) {
        selectedDate = DateTime(9999, 12, 31, 00, 00);
      }
      Task task = Task(
        const Uuid().v4().toString(),
        aquarium.aquariumId,
        titleController.text,
        descriptionController.text,
        selectedDate.millisecondsSinceEpoch,
        selectedSchedule,
        selectedDays.toString(),
        "${selectedTime.hour}:${selectedTime.minute}",
      );
      Datastore.db.insertTask(task);

      if (repeat) {
        createRecurringNotification(
            selectedDays
                .asMap()
                .entries
                .where((entry) => entry.value)
                .map((entry) => entry.key + 1)
                .toList(),
            "${selectedTime.hour}:${selectedTime.minute}",
            task.title,
            task.description);
      } else {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: selectedDate.millisecondsSinceEpoch ~/ 1000,
                channelKey: "0",
                title: task.title,
                body: task.description),
            schedule: NotificationCalendar.fromDate(date: selectedDate));
      }
    } else {
      Task task = Task(
        this.task.taskId,
        aquarium.aquariumId,
        titleController.text,
        descriptionController.text,
        selectedDate.millisecondsSinceEpoch,
        selectedSchedule,
        selectedDays.toString(),
        "${selectedTime.hour}:${selectedTime.minute}",
      );
      Datastore.db.updateTask(aquarium, task);
      if (repeat) {
        cancelRecurringNotifications(previousSelectedDays
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => entry.key + 1)
            .toList());
        createRecurringNotification(
            selectedDays
                .asMap()
                .entries
                .where((entry) => entry.value)
                .map((entry) => entry.key + 1)
                .toList(),
            "${selectedTime.hour}:${selectedTime.minute}",
            task.title,
            task.description);
      } else {
        AwesomeNotifications()
            .cancel(selectedDateInital.millisecondsSinceEpoch ~/ 1000);
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: selectedDate.millisecondsSinceEpoch ~/ 1000,
                channelKey: "0",
                title: task.title,
                body: task.description),
            schedule: NotificationCalendar.fromDate(
                date: selectedDate, preciseAlarm: true, allowWhileIdle: true));
      }
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AquariumOverview(aquarium: aquarium)));
  }

  void createRecurringNotification(List<int> daysOfWeek, String time,
      String title, String description) async {
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    for (int dayOfWeek in daysOfWeek) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: (task.taskId + dayOfWeek.toString()).hashCode,
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
          allowWhileIdle: true,
          preciseAlarm: true,
        ),
      );
    }
  }

  void cancelRecurringNotifications(List<int> daysOfWeek) async {
    for (int dayOfWeek in daysOfWeek) {
      await AwesomeNotifications()
          .cancel((task.taskId + dayOfWeek.toString()).hashCode);
    }
  }

  void deleteReminder(BuildContext context) {
    Datastore.db.deleteTask(aquarium, task.taskId);
    AwesomeNotifications().cancelSchedule(task.taskDate ~/ 1000);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AquariumOverview(aquarium: aquarium)));
  }

  void presentDatePicker(BuildContext context) {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().add(const Duration(minutes: 5)),
      maxTime: DateTime(2100, 12, 31),
      onConfirm: (date) {
        selectedDate = date;
      },
      currentTime: DateTime.now(),
      locale: LocaleType.de,
    );
    notifyListeners();
  }
}