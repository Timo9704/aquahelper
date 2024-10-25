import 'dart:io';

import 'package:aquahelper/viewmodels/aquarium/aquarium_plants_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../model/aquarium.dart';
import '../../../model/plant.dart';
import '../../../util/datastore.dart';


class CreateOrEditPlantViewModel extends ChangeNotifier {
  final Offset position;
  final int count;
  final Aquarium aquarium;
  final formKey = GlobalKey<FormState>();
  final plantNameController = TextEditingController();
  final latinNameController = TextEditingController();
  final amountController = TextEditingController();

  CreateOrEditPlantViewModel(this.aquarium, this.position, this.count);

  void savePlant(BuildContext context) async {
    try {
      if (formKey.currentState!
          .validate()) {
        Plant plant = Plant(
          const Uuid().v4().toString(),
          aquarium.aquariumId,
          count,
          plantNameController.text,
          latinNameController.text,
          int.parse(amountController.text),
          position.dx,
          position.dy,
        );
        Datastore.db.insertPlant(plant);
        Provider.of<AquariumPlantsViewModel>(context, listen: false).refresh();
        Navigator.pop(context);
      }
    } catch (e) {
      createPlantFailure(context);
    }
  }

  void createPlantFailure(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SnackBar(
          content: Text('Pflanze konnte nicht erstellt werden'),
          backgroundColor: Colors.red,
        );
      },
    );
  }

  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(aquarium.imagePath), fit: BoxFit.cover);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fitWidth);
    }
  }
}
