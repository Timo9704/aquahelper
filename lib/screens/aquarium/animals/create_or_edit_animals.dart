import 'package:flutter/material.dart';
import 'package:aquahelper/model/animals.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:uuid/uuid.dart';

import '../../../model/aquarium.dart';

class CreateOrEditAnimals extends StatefulWidget {
  final Aquarium aquarium;
  Animals? animal;

  CreateOrEditAnimals({super.key, required this.aquarium, this.animal});

  @override
  CreateOrEditAnimalsState createState() => CreateOrEditAnimalsState();
}

class CreateOrEditAnimalsState extends State<CreateOrEditAnimals> {
  final _formKey = GlobalKey<FormState>();
  final _animalNameController = TextEditingController();
  final _latinNameController = TextEditingController();
  final _amountController = TextEditingController();
  String _animalType = 'Fische';

  @override
  initState() {
    super.initState();
    if (widget.animal != null) {
      _animalNameController.text = widget.animal!.name;
      _latinNameController.text = widget.animal!.latName;
      _amountController.text = widget.animal!.amount.toString();
      _animalType = widget.animal!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neues Tier hinzufügen'),
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _animalNameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte einen Namen eingeben';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _latinNameController,
                  decoration: const InputDecoration(
                    labelText: 'Lateinischer Name',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte einen lateinischen Namen eingeben';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _animalType,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
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
                    setState(() {
                      _animalType = newValue!;
                    });
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Anzahl der Tiere',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte eine Anzahl eingeben';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.animal != null)
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(150, 40)),
                        ),
                        onPressed: () {
                          if (widget.animal != null) {
                            Datastore.db
                                .deleteAnimal(widget.aquarium, widget.animal!);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Löschen'),
                      ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightGreen),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(150, 40)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.animal != null) {
                            var animal = Animals(
                              widget.animal!.animalId,
                              widget.aquarium.aquariumId,
                              _animalNameController.text,
                              _latinNameController.text,
                              _animalType,
                              int.parse(_amountController.text),
                            );
                            Datastore.db.updateAnimal(widget.aquarium, animal);
                          } else {
                            var animal = Animals(
                              const Uuid().v4().toString(),
                              widget.aquarium.aquariumId,
                              _animalNameController.text,
                              _latinNameController.text,
                              _animalType,
                              int.parse(_amountController.text),
                            );
                            Datastore.db.insertAnimal(widget.aquarium, animal);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Speichern'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
