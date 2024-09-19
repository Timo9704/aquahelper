class Plant {
  String plantId;
  String aquariumId;
  int plantNumber;
  String name;
  String latName;
  int amount;
  double xPosition;
  double yPosition;


  Plant(
      this.plantId,
      this.aquariumId,
      this.plantNumber,
      this.name,
      this.latName,
      this.amount,
      this.xPosition,
      this.yPosition
  );

  factory Plant.fromMap(Map<String, dynamic> json){
    return Plant(
        json["plantId"],
        json["aquariumId"],
        json["plantNumber"],
        json["name"],
        json["latName"],
        json["amount"],
        json["xPosition"],
        json["yPosition"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plantId': plantId,
      'aquariumId': aquariumId,
      'plantNumber': plantNumber,
      'name': name,
      'latName': latName,
      'amount': amount,
      'xPosition': xPosition,
      'yPosition': yPosition
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'aquariumId': aquariumId,
      'plantNumber': plantNumber,
      'name': name,
      'latName': latName,
      'amount': amount,
      'xPosition': xPosition,
      'yPosition': yPosition
    };
  }
}
