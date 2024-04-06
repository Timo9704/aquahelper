
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/aquarium.dart';
import '../model/components/filter.dart';
import '../model/components/heater.dart';
import '../model/components/lighting.dart';
import '../model/custom_timer.dart';
import '../model/measurement.dart';
import '../model/task.dart';
import '../model/user_settings.dart';
import 'datastore.dart';

class FirebaseHelper{
    static final FirebaseHelper db = FirebaseHelper._();
    FirebaseHelper._();

    FirebaseDatabase database = FirebaseDatabase.instance;

    User? user = FirebaseAuth.instance.currentUser;

    initializeUser(User user) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user.uid}');
      ref.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        if (data == null) {
          ref.set({
            "email": user.email,
            "created": DateTime.now().millisecondsSinceEpoch,
          });
        }
      });
    }

    Future<List<Aquarium>> getAllAquariums() async {
      List<Aquarium> aquariums = [];
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tanks');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;

      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value['aquariumId'] = key;
          Aquarium aquarium = Aquarium.fromMap(Map<String, dynamic>.from(value));
          aquariums.add(aquarium);
        });
      }
      aquariums.sort((a, b) => a.name.compareTo(b.name));
      return aquariums;
    }

    insertAquarium(Aquarium aquarium) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tanks/${aquarium.aquariumId}');
      await ref.set(aquarium.toFirebaseMap());
    }

    updateAquarium(Aquarium aquarium) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tanks/${aquarium.aquariumId}');
      await ref.update(aquarium.toFirebaseMap());
    }

    deleteAquarium(String aquariumId) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tanks/$aquariumId');
      await ref.remove();
    }


    //-------------------------Methods for Measurement-object-----------------------//
    Future<List<Measurement>> getMeasurementsForAquarium(String aquariumId) async {
      List<Measurement> measurements = [];
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/measurements/$aquariumId/');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;

      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value['measurementId'] = key;
          value['aquariumId'] = aquariumId;
          Measurement measurement = Measurement.fromFirebaseMap(Map<String, dynamic>.from(value));
          measurements.add(measurement);
        });
      }
      measurements.sort((a, b) => b.measurementDate.compareTo(a.measurementDate));
      measurements = measurements.reversed.toList();
      return measurements;
    }

    insertMeasurement(Measurement measurement) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/measurements/${measurement.aquariumId}/${measurement.measurementId}');
      await ref.set(measurement.toFirebaseMap());
    }

    updateMeasurement(Measurement measurement) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/measurements/${measurement.aquariumId}/${measurement.measurementId}');
      await ref.update(measurement.toFirebaseMap());
    }

    deleteMeasurement(String aquariumId, String measurementId) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/measurements/$aquariumId/$measurementId');
      await ref.remove();
    }

    getSortedMeasurmentsList(Aquarium aquarium) async {
      List<Measurement> list = await getMeasurementsForAquarium(aquarium.aquariumId);
      list.sort((a, b) => a.measurementDate.compareTo(b.measurementDate));
      List<Measurement> listReversed = list.reversed.toList();
      return listReversed;
    }

    Future<Measurement> getMeasurementById(String aquariumId, String measurementId) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/measurements/$aquariumId/$measurementId/');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;

      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items['measurementId'] = measurementId;
        items['aquariumId'] = aquariumId;
        return Measurement.fromFirebaseMap(Map<String, dynamic>.from(items));
      }
      throw Exception('Measurement not found');
    }

    getMeasurementsByInterval(String aquariumId, int intervalStart, int endInterval) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/measurements/$aquariumId/');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      List<Measurement> list = [];
      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value['measurementId'] = key;
          value['aquariumId'] = aquariumId;
          Measurement measurement = Measurement.fromFirebaseMap(Map<String, dynamic>.from(value));
          if(measurement.measurementDate >= endInterval && measurement.measurementDate <= intervalStart){
            list.add(measurement);
          }
        });
        list.sort((a, b) => a.measurementDate.compareTo(b.measurementDate));
      }
      return list;
    }

    getMeasurementAmountByAllTime() async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/measurements/');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      List<Measurement> list = [];
      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value.forEach((key, value) {
            value['measurementId'] = key;
            value['aquariumId'] = key;
            Measurement measurement = Measurement.fromFirebaseMap(Map<String, dynamic>.from(value));
            list.add(measurement);
          });
        });
      }
      return list.length;
    }

    getMeasurementAmountByLast30Days(int intervalStart, int endInterval) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/measurements/');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      List<Measurement> list = [];
      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value.forEach((key, value) {
            value['measurementId'] = key;
            value['aquariumId'] = key;
            Measurement measurement = Measurement.fromFirebaseMap(Map<String, dynamic>.from(value));
            if(measurement.measurementDate >= endInterval && measurement.measurementDate <= intervalStart){
              list.add(measurement);
            }
          });
        });
      }
      return list.length;
    }

    //-------------------------Methods for Task-object-----------------------//

    insertTask(Task task) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tasks/${task.aquariumId}/${task.taskId}');
      await ref.set(task.toFirebaseMap());
    }

    updateTask(Aquarium aquarium, Task task) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tasks/${aquarium.aquariumId}/${task.taskId}');
      await ref.update(task.toFirebaseMap());
    }

    getTasksForCurrentDayForAquarium(String aquariumId) async {
      DateTime now = DateTime.now();
      DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59);
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tasks/$aquariumId/');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      List<Task> list = [];
      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value['taskId'] = key;
          Task task = Task.fromMap(Map<String, dynamic>.from(value));
          if(task.taskDate >= now.millisecondsSinceEpoch && task.taskDate <= endOfDay.millisecondsSinceEpoch && task.aquariumId == aquariumId){
            list.add(task);
          }
        });
      }
      return list;
    }

    getAllTasksForAquarium(Aquarium aquarium) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tasks');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      List<Task> list = [];
      if (data != null) {
        Map<String, dynamic> itemsBig = Map<String, dynamic>.from(data as Map);
        itemsBig.forEach((key, value) {
          Map<String, dynamic> items = Map<String, dynamic>.from(value as Map);
          items.forEach((key, value) {
            value['taskId'] = key;
            Task task = Task.fromMap(Map<String, dynamic>.from(value));
            if(task.aquariumId == aquarium.aquariumId && task.taskDate >= DateTime.now().millisecondsSinceEpoch){
              list.add(task);
            }
          });
        });
      }
      return list;
    }

    getTasksForCurrentDay() async {
      DateTime now = DateTime.now();
      DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59);
      List<Aquarium> aquariumList = await getAllAquariums();
      List<Task> list = [];

      for(int i = 0; i < aquariumList.length; i++){
        DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tasks/${aquariumList[i].aquariumId}');
        DataSnapshot snapshot = await ref.get();
        final data = snapshot.value;
        if (data != null) {
          Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
          items.forEach((key, value) {
            value['taskId'] = key;
            Task task = Task.fromMap(Map<String, dynamic>.from(value));
            if(task.taskDate >= now.millisecondsSinceEpoch && task.taskDate <= endOfDay.millisecondsSinceEpoch){
              list.add(task);
            }
          });
        }
      }
      return list;
    }

    Future<List<Task>> checkRepeatableTasks(Aquarium aquarium) async {
      List<Task> tasksToday = [];
      int weekdayNow = DateTime.now().weekday;

      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tasks/${aquarium.aquariumId}');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;

      if (data != null) {
        Map<String, dynamic> tasks = Map<String, dynamic>.from(data as Map);
        tasks.forEach((key, value) {
          value['taskId'] = key;
          Task task = Task.fromMap(Map<String, dynamic>.from(value));
          if(task.scheduled == '1'){
            TimeOfDay scheduledTime = TimeOfDay(
                hour: int.parse(task.scheduledTime.split(":")[0]),
                minute: int.parse(task.scheduledTime.split(":")[1]));
            List<bool> scheduledDaysBool = stringToBoolList(task.scheduledDays);
            for(int i = 0; i < scheduledDaysBool.length; i++){
              if(scheduledDaysBool[i] && i == weekdayNow-1 && isBeforeLatestDayTime(scheduledTime) && isNotInPast(scheduledTime)){
                tasksToday.add(task);
              }
            }
          }
        });
      }
      return tasksToday;
    }

    isBeforeLatestDayTime(TimeOfDay scheduledTime) {
      TimeOfDay latestDayTime = const TimeOfDay(hour: 23, minute: 59);
      if(latestDayTime.hour > scheduledTime.hour){
        return true;
      } else if(latestDayTime.hour == scheduledTime.hour && latestDayTime.minute > scheduledTime.minute){
        return true;
      }
      return false;
    }

    isNotInPast(TimeOfDay scheduledTime) {
      TimeOfDay now = TimeOfDay.now();
      if (now.hour < scheduledTime.hour) {
        return true;
      } else if (now.hour > scheduledTime.hour) {
        return false;
      } else { // Die Stunden sind gleich, also müssen wir die Minuten vergleichen
        if (now.minute < scheduledTime.minute) {
          return true;
        } else {
          return false;
        }
      }
    }

    Future<void> deleteTask(Aquarium aquarium, String taskId) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tasks/${aquarium.aquariumId}/$taskId');
      await ref.remove();
    }

    List<bool> stringToBoolList(String str) {
      String trimmedStr = str.substring(1, str.length - 1);
      List<String> strList = trimmedStr.split(', ');
      List<bool> boolList = strList.map((s) => s.toLowerCase() == 'true').toList();

      return boolList;
    }

    //-------------------------Methods for UserSettings-object-----------------------//

    getUserSettings() async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/usersettings');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      if (data != null) {
        return UserSettings.fromMap(Map<String, dynamic>.from(data as Map));
      }
      return null;
    }

   saveUserSettings(UserSettings userSettings) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/usersettings');
      await ref.set(userSettings.toMap());
    }

   signOut() async{
      await FirebaseAuth.instance.signOut();
      Datastore.db.user = null;
   }

    deleteUserAccount() async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}');
      await ref.remove();
      FirebaseAuth.instance.currentUser?.delete();
    }

    //-------------------------Methods for customTimer-object-----------------------//

  getCustomTimer() async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/customtimer');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      List<CustomTimer> list = [];
      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value['id'] = key;
          CustomTimer timer = CustomTimer.fromMap(Map<String, dynamic>.from(value));
          list.add(timer);
      });

        return list;
      }
      return null;
    }

    insertCustomTimer(CustomTimer timer) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/customtimer/${timer.id}');
      await ref.set(timer.toFirebaseMap());
    }

    deleteCustomTimer(CustomTimer timer) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/customtimer/${timer.id}');
      await ref.remove();
    }

    //-------------------------Methods for Components-object-----------------------//

    getFilterByAquarium(String aquariumId) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/$aquariumId/filter');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      List<Filter> list = [];
      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value['filterId'] = key;
          Filter filter = Filter.fromFirebaseMap(Map<String, dynamic>.from(value));
          list.add(filter);
        });
      }
      return list;
    }

    insertFilter(Filter filter) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/${filter.aquariumId}/filter/${filter.filterId}');
      await ref.set(filter.toFirebaseMap());
    }

    updateFilter(Filter filter) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/${filter.aquariumId}/filter/${filter.filterId}');
      await ref.update(filter.toFirebaseMap());
    }

    deleteFilter(Filter filter) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/${filter.aquariumId}/filter/${filter.filterId}');
      await ref.remove();
    }

    getLightingByAquarium(String aquariumId) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/$aquariumId/lighting');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      List<Lighting> list = [];
      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value['lightingId'] = key;
          Lighting lighting = Lighting.fromFirebaseMap(Map<String, dynamic>.from(value));
          list.add(lighting);
        });
      }
      return list;
    }

    insertLighting(Lighting lighting) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/${lighting.aquariumId}/lighting/${lighting.lightingId}');
      await ref.set(lighting.toFirebaseMap());
    }

    updateLighting(Lighting lighting) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/${lighting.aquariumId}/lighting/${lighting.lightingId}');
      await ref.update(lighting.toFirebaseMap());
    }

    deleteLighting(Lighting lighting) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/${lighting.aquariumId}/lighting/${lighting.lightingId}');
      await ref.remove();
    }

    getHeaterByAquarium(String aquariumId) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/$aquariumId/heater');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      List<Heater> list = [];
      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value['heaterId'] = key;
          Heater heater = Heater.fromFirebaseMap(Map<String, dynamic>.from(value));
          list.add(heater);
        });
      }
      return list;
    }

    insertHeater(Heater heater) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/${heater.aquariumId}/heater/${heater.heaterId}');
      await ref.set(heater.toFirebaseMap());
    }

    updateHeater(Heater heater) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/${heater.aquariumId}/heater/${heater.heaterId}');
      await ref.update(heater.toFirebaseMap());
    }

    deleteHeater(Heater heater) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/components/${heater.aquariumId}/heater/${heater.heaterId}');
      await ref.remove();
    }

}