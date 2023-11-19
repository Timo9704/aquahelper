class Aquarium {
  int aquariumId;
  String name;
  int liter;
  int waterType;
  String imageUrl;

  Aquarium(
    this.aquariumId,
    this.name,
    this.liter,
    this.waterType,
    this.imageUrl,
  );

  factory Aquarium.fromMap(Map<String, dynamic> json){
    return Aquarium(
        json["aquariumId"],
        json["name"],
        json["liter"],
        json["waterType"],
        json["imageUrl"]
    );
  }

    Map<String, dynamic> toMap() {
      return {
        'aquariumId': aquariumId,
        'name': name,
        'liter': liter,
        'waterType': waterType,
        'imageUrl': imageUrl
      };
    }
  }
