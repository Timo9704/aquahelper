import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AiPlannerResultAquariumWidget extends StatelessWidget {
  final String aquariumName;
  final String aquariumLength;
  final String aquariumDepth;
  final String aquariumHeight;
  final String aquariumLiter;
  final String aquariumPrice;
  final String filterName;
  final String filterIncluded;
  final String heaterName;
  final String heaterIncluded;
  final String lightName;
  final String lightIncluded;
  final String? link;

  const AiPlannerResultAquariumWidget({
    super.key,
    required this.aquariumName,
    required this.aquariumLength,
    required this.aquariumDepth,
    required this.aquariumHeight,
    required this.aquariumLiter,
    required this.aquariumPrice,
    required this.filterName,
    required this.filterIncluded,
    required this.heaterName,
    required this.heaterIncluded,
    required this.lightName,
    required this.lightIncluded,
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
                        aquariumName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Volumen: $aquariumLiter Liter',
                            style: const TextStyle(fontSize: 14)
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Preis: $aquariumPrice',
                            style: const TextStyle(fontSize: 14)
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filter: $filterName',
                            style: const TextStyle(fontSize: 12)
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '- als Set: $filterIncluded',
                            style: const TextStyle(fontSize: 12)
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Heizer: $heaterName',
                            style: const TextStyle(fontSize: 12)
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '- als Set: $heaterIncluded',
                            style: const TextStyle(fontSize: 12)
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Leuchte: $lightName',
                            style: const TextStyle(fontSize: 12)
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '- als Set: $lightIncluded',
                            style: const TextStyle(fontSize: 12)
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Länge: $aquariumLength',
                            style: const TextStyle(fontSize: 12)
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Tiefe: $aquariumDepth',
                            style: const TextStyle(fontSize: 12)
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Höhe: $aquariumHeight',
                            style: const TextStyle(fontSize: 12)
                          ),
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
