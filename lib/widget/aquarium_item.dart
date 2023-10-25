import 'package:flutter/material.dart';
import '../screens/aquarium_overview.dart';

class AquariumItem extends StatelessWidget{
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
                        'https://aquaristik-kosmos.de/wp-content/uploads/2022/12/Aquarium_weboptimiert_720p_low.jpg'),
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
                child: Text("Alpen 60P",
                    style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ),
          ],
        ),
      );
  }
}