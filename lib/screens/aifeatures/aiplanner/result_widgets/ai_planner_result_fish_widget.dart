import 'package:flutter/material.dart';

class AiPlannerResultFishWidget extends StatelessWidget {
  final String fishCommonName;
  final String fishLatName;
  final String fishPh;
  final String fishGh;
  final String fishKh;
  final String fishMinTemp;
  final String fishMinLiters;
  final String fishLink;

  const AiPlannerResultFishWidget({
    super.key,
    required this.fishCommonName,
    required this.fishLatName,
    required this.fishPh,
    required this.fishGh,
    required this.fishKh,
    required this.fishMinTemp,
    required this.fishMinLiters,
    required this.fishLink,
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                fishCommonName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                fishLatName,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],),
            Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'pH: $fishPh',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'GH: $fishGh',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'KH: $fishKh',
                  style: const TextStyle(fontSize: 16),
                ),
              ],),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Text(
                  'ab $fishMinLiters Liter',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Temperatur: $fishMinTemp°C',
                  style: const TextStyle(fontSize: 16),
                ),
              ],),
          ],
        ),
      ),
    );
  }
}