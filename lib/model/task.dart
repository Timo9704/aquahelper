class Task {
  String taskId;
  String aquariumId;
  String title;
  String description;
  int taskDate;

  Task(
      this.taskId,
      this.aquariumId,
      this.title,
      this.description,
      this.taskDate,
      );

  factory Task.fromMap(Map<String, dynamic> json){
    return Task(
        json["taskId"],
        json["aquariumId"],
        json["title"],
        json["description"],
        json["taskDate"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'aquariumId': aquariumId,
      'title': title,
      'description': description,
      'taskDate': taskDate
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'aquariumId': aquariumId,
      'title': title,
      'description': description,
      'taskDate': taskDate
    };
  }
}
