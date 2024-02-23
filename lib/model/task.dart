class Task {
  String taskId;
  String aquariumId;
  String title;
  String description;
  int taskDate;
  String scheduled;
  String scheduledDays;
  String scheduledTime;

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
}
