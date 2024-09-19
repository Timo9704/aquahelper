import 'package:flutter/material.dart';

import '../../../model/plant.dart';
import '../../../util/datastore.dart';
import '../../../util/scalesize.dart';

class PlantCard extends StatefulWidget{
  final Plant plant;
  final bool removeButton;
  final Function onPlantDeleted;

  const PlantCard(
      {super.key,
      required this.plant,
      this.removeButton = false,
      required this.onPlantDeleted});

  @override
  State<PlantCard> createState() => PlantCardState();
}

class PlantCardState extends State<PlantCard> {
  double textScaleFactor = 0;


  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: Colors.lightGreen,
              child: Text(
                widget.plant.plantNumber.toString(),
                textScaler: TextScaler.linear(textScaleFactor),
                style: const TextStyle(fontSize: 20),
              )),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.plant.name,
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(widget.plant.latName,
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          if (widget.removeButton)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                Datastore.db.deletePlant(widget.plant);
                widget.onPlantDeleted(widget.plant);
              },
            ),
        ],
      ),
    );
  }
}
