import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_animals_overview_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../model/animals.dart';
import '../../../util/datastore.dart';

class CreateOrEditAnimalViewModel extends ChangeNotifier {
  Aquarium aquarium;
  late Animals? animal;
  final formKey = GlobalKey<FormState>();
  final animalNameController = TextEditingController();
  final latinNameController = TextEditingController();
  final amountController = TextEditingController();
  String animalType = 'Fische';

  CreateOrEditAnimalViewModel(this.aquarium, animal){
    if(animal != null) {
      this.animal = animal;
      animalNameController.text = animal.name;
      latinNameController.text = animal.latName;
      amountController.text = animal.amount.toString();
      animalType = animal.type;
      notifyListeners();
    }else{
      this.animal = Animals(
        '',
        '',
        '',
        '',
        '',
        0,
      );
    }
  }

  onPressedSave(BuildContext context){
    if (formKey.currentState!.validate()) {
      if (animal?.aquariumId != "") {
        var animal = Animals(
          this.animal!.animalId,
          aquarium.aquariumId,
          animalNameController.text,
          latinNameController.text,
          animalType,
          int.parse(amountController.text),
        );
        Datastore.db.updateAnimal(aquarium, animal);
      } else {
        var animal = Animals(
          const Uuid().v4().toString(),
          aquarium.aquariumId,
          animalNameController.text,
          latinNameController.text,
          animalType,
          int.parse(amountController.text),
        );
        Datastore.db.insertAnimal(aquarium, animal);
      }
      Provider.of<AquariumAnimalsOverviewViewModel>(context, listen: false).refresh();
      Navigator.pop(context);
    }
  }

  onPressedDelete(BuildContext context){
    if (animal != null) {
      Datastore.db.deleteAnimal(aquarium, animal!);
      Provider.of<AquariumAnimalsOverviewViewModel>(context, listen: false).refresh();
      Navigator.pop(context);
    }
  }
}