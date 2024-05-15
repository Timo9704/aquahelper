import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../model/aquarium.dart';
import '../../../../model/components/heater.dart';
import '../../../../util/datastore.dart';
import '../../aquarium_overview.dart';

class HeaterTab extends StatefulWidget {
  final Heater heater;
  final Aquarium aquarium;
  const HeaterTab({super.key, required this.heater, required this.aquarium});

  @override
  State<HeaterTab> createState() => _HeaterTabState();
}

class _HeaterTabState extends State<HeaterTab> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _manufacturerModelNameController;
  late TextEditingController _powerController;


  @override
  void initState() {
    super.initState();
    _manufacturerModelNameController = TextEditingController(text: widget.heater.manufacturerModelName);
    _powerController = TextEditingController(text: widget.heater.power.toString());
  }

  @override
  void dispose() {
    _manufacturerModelNameController.dispose();
    _powerController.dispose();
    super.dispose();
  }

  getEditedHeater() {
    if(widget.heater.heaterId == "") {
      return Heater(
        const Uuid().v4().toString(),
        widget.aquarium.aquariumId,
        _manufacturerModelNameController.text,
          parseTextFieldValue(_powerController)
      );
    }else{
      return Heater(
        widget.heater.heaterId,
        widget.heater.aquariumId,
        _manufacturerModelNameController.text,
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
                controller: _powerController,
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
                  if (_formKey.currentState!.validate()) {
                    Datastore.db.updateHeater(getEditedHeater());
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
