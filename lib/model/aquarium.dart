class Aquarium {
  int aquariumId;
  String name;
  int liter;
  String imageUrl;

  Aquarium(
    this.aquariumId,
    this.name,
    this.liter,
    this.imageUrl,
  );

  factory Aquarium.fromMap(Map<String, dynamic> json){
    return Aquarium(
        json["aquariumId"],
        json["name"],
        json["liter"],
        json["imageUrl"]
    );
  }

    Map<String, dynamic> toMap() {
      return {
        'aquariumId': aquariumId,
        'name': name,
        'liter': liter,
        'imageUrl': imageUrl,
      };
    }
  }
