class Aquarium {
  String aquariumId;
  String name;
  int liter;
  int waterType;
  int width;
  int co2;
  int height;
  int depth;
  int healthStatus;
  String imagePath;

  Aquarium(
    this.aquariumId,
    this.name,
    this.liter,
    this.waterType,
    this.co2,
    this.width,
    this.height,
    this.depth,
    this.healthStatus,
    this.imagePath,
  );

  factory Aquarium.fromMap(Map<String, dynamic> json){
    return Aquarium(
        json["aquariumId"],
        json["name"],
        json["liter"],
        json["waterType"],
        json["liter"],
        json["liter"],
        json["liter"],
        json["liter"],
        json["healthStatus"],
        json["imagePath"]
    );
  }

    Map<String, dynamic> toMap() {
      return {
        'aquariumId': aquariumId,
        'name': name,
        'liter': liter,
        'waterType': waterType,
        'healthStatus': healthStatus,
        'imagePath': imagePath
      };
    }
  }
