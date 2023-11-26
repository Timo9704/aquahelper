class Aquarium {
  String aquariumId;
  String name;
  int liter;
  int waterType;
  String imagePath;

  Aquarium(
    this.aquariumId,
    this.name,
    this.liter,
    this.waterType,
    this.imagePath,
  );

  factory Aquarium.fromMap(Map<String, dynamic> json){
    return Aquarium(
        json["aquariumId"],
        json["name"],
        json["liter"],
        json["waterType"],
        json["imagePath"]
    );
  }

    Map<String, dynamic> toMap() {
      return {
        'aquariumId': aquariumId,
        'name': name,
        'liter': liter,
        'waterType': waterType,
        'imagePath': imagePath
      };
    }
  }
