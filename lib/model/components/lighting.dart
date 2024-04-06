class Lighting {
  String lightingId;
  String aquariumId;
  String manufacturerModelName;
  int lightingType;
  int brightness;
  double onTime;
  double power;

  Lighting(
      this.lightingId,
      this.aquariumId,
      this.manufacturerModelName,
      this.lightingType,
      this.brightness,
      this.onTime,
      this.power
  );

  factory Lighting.fromMap(Map<String, dynamic> json){
    return Lighting(
        json["lightingId"],
        json["aquariumId"],
        json["manufacturerModelName"],
        json["lightingType"],
        json["brightness"],
        json["onTime"],
        json["power"]
    );
  }

  factory Lighting.fromFirebaseMap(Map<String, dynamic> json){
    return Lighting(
        json["lightingId"],
        json["aquariumId"],
        json["manufacturerModelName"],
        json["lightingType"],
        json["brightness"],
        double.parse(json["onTime"]),
        double.parse(json["power"])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lightingId': lightingId,
      'aquariumId': aquariumId,
      'manufacturerModelName': manufacturerModelName,
      'lightingType': lightingType,
      'brightness': brightness,
      'onTime': onTime,
      'power': power
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'aquariumId': aquariumId,
      'manufacturerModelName': manufacturerModelName,
      'lightingType': lightingType,
      'brightness': brightness,
      'onTime': onTime.toString(),
      'power': power.toString()
    };
  }
}
