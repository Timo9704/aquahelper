import 'package:aquahelper/model/measurement.dart';
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
    checkHealthStatus();
  }

  checkHealthStatus() async {
    for (int i = 0; i < aquariums.length; i++) {
      DateTime now = DateTime.now();
      DateTime interval7 = now.subtract(const Duration(days: 7));
      DateTime interval14 = now.subtract(const Duration(days: 14));
      DateTime interval30 = now.subtract(const Duration(days: 30));
      List<Measurement> list = await Datastore.db.getMeasurementsByInterval(aquariums[i].aquariumId, now.millisecondsSinceEpoch, interval7.millisecondsSinceEpoch);
      if(list.isEmpty){
        list = await Datastore.db.getMeasurementsByInterval(aquariums[i].aquariumId, now.millisecondsSinceEpoch, interval14.millisecondsSinceEpoch);
        if(list.isEmpty) {
          list = await Datastore.db.getMeasurementsByInterval(aquariums[i].aquariumId, now.millisecondsSinceEpoch, interval30.millisecondsSinceEpoch);
          if(list.isEmpty){
            aquariums[i].healthStatus = 3;
          }else {
            aquariums[i].healthStatus = 2;
          }
        }else{
          aquariums[i].healthStatus = 1;
        }
      }else{
        aquariums[i].healthStatus = 0;
      }
      await Datastore.db.updateAquarium(aquariums[i]);
    }
    setState(() {
      aquariums = aquariums;
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
            const Text('keine Messung in den letzten 7 Tagen (gelb) / 14 (orange) / 30 (rot) ', style: TextStyle(fontSize: 9, color: Colors.black)),
            const SizedBox(height: 5),
            SizedBox(
              height: 60,
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
          Icon(Icons.lightbulb, size: 30, color: colorCodes.elementAt(aquarium.healthStatus)),
          const SizedBox(height: 3),
          Text(aquarium.name, style: const TextStyle(fontSize: 12, color: Colors.black))
        ],
      ),
    );
  }
}
