import 'dart:io';

import 'package:aquahelper/screens/aquarium/plants/plant_cards.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../model/aquarium.dart';
import '../../../model/plant.dart';
import '../../../util/datastore.dart';
import '../../../util/scalesize.dart';
import 'create_or_edit_plants.dart';

class CreateOrEditPlantsTap extends StatefulWidget {
  const CreateOrEditPlantsTap({super.key, required this.aquarium});
  final Aquarium aquarium;
  @override
  CreateOrEditPlantsTapState createState() => CreateOrEditPlantsTapState();
}

class CreateOrEditPlantsTapState extends State<CreateOrEditPlantsTap> {
  double textScaleFactor = 0;
  List<Offset> positions = [];
  List<Plant> plantList = [];
  int plantCount = 1;
  bool refreshed = false;

  @override
  void initState() {
    super.initState();
    loadPlants();
  }

  loadPlants() async {
    await Datastore.db.getPlantsByAquarium(widget.aquarium).then((value) {
      setState(() {
        plantCount = value.length+1;
        plantList.clear();
        positions.clear();
        for (Plant plant in value) {
          plantList.add(plant);
          positions.add(Offset(plant.xPosition, plant.yPosition));
        }
      });
    });
  }

  void removePlant(Plant plant) {
    loadPlants();
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
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Pflanzen bearbeiten"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  setState(() {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => CreateOrEditPlants(
                          aquarium: widget.aquarium,
                          position: details.localPosition,
                          count: plantCount,
                        ),
                      )).then((value) async => await loadPlants()
                    );
                  });
                },
                child: SizedBox(
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
              ),
              ...positions.map((Offset position) => Positioned(
                left: position.dx-25,
                top: position.dy-20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Text(
                      '${positions.indexOf(position) + 1}',
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Text(
              'Tippe auf die Stelle im Aquarium, an der sich die Pflanze befindet, um eine Pflanze hinzuzufügen. Falls die Liste nicht aktualisiert wird, tippe auf das Aktualisieren-Symbol.',
              textAlign: TextAlign.justify,
              textScaler: TextScaler.linear(textScaleFactor),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  shrinkWrap: true,
                  children: plantList.map((plant) => PlantCard(
                    plant: plant,
                    removeButton: true,
                    onPlantDeleted: removePlant,
                  )).toList(),
                )
            ),
          )
        ],
      ),
      floatingActionButton: !refreshed ? FloatingActionButton(
        onPressed: () {
          loadPlants();
          refreshed = true;
        },
        backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.refresh, color: Colors.white),
      ) : null,
    );
  }
}