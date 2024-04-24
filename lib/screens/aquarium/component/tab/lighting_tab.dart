import 'package:aquahelper/model/components/lighting.dart';
import 'package:aquahelper/screens/aquarium_overview.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../model/aquarium.dart';
import '../../../../util/datastore.dart';

class LightingTab extends StatefulWidget {
  final Lighting lighting;
  final Aquarium aquarium;
  const LightingTab({super.key, required this.lighting, required this.aquarium});

  @override
  State<LightingTab> createState() => _LightingTabState();
}

class _LightingTabState extends State<LightingTab> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _manufacturerModelNameController;
  late TextEditingController _brightnessController;
  late TextEditingController _onTimeController;
  late TextEditingController _powerController;

  @override
  void initState() {
    super.initState();
    _manufacturerModelNameController = TextEditingController(text: widget.lighting.manufacturerModelName);
    _brightnessController = TextEditingController(text: widget.lighting.brightness.toString());
    _onTimeController = TextEditingController(text: widget.lighting.onTime.toString());
    _powerController = TextEditingController(text: widget.lighting.power.toString());
  }

  @override
  void dispose() {
    _manufacturerModelNameController.dispose();
    _brightnessController.dispose();
    _onTimeController.dispose();
    _powerController.dispose();
    super.dispose();
  }

  getEditedLighting() {
    if(widget.lighting.lightingId == "") {
      return Lighting(
        const Uuid().v4().toString(),
        widget.aquarium.aquariumId,
        _manufacturerModelNameController.text,
        0,
        int.parse(_brightnessController.text),
        parseTextFieldValue(_onTimeController),
        parseTextFieldValue(_powerController)
      );
    }else{
      return Lighting(
        widget.lighting.lightingId,
        widget.lighting.aquariumId,
        _manufacturerModelNameController.text,
        0,
        int.parse(_brightnessController.text),
        parseTextFieldValue(_onTimeController),
        parseTextFieldValue(_powerController)
      );
    }
  }

  double parseTextFieldValue(TextEditingController controller){
    if(controller.text.isEmpty){
      controller.text = "0.0";
      return 0.0;
    }
    controller.text = controller.text.replaceAll(RegExp(r','), '.');
    return double.parse(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _manufacturerModelNameController,
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
                controller: _brightnessController,
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
                controller: _onTimeController,
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
                controller: _powerController,
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
                  if (_formKey.currentState!.validate()) {
                    Datastore.db.updateLighting(getEditedLighting());
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AquariumOverview(aquarium: widget.aquarium),
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
    );
  }
}
