class UserSettings {
  String measurementItems;
  int measurementLimits = 1;

  UserSettings(
      this.measurementItems,
      this.measurementLimits
  );

  factory UserSettings.fromMap(Map<String, dynamic> json){
    return UserSettings(
        json["measurementItems"],
        json["measurementLimits"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'measurementItems': measurementItems,
      'measurementLimits': measurementLimits
    };
  }
}


