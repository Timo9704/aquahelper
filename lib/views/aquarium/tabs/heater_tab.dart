import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../util/datastore.dart';
import '../../../../viewmodels/aquarium/forms/create_or_edit_technic_viewmodel.dart';
import '../../../../views/aquarium/aquarium_overview.dart';

class HeaterTab extends StatelessWidget{
  const HeaterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateOrEditTechnicViewModel>(
      builder: (context, viewModel, child) => SingleChildScrollView(
        child: Form(
          key: viewModel.heaterFormKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: viewModel.heaterManufacturerModelNameController,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Hersteller & Modell',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte geben Sie Hersteller & Modell an';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: viewModel.heaterPowerController,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Leistung',
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                  ),
                  onPressed: () {
                    if (viewModel.heaterFormKey.currentState!.validate()) {
                      Datastore.db.updateHeater(viewModel.getEditedHeater());
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AquariumOverview(aquarium: viewModel.aquarium),
                        ),
                      );
                    }
                  },
                  child: const Text('Speichern'),
                ),
              ],
            ),
          ),
        ),
      ),);
  }
}
