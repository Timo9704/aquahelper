class Activity {
  String id;
  String aquariumId;
  String activities;
  int date;
  String notes;

  Activity(
      this.id,
      this.aquariumId,
      this.activities,
      this.date,
      this.notes
      );

  factory Activity.fromMap(Map<String, dynamic> json){
    return Activity(
        json["id"],
        json["aquariumId"],
        json["activities"],
        json["date"],
        json["notes"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aquariumId': aquariumId,
      'activities': activities,
      'date': date,
      'notes': notes
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'id': id,
      'aquariumId': aquariumId,
      'activities': activities,
      'date': date,
      'notes': notes
    };
  }
}
