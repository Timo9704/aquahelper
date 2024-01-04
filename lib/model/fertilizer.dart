class Fertilizer{
  int id;
  String name;
  double nitrate;
  double phosphate;
  double potassium;
  double iron;
  double magnesium;
  double dosage;

  Fertilizer(
      this.id,
      this.name,
      this.nitrate,
      this.phosphate,
      this.potassium,
      this.iron,
      this.magnesium,
      this.dosage,
      );

  factory Fertilizer.fromMap(Map<String, dynamic> json){
    return Fertilizer(
        json["id"],
        json["name"],
        json["nitrate"],
        json["phosphate"],
        json["potassium"],
        json["iron"],
        json["magnesium"],
        json["dosage"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nitrate': nitrate,
      'phosphate': phosphate,
      'potassium': potassium,
      'iron': iron,
      'magnesium': magnesium,
      'dosage': dosage
    };
  }
}
