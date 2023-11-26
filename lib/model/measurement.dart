class Measurement {
  String measurementId;
  String aquariumId;
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
  int measurementDate;
  String imagePath;

  Measurement(
      this.measurementId,
      this.aquariumId,
      this.temperature,
      this.ph,
      this.totalHardness,
      this.carbonateHardness,
      this.nitrite,
      this.nitrate,
      this.phosphate,
      this.potassium,
      this.iron,
      this.magnesium,
      this.measurementDate,
      this.imagePath,
  );

  factory Measurement.fromMap(Map<String, dynamic> json){
    return Measurement(
        json["measurementId"],
        json["aquariumId"],
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
        json["measurementDate"],
        json["imagePath"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'measurementId': measurementId,
      'aquariumId' : aquariumId,
      'temperature': temperature,
      'ph': ph,
      'totalHardness': totalHardness,
      'carbonateHardness': carbonateHardness,
      'nitrite': nitrite,
      'nitrate': nitrate,
      'phosphate': phosphate,
      'potassium': potassium,
      'iron': iron,
      'magnesium': magnesium,
      'measurementDate': measurementDate,
      'imagePath': imagePath,
    };
  }
}
