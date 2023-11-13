class Aquarium {
  int id;
  String name;
  int liter;
  String imageUrl;

  Aquarium(
    this.id,
    this.name,
    this.liter,
    this.imageUrl,
  );

  factory Aquarium.fromMap(Map<String, dynamic> json){
    return Aquarium(
        json["id"],
        json["name"],
        json["liter"],
        json["imageUrl"]
    );
  }

    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'name': name,
        'liter': liter,
        'imageUrl': imageUrl,
      };
    }
  }
