import 'package:flutter/material.dart';

class AiPlannerResultAquariumWidget extends StatelessWidget {
  final String aquariumName;
  final String aquariumLength;
  final String aquariumDepth;
  final String aquariumHeight;
  final String aquariumLiter;
  final String aquariumPrice;

  const AiPlannerResultAquariumWidget({
    super.key,
    required this.aquariumName,
    required this.aquariumLength,
    required this.aquariumDepth,
    required this.aquariumHeight,
    required this.aquariumLiter,
    required this.aquariumPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.lightGreen[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              aquariumName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Länge: $aquariumLength',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  'Tiefe: $aquariumDepth',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  'Höhe: $aquariumHeight',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Volumen: $aquariumLiter Liter',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  'Preis: $aquariumPrice',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}