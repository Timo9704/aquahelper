import 'dart:io';

import 'package:flutter/material.dart';

import '../../model/aquarium.dart';
import '../../model/plant.dart';
import '../../util/datastore.dart';


class AquariumPlantsViewModel extends ChangeNotifier {
  Aquarium aquarium;
  List<Plant> plantList = [];

  AquariumPlantsViewModel(this.aquarium) {
    loadPlants();
  }

  loadPlants() async {
    List<Plant> loadedPlants =
    await Datastore.db.getPlantsByAquarium(aquarium);
    plantList = loadedPlants;
  }

  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(aquarium.imagePath), fit: BoxFit.cover);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fitWidth);
    }
  }
}
