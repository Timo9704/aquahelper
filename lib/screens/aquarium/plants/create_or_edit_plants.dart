import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../model/aquarium.dart';
import '../../../model/plant.dart';
import '../../../util/datastore.dart';
import '../../../util/scalesize.dart';

class CreateOrEditPlants extends StatefulWidget {
  const CreateOrEditPlants({super.key, required this.aquarium, required this.position, required this.count});
  final Offset position;
  final int count;
  final Aquarium aquarium;
  @override
  CreateOrEditPlantsState createState() => CreateOrEditPlantsState();
}

class CreateOrEditPlantsState extends State<CreateOrEditPlants> {
  double textScaleFactor = 0;
  final _formKey = GlobalKey<FormState>();
  final _plantNameController = TextEditingController();
  final _latinNameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  initState() {
    super.initState();
  }


  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(widget.aquarium.imagePath), fit: BoxFit.cover);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fitWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      appBar: AppBar(
        title: const Text("Pflanzen bearbeiten"),
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView( child:Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                  width: double.infinity,
                  height: 230,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: widget.aquarium.imagePath.startsWith('assets/')
                        ? Image.asset(widget.aquarium.imagePath, fit: BoxFit.cover)
                        :  widget.aquarium.imagePath.startsWith('https://')
                        ? CachedNetworkImage(imageUrl:widget.aquarium.imagePath, fit: BoxFit.cover)
                        : localImageCheck(widget.aquarium.imagePath),
                  ),),
              Positioned(
                left: widget.position.dx-25,
                top: widget.position.dy-20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.count}',
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _plantNameController,
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
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Anzahl der Pflanzen',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreen),
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte eine Zahl eingeben';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightGreen),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(150, 40)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Plant plant = Plant(
                                const Uuid().v4().toString(),
                                widget.aquarium.aquariumId,
                                widget.count,
                                _plantNameController.text,
                                _latinNameController.text,
                                int.parse(_amountController.text),
                                widget.position.dx,
                                widget.position.dy,
                              );
                              Datastore.db.insertPlant(plant);
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Speichern',textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 20)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    ));
  }
}