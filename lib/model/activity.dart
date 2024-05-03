class Activity {
  String id;
  String aquariumId;
  String activitites;
  int date;
  String notes;

  Activity(
      this.id,
      this.aquariumId,
      this.activitites,
      this.date,
      this.notes
      );

  factory Activity.fromMap(Map<String, dynamic> json){
    return Activity(
        json["id"],
        json["aquariumId"],
        json["activitites"],
        json["date"],
        json["notes"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aquariumId': aquariumId,
      'activitites': activitites,
      'date': date,
      'notes': notes
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'id': id,
      'aquariumId': aquariumId,
      'activitites': activitites,
      'date': date,
      'notes': notes
    };
  }
}
