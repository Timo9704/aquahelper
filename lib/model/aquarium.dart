class Aquarium {
  int? id;
  String? name;
  int? liter;
  String? imageUrl;

  Aquarium({
    this.id,
    this.name,
    this.liter,
    this.imageUrl
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'liter': liter,
      'imageUrl': imageUrl,
    };
  }
}