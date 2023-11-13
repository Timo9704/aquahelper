import 'package:flutter/material.dart';
import '../screens/aquarium_overview.dart';
import '../model/aquarium.dart';

class AquariumItem extends StatelessWidget{
  final Aquarium aquarium;
  
  const AquariumItem({super.key});

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
                MaterialPageRoute(builder: (context) => const AquariumOverview()),
              ),
              child: Container(
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: const DecorationImage(
                    image: NetworkImage(
                        ${aquarium.imageUrl}),
                    // Bild von URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.black54,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(${aquarium.name},
                    style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ),
          ],
        ),
      );
  }
}
