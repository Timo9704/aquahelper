class Aquarium {
  String aquariumId;
  String name;
  int liter;
  int waterType;
  int co2Type;
  int width;
  int height;
  int depth;
  int healthStatus;
  int runInStatus;
  int runInStartDate;
  String imagePath;

  List<Aquarium> aquariumList = [];

  static final Aquarium aquarium = Aquarium._();
  Aquarium._(
      {this.aquariumId = '',
        this.name = '',
        this.liter = 0,
        this.waterType = 0,
        this.co2Type = 0,
        this.width = 0,
        this.height = 0,
        this.depth = 0,
        this.healthStatus = 0,
        this.runInStatus = 0,
        this.runInStartDate = 0,
        this.imagePath = ''}
      );

  Aquarium(
    this.aquariumId,
    this.name,
    this.liter,
    this.waterType,
    this.co2Type,
    this.width,
    this.height,
    this.depth,
    this.healthStatus,
    this.runInStatus,
    this.runInStartDate,
    this.imagePath,
  );

  factory Aquarium.fromMap(Map<String, dynamic> json){
    return Aquarium(
        json["aquariumId"],
        json["name"],
        json["liter"],
        json["waterType"],
        json["co2Type"],
        json["width"],
        json["height"],
        json["depth"],
        json["healthStatus"],
        json["runInStatus"] ?? 0,
        json["runInStartDate"] ?? 0,
        json["imagePath"]
    );
  }

    Map<String, dynamic> toMap() {
      return {
        'aquariumId': aquariumId,
        'name': name,
        'liter': liter,
        'waterType': waterType,
        'co2Type': co2Type,
        'width': width,
        'height': height,
        'depth': depth,
        'healthStatus': healthStatus,
        'runInStatus': runInStatus,
        'runInStartDate': runInStartDate,
        'imagePath': imagePath
      };
    }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'name': name,
      'liter': liter,
      'waterType': waterType,
      'co2Type': co2Type,
      'width': width,
      'height': height,
      'depth': depth,
      'healthStatus': healthStatus,
      'runInStatus': runInStatus,
      'runInStartDate': runInStartDate,
      'imagePath': imagePath
    };
  }
  }
