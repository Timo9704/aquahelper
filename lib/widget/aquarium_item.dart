import 'dart:io';

import 'package:aquahelper/util/dbhelper.dart';
import 'package:flutter/material.dart';
import '../model/aquarium.dart';
import '../screens/aquarium_overview.dart';
import '../screens/create_or_edit_aquarium.dart';

class AquariumItem extends StatelessWidget{
  final Aquarium aquarium;
  
  const AquariumItem({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AquariumOverview(aquarium: aquarium)),
              ),
              child: Container(
                height: 180.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  ),
                child: Image.file(File(aquarium.imagePath),fit: BoxFit.cover),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.black54,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(aquarium.name,
                          style: const TextStyle(fontSize: 24, color: Colors.white)),
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateOrEditAquarium(aquarium: aquarium)),
                          ),
                          icon: const Icon(Icons.edit,
                            color: Colors.white,
                          ),
                        ),
            ])
            ),
            )],
        ),
      );
  }
}
