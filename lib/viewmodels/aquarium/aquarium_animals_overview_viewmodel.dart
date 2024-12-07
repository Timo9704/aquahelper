import 'package:aquahelper/model/animals.dart';
import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:aquahelper/views/aquarium/forms/create_or_edit_animal.dart';
import 'package:flutter/material.dart';



class AquariumAnimalsOverviewViewModel extends ChangeNotifier {
  double textScaleFactor = 0;
  List<Animals> fishes = [];
  List<Animals> shrimps = [];
  List<Animals> snails = [];
  Aquarium? aquarium;

  initAnimalsOverview(Aquarium initAquarium) {
    if (aquarium != null && initAquarium == aquarium) return;
    aquarium = initAquarium;
    loadAnimals();
  }

  void refresh() {
    loadAnimals();
  }

  void loadAnimals() async {
    List<Animals> loadedAnimals =
    await Datastore.db.getAnimalsByAquarium(aquarium!);
      fishes =
          loadedAnimals.where((animal) => animal.type == 'Fische').toList();
      shrimps =
          loadedAnimals.where((animal) => animal.type == 'Garnelen').toList();
      snails =
          loadedAnimals.where((animal) => animal.type == 'Schnecken').toList();
      notifyListeners();
  }

  onPressedAdd(BuildContext context, String animalType) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CreateOrEditAnimal(aquarium: aquarium!, animal: null, animalType: animalType)),
    );
  }

}