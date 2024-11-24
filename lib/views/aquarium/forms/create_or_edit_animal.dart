import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/viewmodels/aquarium/forms/create_or_edit_animal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:aquahelper/model/animals.dart';
import 'package:provider/provider.dart';


class CreateOrEditAnimal extends StatelessWidget {
  final Aquarium aquarium;
  final Animals? animal;
  final String? animalType;

  const CreateOrEditAnimal({super.key, required this.aquarium, this.animal, this.animalType});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => CreateOrEditAnimalViewModel(aquarium, animal, animalType),
      child: Consumer<CreateOrEditAnimalViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Neues Tier hinzufügen'),
            backgroundColor: Colors.lightGreen,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: viewModel.formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: viewModel.animalNameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        floatingLabelStyle: TextStyle(color: Colors.lightGreen),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte einen Namen eingeben';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: viewModel.latinNameController,
                      decoration: const InputDecoration(
                        labelText: 'Lateinischer Name',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        floatingLabelStyle: TextStyle(color: Colors.lightGreen),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte einen lateinischen Namen eingeben';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: viewModel.animalType,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: 'Tierart',
                      ),
                      items: <String>['Fische', 'Garnelen', 'Schnecken']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        viewModel.animalType = newValue!;
                      },
                    ),
                    TextFormField(
                      controller: viewModel.amountController,
                      decoration: const InputDecoration(
                        labelText: 'Anzahl der Tiere',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        floatingLabelStyle: TextStyle(color: Colors.lightGreen),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null) {
                          return 'Bitte eine Ganzzahl eingeben';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (viewModel.animal?.animalId != "")
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.grey),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(150, 40)),
                            ),
                            onPressed: () => viewModel.onPressedDelete(context),
                            child: Text('Löschen', textScaler: TextScaler.linear(textScaleFactor)),
                          ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightGreen),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(150, 40)),
                          ),
                          onPressed: () => viewModel.onPressedSave(context),
                          child: Text('Speichern', textScaler: TextScaler.linear(textScaleFactor)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
