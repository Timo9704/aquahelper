class Animals {
  String animalId;
  String aquariumId;
  String name;
  String latName;
  String type;
  int amount;

  Animals(
      this.animalId,
      this.aquariumId,
      this.name,
      this.latName,
      this.type,
      this.amount
  );

  factory Animals.fromMap(Map<String, dynamic> json){
    return Animals(
        json["animalId"],
        json["aquariumId"],
        json["name"],
        json["latName"],
        json["type"],
        json["amount"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'animalId': animalId,
      'aquariumId': aquariumId,
      'name': name,
      'latName': latName,
      'type': type,
      'amount': amount
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'aquariumId': aquariumId,
      'name': name,
      'latName': latName,
      'type': type,
      'amount': amount
    };
  }
}
