import 'package:flutter/material.dart';

class AiPlannerResultPlantWidget extends StatelessWidget {
  final String plantName;
  final String plantType;
  final String plantGrowthRate;
  final String plantLightDemand;
  final String plantCo2Demand;
  final String plantLink;

  const AiPlannerResultPlantWidget({
    super.key,
    required this.plantName,
    required this.plantType,
    required this.plantGrowthRate,
    required this.plantLightDemand,
    required this.plantCo2Demand,
    required this.plantLink,
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
            Row(children: [
              Text(
                plantName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
            ],),
            Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(
                      'Typ: $plantType',
                      style: const TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Wachstumsrate: $plantGrowthRate',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Lichtbedarf: $plantLightDemand',
                      style: const TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'CO2-Bedarf: $plantCo2Demand',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
              ],),
          ],
        ),
      ),
    );
  }
}