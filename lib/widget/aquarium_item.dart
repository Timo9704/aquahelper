import 'package:flutter/material.dart';
import '../model/aquarium.dart';
import '../screens/aquarium_overview.dart';

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
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(
                        aquarium.imageUrl),
                    // Bild von URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.black54,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(aquarium.name,
                    style: const TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ),
          ],
        ),
      );
  }
}
