import '../util/datastore.dart';
import 'aquarium.dart';

class Task {
  static final Task task = Task._();
  Task._();

  String taskId;
  String aquariumId;
  String title;
  String description;
  int taskDate;
  String scheduled;
  String scheduledDays;
  String scheduledTime;
  List<Task> taskList  = [];

  Task(
      this.taskId,
      this.aquariumId,
      this.title,
      this.description,
      this.taskDate,
      this.scheduled,
      this.scheduledDays,
      this.scheduledTime
  );

  factory Task.fromMap(Map<String, dynamic> json){
    return Task(
        json["taskId"],
        json["aquariumId"],
        json["title"],
        json["description"],
        json["taskDate"],
        json["scheduled"],
        json["scheduledDays"],
        json["scheduledTime"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'aquariumId': aquariumId,
      'title': title,
      'description': description,
      'taskDate': taskDate,
      'scheduled': scheduled,
      'scheduledDays': scheduledDays,
      'scheduledTime': scheduledTime
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'aquariumId': aquariumId,
      'title': title,
      'description': description,
      'taskDate': taskDate,
      'scheduled': scheduled,
      'scheduledDays': scheduledDays,
      'scheduledTime': scheduledTime
    };
  }

  Future<List<Task>> getTaskListByAquarium(Aquarium aquarium) async {
    List<Task> list = await Datastore.db.getTasksForAquarium(aquarium);
    return list;
  }
}
