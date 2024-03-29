import 'package:flutter/material.dart';
import '../../model/aquarium.dart';
import '../../util/datastore.dart';

class DashboardHealthStatus extends StatefulWidget {
  const DashboardHealthStatus({super.key});

  @override
  State<DashboardHealthStatus> createState() => _DashboardHealthStatusState();
}

class _DashboardHealthStatusState extends State<DashboardHealthStatus> {
  List<Aquarium> aquariums = [];

  @override
  void initState() {
    super.initState();
    loadAquariums();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      aquariums = dbAquariums;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const Text('Health Status', style: TextStyle(fontSize: 17, color: Colors.black)),
            SizedBox(
              height: 70, // Festgelegte Höhe für den scrollbaren Bereich
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: aquariums.map((aquarium) => buildAquariumItem(aquarium)).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAquariumItem(Aquarium aquarium) {
    List<Color> colorCodes = [Colors.green, Colors.yellow, Colors.orange, Colors.red];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lightbulb, size: 35, color: colorCodes.elementAt(aquarium.healthStatus)),
          const SizedBox(height: 10),
          Text(aquarium.name, style: const TextStyle(fontSize: 12, color: Colors.black))
        ],
      ),
    );
  }
}
