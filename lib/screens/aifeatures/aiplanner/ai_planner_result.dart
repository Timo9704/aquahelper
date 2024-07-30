import 'dart:developer';

import 'package:aquahelper/screens/aifeatures/aiplanner/result_widgets/ai_planner_result_aquarium_widget.dart';
import 'package:aquahelper/screens/aifeatures/aiplanner/result_widgets/ai_planner_result_fish_widget.dart';
import 'package:aquahelper/screens/aifeatures/aiplanner/result_widgets/ai_planner_result_plant_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool _isLoading = false;

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

  Future<void> fetchLinks() async {
    setState(() {
      _isLoading = true;
    });

    const apiUrl =
        'https://qklobhln70.execute-api.eu-west-2.amazonaws.com/v1/links/'; // Ersetzen Sie dies durch Ihre API-URL
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "aquarium": {
        "aquarium_name": widget.planningMode == 0 ? widget.jsonData['aquarium']['aquarium_name'] : "",
      },
      "fishes": widget.planningMode == 0 || widget.planningMode == 1 ? widget.jsonData['fishes']
          .map((fish) => {"fish_lat_name": fish['fish_lat_name']})
          .toList() : [],
      "plants": widget.planningMode == 0 || widget.planningMode == 2 ? widget.jsonData['plants']['plants']
          .map((plant) => {"plant_name": plant['plant_name']})
          .toList() : [],
    });

    final response =
        await http.post(Uri.parse(apiUrl), headers: headers, body: body);
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        setState(() {
          if(widget.planningMode == 0){
            widget.jsonData['aquarium']['link'] = data['aquarium']['link'];
          }

          if(widget.planningMode == 0 || widget.planningMode == 1) {
            for (var fish in widget.jsonData['fishes']) {
              var matchingFish = data['fishes']?.firstWhere(
                      (element) =>
                  element['fish_lat_name'] == fish['fish_lat_name'],
                  orElse: () => null);
              if (matchingFish != null) {
                fish['link'] = matchingFish['fish_link'];
              }
            }
          }

          if(widget.planningMode == 0 || widget.planningMode == 2) {
            for (var plant in widget.jsonData['plants']['plants']) {
              var matchingPlant = data['plants']?.firstWhere(
                      (element) => element['plant_name'] == plant['plant_name'],
                  orElse: () => null);
              if (matchingPlant != null) {
                plant['link'] = matchingPlant['plant_link'];
              }
            }
          }
        });
      } catch (e) {
        log(e.toString());
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false; // Ladezustand deaktivieren
    });
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                            filterName: data['technic'][0]['filter_name'],
                            filterIncluded: data['technic'][0]['filter_included'],
                            heaterName: data['technic'][1]['heater_name'],
                            heaterIncluded: data['technic'][1]['heater_included'],
                            lightName: data['technic'][2]['lighting_name'],
                            lightIncluded: data['technic'][2]['lighting_included'],
                            link: data['aquarium']['link'],
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
                                link: fish['link'], // Hinzufügen des Links
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
                            children: data['plants']['plants'].map<Widget>((plant) {
                              return AiPlannerResultPlantWidget(
                                plantName: plant['plant_name'],
                                plantType: plant['plant_type'],
                                plantGrowthRate: plant['plant_growth_rate'],
                                plantLightDemand: plant['plant_light_demand'],
                                plantCo2Demand: plant['plant_co2_demand'],
                                link: plant['link'],
                              );
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                elevation: 4,
                                color: Colors.lightGreen[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "empf. Menge\nVordergrund",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "ca. ${data['plants']['foreground_plants']}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 4,
                                color: Colors.lightGreen[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "empf. Menge\nMittelgrund",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "ca. ${data['plants']['foreground_plants']}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 4,
                                color: Colors.lightGreen[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "empf. Menge\nHintergrund",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "ca. ${data['plants']['foreground_plants']}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
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
                      child: Text(data['reason'],
                          style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        fetchLinks();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightGreen),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(300, 70)),
                      ),
                      child: const Text("Planung finalisieren & Links suchen",
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        "Der KI-Planer kann Fehler machen. Überprüfe wichtige Informationen.",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w300)),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ]),
          ),
          if (_isLoading)
            Container(
              color: Colors.black87,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          strokeWidth: 15,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Einen Moment Geduld, bitte!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Die Links werden geladen.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Dieser Vorgang kann einige Zeit in Anspruch nehmen.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
