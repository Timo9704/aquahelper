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
  double conductance;

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
      this.conductance
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
        json["imagePath"],
        json["conductance"]
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
      'conductance': conductance
    };
  }

  void updateMeasurement(Map<String, dynamic> values) {
    values.forEach((key, value) {
      switch (key) {
        case 'measurementId':
          measurementId = value as String;
          break;
        case 'aquariumId':
          aquariumId = value as String;
          break;
        case 'temperature':
          temperature = value as double;
          break;
        case 'ph':
          ph = value as double;
          break;
        case 'totalHardness':
          totalHardness = value as double;
          break;
        case 'carbonateHardness':
          carbonateHardness = value as double;
          break;
        case 'nitrite':
          nitrite = value as double;
          break;
        case 'nitrate':
          nitrate = value as double;
          break;
        case 'phosphate':
          phosphate = value as double;
          break;
        case 'potassium':
          potassium = value as double;
          break;
        case 'iron':
          iron = value as double;
          break;
        case 'magnesium':
          magnesium = value as double;
          break;
        case 'measurementDate':
          measurementDate = value as int;
          break;
        case 'imagePath':
          imagePath = value as String;
          break;
        case 'conductance':
          conductance = value as double;
          break;
        default:
        // Handle unknown key, if necessary
          break;
      }
    });
  }

  double getValueByName(String name){
    print(name);
    switch (name) {
      case 'temperature':
        return temperature;
      case 'ph':
        return ph;
      case 'totalHardness':
        return totalHardness;
      case 'carbonateHardness':
        return carbonateHardness;
      case 'nitrite':
        return nitrite;
      case 'nitrate':
        return nitrate;
      case 'phosphate':
        return phosphate;
      case 'potassium':
        return potassium;
      case 'iron':
        return iron;
      case 'magnesium':
        return magnesium;
      case 'conductance':
        return conductance;
      default:
        return 0;
    }
  }
}
