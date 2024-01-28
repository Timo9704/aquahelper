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
  String imagePath;

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
        'imagePath': imagePath
      };
    }
  }
