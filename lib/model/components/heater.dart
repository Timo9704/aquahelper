class Heater {
  String heaterId;
  String aquariumId;
  String manufacturerModelName;
  double power;

  Heater(
      this.heaterId,
      this.aquariumId,
      this.manufacturerModelName,
      this.power
      );

  factory Heater.fromMap(Map<String, dynamic> json){
    return Heater(
        json["heaterId"],
        json["aquariumId"],
        json["manufacturerModelName"],
        json["power"]
    );
  }

  factory Heater.fromFirebaseMap(Map<String, dynamic> json){
    return Heater(
        json["heaterId"],
        json["aquariumId"],
        json["manufacturerModelName"],
        double.parse(json["power"])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'heaterId': heaterId,
      'aquariumId': aquariumId,
      'manufacturerModelName': manufacturerModelName,
      'power': power
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'aquariumId': aquariumId,
      'manufacturerModelName': manufacturerModelName,
      'power': power.toString()
    };
  }
}
