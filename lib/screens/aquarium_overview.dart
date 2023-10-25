import 'package:flutter/material.dart';

import '../widget/measurement_item.dart';
import 'measurement_form.dart';

class AquariumOverview extends StatelessWidget{
  const AquariumOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alpen 60P"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
            Container(
              height: 150.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://aquaristik-kosmos.de/wp-content/uploads/2022/12/Aquarium_weboptimiert_720p_low.jpg'),
                  // Bild von URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Alle Messungen:', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800)),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const MeasurementForm()),
                        );
                      },
                      icon: const Icon(Icons.add,
                        color: Colors.lightGreen,
                      ),
                    ),
                  ],
                ),
            ),
          Container(
            padding: const EdgeInsets.all(5.0),
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 2,
              itemBuilder: (context, index) {
                return MeasurementItem(index);
              },
            ),
          ),
          ElevatedButton(onPressed: () => {}, child: const Text("Wasserwert-Verlauf"))
        ],
      ),
    );
  }
}