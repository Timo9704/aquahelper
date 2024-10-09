import 'package:aquahelper/model/aquarium.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../model/animals.dart';
import '../../../util/datastore.dart';

class CreateOrEditAnimalViewModel extends ChangeNotifier {
  Aquarium aquarium;
  Animals animal;
  final formKey = GlobalKey<FormState>();
  final animalNameController = TextEditingController();
  final latinNameController = TextEditingController();
  final amountController = TextEditingController();
  String animalType = 'Fische';

  CreateOrEditAnimalViewModel(this.aquarium, this.animal) {
    animalNameController.text = animal!.name;
    latinNameController.text = animal!.latName;
    amountController.text = animal!.amount.toString();
    animalType = animal!.type;
  }

  onPressedSave(BuildContext context){
    if (formKey.currentState!.validate()) {
      if (animal != null) {
        var animal = Animals(
          this.animal.animalId,
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
      Navigator.pop(context);
    }
  }

  onPressedDelete(BuildContext context){
    if (animal != null) {
      Datastore.db.deleteAnimal(aquarium, animal!);
      Navigator.pop(context);
    }
  }
}
