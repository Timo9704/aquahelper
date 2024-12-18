import 'package:aquahelper/model/animals.dart';
import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_animals_overview_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class CreateOrEditAnimalViewModel extends ChangeNotifier {
  Aquarium aquarium;
  late Animals? animal;
  final formKey = GlobalKey<FormState>();
  final animalNameController = TextEditingController();
  final latinNameController = TextEditingController();
  final amountController = TextEditingController();
  String animalType = 'Fische';

  CreateOrEditAnimalViewModel(this.aquarium, animal, animalType) {
    if(animal != null) {
      this.animal = animal;
      animalNameController.text = animal.name;
      latinNameController.text = animal.latName;
      amountController.text = animal.amount.toString();
      this.animalType = animal.type;
      notifyListeners();
    }else{
      this.animalType = animalType;
      this.animal = Animals(
        '',
        '',
        '',
        '',
        '',
        0,
      );
      notifyListeners();
    }
  }

  onPressedSave(BuildContext context) async {
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
        await Datastore.db.updateAnimal(aquarium, animal);
      } else {
        var animal = Animals(
          const Uuid().v4().toString(),
          aquarium.aquariumId,
          animalNameController.text,
          latinNameController.text,
          animalType,
          int.parse(amountController.text),
        );
        await Datastore.db.insertAnimal(aquarium, animal);
      }
      if(context.mounted){
        Provider.of<AquariumAnimalsOverviewViewModel>(context, listen: false).refresh();
        Navigator.pop(context);
      }
    }
  }

  void onPressedDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Warnung"),
          content:  const Text("Willst du diesen Eintrag wirklich löschen?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightGreen)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Nein"),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
                  onPressed: () async {
                    await Datastore.db.deleteAnimal(aquarium, animal!);
                    if(context.mounted){
                      Provider.of<AquariumAnimalsOverviewViewModel>(context, listen: false).refresh();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Ja"),
                ),
              ],
            ),
          ],
          elevation: 0,
        );
      },
    );
  }
}
