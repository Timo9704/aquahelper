import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../util/datastore.dart';
import '../../../../views/aquarium/aquarium_overview.dart';
import '../../../viewmodels/aquarium/forms/create_or_edit_technic_viewmodel.dart';

class LightingTab extends StatelessWidget {
  const LightingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateOrEditTechnicViewModel>(
        builder: (context, viewModel, child) => SingleChildScrollView(
      child: Form(
        key: viewModel.lightFormKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: viewModel.lightManufacturerModelNameController,
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
                controller: viewModel.lightBrightnessController,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Helligkeit',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^-?\d+(\.\d+)?|(\,\d+)?$').hasMatch(value)) {
                    return 'Bitte gebe nur Ganzahlen an!';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: viewModel.lightOnTimeController,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Beleuchtungsdauer',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: viewModel.lightPowerController,
                decoration: const InputDecoration(
                  labelText: 'Leistung',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                ),
                onPressed: () {
                  if (viewModel.lightFormKey.currentState!.validate()) {
                    Datastore.db.updateLighting(viewModel.getEditedLighting());
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
