class UserSettings {
  String measurementItems;

  UserSettings(
      this.measurementItems
      );

  factory UserSettings.fromMap(Map<String, dynamic> json){
    return UserSettings(
        json["measurementItems"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'measurementItems': measurementItems
    };
  }
}
