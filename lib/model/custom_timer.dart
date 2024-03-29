class CustomTimer {
  String id;
  String name;
  int seconds;

  CustomTimer(
      this.id,
      this.name,
      this.seconds,
  );

  factory CustomTimer.fromMap(Map<String, dynamic> json){
    return CustomTimer(
        json["id"],
        json["name"],
        json["seconds"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'seconds': seconds,
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'id': id,
      'name': name,
      'seconds': seconds
    };
  }
}
