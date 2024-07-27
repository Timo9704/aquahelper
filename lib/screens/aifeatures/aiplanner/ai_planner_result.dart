import 'package:aquahelper/screens/aifeatures/aiplanner/result_widgets/ai_planner_result_aquarium_widget.dart';
import 'package:aquahelper/screens/aifeatures/aiplanner/result_widgets/ai_planner_result_fish_widget.dart';
import 'package:aquahelper/screens/aifeatures/aiplanner/result_widgets/ai_planner_result_plant_widget.dart';
import 'package:flutter/material.dart';

import 'ai_planner_guide.dart';

class AiPlannerResult extends StatefulWidget {
  final Map<String, dynamic> jsonData;
  final int planningMode;

  const AiPlannerResult(
      {super.key, required this.jsonData, required this.planningMode});

  @override
  State<AiPlannerResult> createState() => _AiPlannerResultState();
}

class _AiPlannerResultState extends State<AiPlannerResult> {
  double textScaleFactor = 0;

  @override
  void initState() {
    super.initState();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Anleitung':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AiPlannerGuide()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.jsonData;

    return Scaffold(
        appBar: AppBar(
          title: const Text("KI-Planer"),
          backgroundColor: Colors.lightGreen,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Anleitung'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(height: 5),
          const Text("Planungsergebnis",
              style: TextStyle(fontSize: 25, color: Colors.black)),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                if (widget.planningMode == 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Aquarium",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AiPlannerResultAquariumWidget(
                        aquariumName: data['aquarium']['aquarium_name'],
                        aquariumLength: data['aquarium']['aquarium_length'],
                        aquariumDepth: data['aquarium']['aquarium_depth'],
                        aquariumHeight: data['aquarium']['aquarium_height'],
                        aquariumLiter: data['aquarium']['aquarium_liter'],
                        aquariumPrice: data['aquarium']['aquarium_price'],
                      ),
                    ],
                  ),
                if (widget.planningMode == 0 || widget.planningMode == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Fische",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        children: data['fishes'].map<Widget>((fish) {
                          return AiPlannerResultFishWidget(
                            fishCommonName: fish['fish_common_name'],
                            fishLatName: fish['fish_lat_name'],
                            fishPh: fish['fish_ph'],
                            fishGh: fish['fish_gh'],
                            fishKh: fish['fish_kh'],
                            fishMinTemp: fish['fish_min_temp'],
                            fishMinLiters: fish['fish_min_liters'],
                            fishLink: fish['fish_link'],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                if (widget.planningMode == 0 || widget.planningMode == 2)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Pflanzen",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        children: data['plants'].map<Widget>((plant) {
                          return AiPlannerResultPlantWidget(
                            plantName: plant['plant_name'],
                            plantType: plant['plant_type'],
                            plantGrowthRate: plant['plant_growth_rate'],
                            plantLightDemand: plant['plant_light_demand'],
                            plantCo2Demand: plant['plant_co2_demand'],
                            plantLink: plant['plant_link'],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.93,
                  ),
                  child: Text(data['reason'], style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightGreen),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(300, 70)),
                  ),
                  child: const Text(
                      "Planung finalisieren & Links suchen",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ])));
  }
}
