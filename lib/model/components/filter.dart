class Filter {
  String filterId;
  String aquariumId;
  String manufacturerModelName;
  int filterType;
  double power;
  double flowRate;
  int lastMaintenance;

  Filter(
      this.filterId,
      this.aquariumId,
      this.manufacturerModelName,
      this.filterType,
      this.power,
      this.flowRate,
      this.lastMaintenance
      );

  factory Filter.fromMap(Map<String, dynamic> json){
    return Filter(
        json["filterId"],
        json["aquariumId"],
        json["manufacturerModelName"],
        json["filterType"],
        json["power"],
        json["flowRate"],
        json["lastMaintenance"]
    );
  }

  factory Filter.fromFirebaseMap(Map<String, dynamic> json){
    return Filter(
        json["filterId"],
        json["aquariumId"],
        json["manufacturerModelName"],
        json["filterType"],
        double.parse(json["power"]),
        double.parse(json["flowRate"]),
        json["lastMaintenance"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filterId': filterId,
      'aquariumId': aquariumId,
      'manufacturerModelName': manufacturerModelName,
      'filterType': filterType,
      'power': power,
      'flowRate': flowRate,
      'lastMaintenance': lastMaintenance
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'aquariumId': aquariumId,
      'manufacturerModelName': manufacturerModelName,
      'filterType': filterType,
      'power': power.toString(),
      'flowRate': flowRate.toString(),
      'lastMaintenance': lastMaintenance
    };
  }

  String getFilterType() {
    String type = "";

    switch (filterType) {
      case 0:
        {
          type = "Innenfilter";
          break;
        }
      case 1:
        {
          type = "Außenfilter";
          break;
        }
      case 2:
        {
          type = "Hang-On-Filter";
          break;
        }
      case 3:
        {
          type = "Bodenfilter";
          break;
        }
      case 4:
        {
          type = "Lufthebe-Filter";
          break;
        }
      case 5:
        {
          type = "HMF";
          break;
        }
    }
    return type;
  }
}
