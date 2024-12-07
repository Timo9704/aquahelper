import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AiPlannerResultFishWidget extends StatelessWidget {
  final String fishCommonName;
  final String fishLatName;
  final String fishPh;
  final String fishGh;
  final String fishKh;
  final String fishMinTemp;
  final String fishMinLiters;
  final String? link;

  const AiPlannerResultFishWidget({
    super.key,
    required this.fishCommonName,
    required this.fishLatName,
    required this.fishPh,
    required this.fishGh,
    required this.fishKh,
    required this.fishMinTemp,
    required this.fishMinLiters,
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
                        fishCommonName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        fishLatName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
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
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('ab $fishMinLiters Liter', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 20),
                Text('Temperatur: $fishMinTemp', style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 3), // Ein bisschen Abstand zwischen den Reihen
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('pH ca. $fishPh', style: const TextStyle(fontSize: 12)),
                Text('GH ca. $fishGh', style: const TextStyle(fontSize: 12)),
                Text('KH ca. $fishKh', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
