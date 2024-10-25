import 'dart:io';

import 'package:flutter/material.dart';

import '../../model/aquarium.dart';
import '../../model/plant.dart';
import '../../util/datastore.dart';


class AquariumPlantsViewModel extends ChangeNotifier {
  late Aquarium aquarium;
  List<Plant> plantList = [];


  initPlants(Aquarium aquarium) {
    this.aquarium = aquarium;
    loadPlants();
  }

  void refresh() {
    loadPlants();
  }

  void loadPlants() async {
    List<Plant> loadedPlants =
    await Datastore.db.getPlantsByAquarium(aquarium);
    plantList = loadedPlants;
    notifyListeners();
  }

  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(aquarium.imagePath), fit: BoxFit.cover);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fitWidth);
    }
  }
}
