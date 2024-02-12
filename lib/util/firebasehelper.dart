
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/aquarium.dart';
import '../model/measurement.dart';
import '../model/task.dart';
import '../model/user_settings.dart';

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
      return list;
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
      return list.length;
    }

    getAllTasksForAquarium(Aquarium aquarium) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tasks');
      DataSnapshot snapshot = await ref.get();
      final data = snapshot.value;
      List<Task> list = [];
      if (data != null) {
        Map<String, dynamic> items = Map<String, dynamic>.from(data as Map);
        items.forEach((key, value) {
          value['taskId'] = key;
          Task task = Task.fromMap(Map<String, dynamic>.from(value));
          if(task.aquariumId == aquarium.aquariumId){
            list.add(task);
          }
        });
      }
      return list;
    }

    getTasksForCurrentDay() async {
      DateTime now = DateTime.now();
      DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59);
      List<Aquarium> aquariumList = await getAllAquariums();
      List<Task> list = [];

      aquariumList.forEach((aquarium) async {
        DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tasks/${aquarium.aquariumId}');
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
      });
      return list;
    }

    Future<void> deleteTask(Aquarium aquarium, String taskId) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user?.uid}/tasks/${aquarium.aquariumId}/$taskId');
      await ref.remove();
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
   }

}