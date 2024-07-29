import 'dart:convert';
import 'package:aquahelper/model/components/lighting.dart';
import 'package:http/http.dart' as http;

import '../util/datastore.dart';
import 'aquarium.dart';
import 'measurement.dart';


class AiPlannerStorage {
  int planningMode = 0;
  String aquariumId = "";
  int? availableSpace;
  int? maxVolume;
  bool? needCabinet;
  int? maxCost;
  String? favoriteFishList;
  String? waterValues;
  bool? useForegroundPlants;
  bool? useMossPlants;
  int? growthRate;

  AiPlannerStorage();

  createJson() async {
    return {
      'planningMode': convertPlanningMode(),
      'aquariumInfo': await getAquariumInformation(),
      'availableSpace': availableSpace ?? 0,
      'maxVolume': maxVolume ?? 0,
      'needCabinet': needCabinet ?? false,
      'maxCost': maxCost ?? 0,
      'favoriteFishList': favoriteFishList ?? "",
      'waterValues': waterValues ?? "",
      'useForegroundPlants': useForegroundPlants ?? false,
      'useMossPlants': useMossPlants ?? false,
      'maintenanceEffort': convertSliderIntensity() ?? "",
    };
  }

  convertSliderIntensity() {
    switch (growthRate) {
      case 1:
        return 'niedrig';
      case 2:
        return 'mittel';
      case 3:
        return 'hoch';
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
    double brightnessLevel = 0;
    double ph = 0;
    double gh = 0;
    double kh = 0;

    if (planningMode == 0 || aquariumId == "") {
      return "";
    }

    Aquarium aquarium = await Datastore.db.getAquariumById(aquariumId);
    Lighting lighting = Datastore.db.getLightingByAquarium(aquarium.aquariumId);
    if(lighting.brightness != 0) {
      int brightness = lighting.brightness;
      brightnessLevel = brightness / aquarium.liter;
    }
    Measurement measurement = await Datastore.db.getSortedMeasurmentsList(
        aquarium).then((value) => value.first);
    if(measurement.ph != 0 && measurement.totalHardness != 0 && measurement.carbonateHardness != 0) {
      ph = measurement.ph;
      gh = measurement.totalHardness;
      kh = measurement.carbonateHardness;
    }

    String aquariumInformation =
        "Das Aquarium hat ${aquarium.liter} Liter. Es hat ${aquarium.co2Type > 0 ? "EINE" : "KEINE"} CO2-Anlage. Die Beleuchtungstärke der Beleuchtung ist ${brightnessLevel < 20 ? "NIEDRIG" : brightnessLevel < 40 ? "MITTEL" : "HOCH"}."
        "Die Wasserwerte sind: pH: $ph, GH: $gh, KH: $kh";

    return aquariumInformation;
  }

  Future<Map<String, dynamic>> executePlanning() async {
    final json = await createJson();
    final response = await http.post(
      Uri.parse('https://qklobhln70.execute-api.eu-west-2.amazonaws.com/v1/planner/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(json),
    ).timeout(const Duration(seconds: 120));

    if (response.statusCode == 200) {
      String jsonString = utf8.decode(response.bodyBytes);

      try {
        Map<String, dynamic> json = jsonDecode(jsonString);
        return json;
      } catch (e) {
        Exception('Failed to load data');
        return {};
      }
    } else {
      Exception('Failed to load data');
      return {};
    }
  }
}
