import '../util/config.dart';

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

  factory UserSettings.inital(){
    return UserSettings(
        List.generate(waterValues.length, (index) => true).toString(),
        1
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'measurementItems': measurementItems,
      'measurementLimits': measurementLimits
    };
  }

  bool isInitialized() {
    return measurementItems.isNotEmpty;
  }

}


