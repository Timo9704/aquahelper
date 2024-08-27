import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:aquahelper/model/activity.dart';
import 'package:aquahelper/model/components/filter.dart';
import 'package:aquahelper/model/components/lighting.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../util/datastore.dart';
import 'aquarium.dart';
import 'components/heater.dart';
import 'measurement.dart';


class AiOptimizerStorage {
  String aquariumId = "";
  bool? waterClear;
  String waterTurbidity = "";
  String? aquariumProblemDescription;
  bool? fishHealthProblem;
  bool? fishDiverseFeed;
  String? fishProblemDescription;
  bool? plantGrowthProblem;
  bool? plantDeficiencySymptom;
  String? plantDeficiencySymptomDescription;
  String? plantProblemDescription;

  AiOptimizerStorage();

  createJson() async {
    return {
      'aquariumInfo': await getAquariumInformation(),
      'aquariumTechInfo': await getAquariumTechInformation(),
      'latest10Measurements': await getLatest3Measurements(),
      'allActivities': await getAllActivities(),
      'waterClear': waterClear ?? true,
      'waterTurbidity': waterTurbidity,
      'aquariumProblemDescription': aquariumProblemDescription ?? "",
      'fishHealthProblem': fishHealthProblem ?? false,
      'fishDiverseFeed': fishDiverseFeed ?? false,
      'fishProblemDescription': fishProblemDescription ?? "",
      'plantGrowthProblem': plantGrowthProblem ?? false,
      'plantDeficiencySymptom': plantDeficiencySymptom ?? false,
      'plantDeficiencySymptomDescription': plantDeficiencySymptomDescription ?? "",
      'plantProblemDescription': plantProblemDescription ?? "",
    };
  }

  getAquariumInformation() async {
    //Get general information about the aquarium
    Aquarium aquarium = await Datastore.db.getAquariumById(aquariumId);
    String aquariumInfo =
        "Aquarium ${aquarium.name} mit ${aquarium.liter} Liter Volumen. "
        "Die Maße betragen: Länge=${aquarium.width}cm, Breite=${aquarium.height}cm, Höhe=${aquarium.depth}cm. "
        "Das Aquarium ${aquarium.co2Type > 0 ? "hat eine CO2-Anlage." : "hat keine CO2-Anlage."} ";

    return aquariumInfo;
  }

  Future<String> getAquariumTechInformation() async {
    //Get all technical components of the aquarium
    Aquarium aquarium = await Datastore.db.getAquariumById(aquariumId);
    Lighting lighting = (await Datastore.db.getLightingByAquarium(aquarium.aquariumId)).first;
    double brightnessLevel = 0;
    if(lighting.brightness != 0) {
      int brightness = lighting.brightness;
      brightnessLevel = brightness / aquarium.liter;
    }
    String level = brightnessLevel < 20 ? "NIEDRIG" : brightnessLevel < 40 ? "MITTEL" : "HOCH";
    Filter filter = (await Datastore.db.getFilterByAquarium(aquarium.aquariumId)).first;
    Heater heater = (await Datastore.db.getHeaterByAquarium(aquarium.aquariumId)).first;

    String technicalInfo = "Die Beleuchtungstärke der Beleuchtung ist $level und beleuchtet das Aquarium ${lighting.onTime} Stunden pro Tag. "
        "Die Modellbezeichnung der Lampe ist ${lighting.manufacturerModelName}. "
        "Der Filter ist ${filter.getFilterType()} und hat eine Leistung von ${filter.flowRate} l/h. "
        "Der Filter wurde vor ${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(filter.lastMaintenance)).inDays} Tagen zuletzt gereinigt. "
        "Der Heizer hat eine Leistung von ${heater.power} Watt. ";
    return technicalInfo;
  }

  Future<String> getAllActivities() async {
    //Get all activities
    Aquarium aquarium = await Datastore.db.getAquariumById(aquariumId);
    List<Activity> activityList = await Datastore.db.getActivitiesForAquarium(aquarium.aquariumId);
    StringBuffer latest10Activities = StringBuffer();

    for (var i = 0; i < min(10, activityList.length); i++) {
      Activity activity = activityList[i];
      int daysAgo = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(activity.date)).inDays;

      latest10Activities.write("Aktivitäten vor $daysAgo Tagen waren: '${activity.activities}'. ${activity.notes.isNotEmpty ? 'Notizen: ${activity.notes}' : ''} ");
    }
    return latest10Activities.toString();
  }

  Future<String> getLatest3Measurements() async {
    //Get latest measurements
    Aquarium aquarium = await Datastore.db.getAquariumById(aquariumId);
    List<Measurement> measurementList = await Datastore.db.getSortedMeasurmentsList(aquarium);
    StringBuffer latest10Measurements = StringBuffer();

    for (var i = 0; i < min(10, measurementList.length); i++) {
      Measurement measurement = measurementList[i];
      int daysAgo = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(measurement.measurementDate)).inDays;

      latest10Measurements.write("Die Messungen vor $daysAgo Tagen ergaben: pH-Wert=${measurement.ph}, "
          "Gesamthärte=${measurement.totalHardness}, Karbonathärte=${measurement.carbonateHardness}, "
          "Nitrit=${measurement.nitrite}, Nitrat=${measurement.nitrate}, Phosphat=${measurement.phosphate}, "
          "Eisen=${measurement.iron}, Leitwert=${measurement.conductance} ");
    }
    return latest10Measurements.toString();
  }


  Future<Response> executeRequest() async {
    getAquariumInformation();
    final json = await createJson();
    final response = await http.post(
      Uri.parse('https://qklobhln70.execute-api.eu-west-2.amazonaws.com/v1/optimizer/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(json),
    ).timeout(const Duration(seconds: 120));

    return response;
  }

  Future<Map<String, dynamic>> executeOptimizer() async {
    final response = await executeRequest();

    if (response.statusCode == 200) {
      String jsonString = utf8.decode(response.bodyBytes);
      try {
        Map<String, dynamic> json = jsonDecode(jsonString);
        return json;
      } catch (e) {
        Exception('Can not decode json');
        return {};
      }
      //in case of 500 status code retry the request once
    } else if(response.statusCode == 500) {
      final response = await executeRequest();

      if (response.statusCode == 200) {
        String jsonString = utf8.decode(response.bodyBytes);
        try {
          Map<String, dynamic> json = jsonDecode(jsonString);
          return json;
        } catch (e) {
          Exception('Can not decode json');
          return {};
        }
      }else{
        return {};
      }
    } else{
      return {};
    }
  }
}
