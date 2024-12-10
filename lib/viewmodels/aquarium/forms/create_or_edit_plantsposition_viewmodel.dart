import 'dart:io';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/plant.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_plants_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class CreateOrEditPlantsPositionViewModel extends ChangeNotifier {
  List<Offset> positions = [];
  List<Plant> plantList = [];
  int plantCount = 1;
  bool refreshed = false;
  Aquarium aquarium;

  CreateOrEditPlantsPositionViewModel(this.aquarium){
    loadPlants();
    plantCount = plantList.length+1;
  }

  loadPlants() async {
    await Datastore.db.getPlantsByAquarium(aquarium).then((value) {
        plantCount = value.length+1;
        plantList.clear();
        positions.clear();
        for (Plant plant in value) {
          plantList.add(plant);
          positions.add(Offset(plant.xPosition, plant.yPosition));
        }
      });
    notifyListeners();
  }

  Future<void> removePlant(Plant plant, BuildContext context) async {
    await Datastore.db.deletePlant(plant);
    await loadPlants();
    for(int i = 0; i < plantList.length; i++) {
      if (plantList[i].plantNumber != i + 1) {
        plantList[i].plantNumber = i + 1;
        Datastore.db.updatePlant(plantList[i]);
      }
    }
    if(context.mounted){
      Provider.of<AquariumPlantsViewModel>(context, listen: false).refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Die Pflanze wurde gelöscht!', textAlign: TextAlign.center),
          backgroundColor: Colors.green,
        ),
      );
    }
  }


  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(aquarium.imagePath), fit: BoxFit.cover);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fitWidth);
    }
  }

}



