import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aquahelper/model/measurement.dart';
import 'package:http/http.dart' as http;

import '../util/datastore.dart';
import 'aquarium.dart';

class AiPlannerStorage {
  int planningMode = 0;
  String aquariumId = "";
  int? availableSpace;
  int? maxVolume;
  bool? needCabinet;
  int? maxCost;
  bool? favoritAnimals;
  String? favoriteFishList;
  String? waterValues;
  bool? useForegroundPlants;
  int? plantingIntensity;
  int? maintenanceEffort;

  AiPlannerStorage();

  createJson() async {
    return {
      'planningMode': convertPlanningMode(),
      'aquariumInfo': await getAquariumInformation(),
      'availableSpace': availableSpace ?? 0,
      'maxVolume': maxVolume ?? 0,
      'needCabinet': needCabinet ?? false,
      'maxCost': maxCost ?? 0,
      'favoritAnimals': favoritAnimals ?? false,
      'favoriteFishList': favoriteFishList ?? "",
      'waterValues': waterValues ?? "",
      'useForegroundPlants': useForegroundPlants ?? false,
      'plantingIntensity': convertSliderIntensity() ?? "",
      'maintenanceEffort': convertSliderIntensity() ?? "",
    };
  }

  convertSliderIntensity() {
    switch (plantingIntensity) {
      case 1:
        return 'sehr gering';
      case 2:
        return 'gering';
      case 3:
        return 'mittel';
      case 4:
        return 'hoch';
      case 5:
        return 'sehr hoch';
    }
  }

  convertPlanningMode() {
    switch (planningMode) {
      case 0:
        return 'Aquarium';
      case 1:
        return 'Besatz';
      case 2:
        return 'Pflanzen';
    }
  }

  getAquariumInformation() async {
    if (planningMode == 0) {
      return "";
    }
    Aquarium aquarium = await Datastore.db.getAquariumById(aquariumId);
    Measurement measurement = await Datastore.db.getSortedMeasurmentsList(
        aquarium).then((value) => value.first);

    String aquariumInformation =
        "Aquarium-Beleuchtung: hoch\n"
            + "zusätzliche Technik: ${aquarium.co2Type > 0
            ? "eine"
            : "keine"} CO2-Anlage\n";

    return "Das Aquarium hat 80 Liter, eine CO2-Anlage und eine mittlere Beleuchtungsstärke";
  }

  Future<Map<String, dynamic>> executePlanning() async {
    final json = await createJson();
    print(jsonEncode(json));
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8001/planner/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(json),
    ).timeout(const Duration(seconds: 120));

    if (response.statusCode == 200) {
      String jsonString = utf8.decode(response.bodyBytes);
      print('Received response with length: ${jsonString.length}');

      try {
        Map<String, dynamic> json = jsonDecode(jsonString);
        log(json.toString());
        return json;
      } catch (e) {
        print('Error decoding JSON: $e');
        return {};
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      return {};
    }
  }
}
