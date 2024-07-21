import 'dart:convert';

import 'package:http/http.dart' as http;

class AiPlannerStorage {
  int? planningMode;
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

  createJson() {
    return {
      'planningMode': convertPlanningMode(),
      'availableSpace': availableSpace,
      'maxVolume': maxVolume,
      'needCabinet': needCabinet,
      'maxCost': maxCost,
      'favoritAnimals': favoritAnimals,
      'favoriteFishList': favoriteFishList,
      'waterValues': waterValues,
      'useForegroundPlants': useForegroundPlants,
      'plantingIntensity': convertSliderIntensity(),
      'maintenanceEffort': convertSliderIntensity(),
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
        return 'Gesamtes Aquarium';
      case 1:
        return 'nur Bepflanzung';
      case 2:
        return 'nur Besatz';
    }
  }

  executePlanning() async {
    final response = await http.post(
      Uri.parse('https://1gbk36sq3g.execute-api.eu-west-2.amazonaws.com/v1/planner'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: createJson(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
  }
}
