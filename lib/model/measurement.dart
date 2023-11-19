class Measurement {
  double temperature;
  double ph;
  double totalHardness;
  double carbonateHardness;
  double nitrite;
  double nitrate;
  double phosphate;
  double potassium;
  double iron;
  double magnesium;
  DateTime measurementDate;

  Measurement(this.temperature,
      this.ph,
      this.totalHardness,
      this.carbonateHardness,
      this.nitrite,
      this.nitrate,
      this.phosphate,
      this.potassium,
      this.iron,
      this.magnesium,
      this.measurementDate
  );

  factory Measurement.fromMap(Map<String, dynamic> json){
    return Measurement(
        json["temperature"],
        json["ph"],
        json["totalHardness"],
        json["carbonateHardness"],
        json["nitrite"],
        json["nitrate"],
        json["phosphate"],
        json["potassium"],
        json["iron"],
        json["magnesium"],
        json["measurmentDate"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'ph': ph,
      'totalHardness': totalHardness,
      'carbonateHardness': carbonateHardness,
      'nitrite': nitrite,
      'nitrate': nitrate,
      'phosphate': phosphate,
      'potassium': potassium,
      'iron': iron,
      'magnesium': magnesium
    };
  }
}
