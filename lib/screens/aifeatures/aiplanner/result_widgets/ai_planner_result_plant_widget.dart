import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AiPlannerResultPlantWidget extends StatelessWidget {
  final String plantName;
  final String plantType;
  final String plantGrowthRate;
  final String plantLightDemand;
  final String plantCo2Demand;
  final String? link;

  const AiPlannerResultPlantWidget({
    super.key,
    required this.plantName,
    required this.plantType,
    required this.plantGrowthRate,
    required this.plantLightDemand,
    required this.plantCo2Demand,
    this.link,
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
            Row(
              children: [
                Expanded(
                  flex: link == null ? 1 : 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plantName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Typ: $plantType',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lichtbedarf: $plantLightDemand', style: const TextStyle(fontSize: 12)),
                          Text('CO2: $plantCo2Demand', style: const TextStyle(fontSize: 12)),
                          Text('Wachstum: $plantGrowthRate', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (link != null)
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse(link!))) {
                          await launchUrl(Uri.parse(link!));
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
