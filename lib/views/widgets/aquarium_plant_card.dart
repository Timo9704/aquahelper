import 'package:aquahelper/model/plant.dart';
import 'package:aquahelper/util/scalesize.dart';
import 'package:flutter/material.dart';


class AquariumPlantCard extends StatelessWidget {
  const AquariumPlantCard({ super.key, required this.plant, this.removeButton = false, required this.onPlantDeleted });
  final Plant plant;
  final bool removeButton;
  final Function onPlantDeleted;

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
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
              foregroundColor: Colors.black,
              child: Text(
                plant.plantNumber.toString(),
                textScaler: TextScaler.linear(textScaleFactor),
                style: const TextStyle(fontSize: 16),
              )),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.name,
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(plant.latName,
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          if (removeButton)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                onPlantDeleted(plant, context);
              },
            ),
        ],
      ),
    );
  }
}
