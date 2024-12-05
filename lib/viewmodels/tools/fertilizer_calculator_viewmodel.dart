import 'dart:convert';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/fertilizer.dart';
import 'package:aquahelper/views/tools/fertilizer/fertilizer_consumption.dart';
import 'package:aquahelper/views/tools/fertilizer/fertilizer_converter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/measurement.dart';
import '../../util/datastore.dart';

class FertilizerCalculatorViewModel extends ChangeNotifier {
  int selectedPage = 0;
  String? selectedFertilizer;
  List<String> fertilizerNames = [];
  final List<Fertilizer> fertilizer = [];
  Fertilizer fertilizer1ml = Fertilizer(0, "", 0, 0, 0, 0, 0, 0);
  double textScaleFactor = 0;
  Aquarium? selectedAquarium;
  List<Aquarium> aquariumNames = [];

  List<Measurement> measurementList = [];
  Measurement measurementIs1 = Measurement("X", "X", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "X", 0, 0, 0);
  Measurement measurementIs2 = Measurement("X", "X", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "X", 0, 0, 0);
  Measurement consumption = Measurement("X", "X", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "X", 0, 0, 0);
  int measurementInterval = 0;

  final pageOptions = [
    const FertilizerConverter(),
    const FertilizerConsumption(),
  ];

  FertilizerCalculatorViewModel() {
    fetchFertilizers();
    loadAquariums();
  }

  setSelectedPage(int value) {
    selectedPage = value;
    notifyListeners();
  }

  setSelectedFertilizer(String? value) {
    selectedFertilizer = value;
    notifyListeners();
  }

  setSelectedAquarium(Aquarium value) {
    selectedAquarium = value;
    notifyListeners();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    aquariumNames = dbAquariums;
    notifyListeners();
  }

  Future<void> processResponse() async {
    int liter = 0;
    List<int> fertilizerIds = [];
    if(selectedAquarium?.liter != null){
      liter = selectedAquarium!.liter;
      fertilizerIds.add((fertilizer.firstWhere((element) => element.name == selectedFertilizer)).id);
      final httpResponse = await sendRequest(fertilizerIds, liter);

      if (httpResponse.statusCode == 200) {
        List<dynamic> response = json.decode(httpResponse.body);
        Fertilizer fertilizer = Fertilizer.fromMap(response.elementAt(0));
          fertilizer1ml = fertilizer;
          notifyListeners();
      }
    }
  }

  Future<void> fetchFertilizers() async {
    final httpResponse = await http.get(Uri.parse('https://q6h486sln5.execute-api.eu-west-2.amazonaws.com/v2/getAllFertilizer'));
    List<String> fertilizerNamesList = [];

    if (httpResponse.statusCode == 200) {
      List<dynamic> response = json.decode(httpResponse.body);
      for(int i = 0; i <response.length; i++){
        Fertilizer fertilizer = Fertilizer.fromMap(response.elementAt(i));
        this.fertilizer.add(fertilizer);
        fertilizerNamesList.add(fertilizer.name);
      }
      fertilizerNames = fertilizerNamesList;
      notifyListeners();
    } else {
      throw Exception('Failed to load fertilizers');
    }
  }


  Future<http.Response> sendRequest(List<int> fertilizerInUse, int liter) {
    return http.post(
      Uri.parse('https://q6h486sln5.execute-api.eu-west-2.amazonaws.com/v2/convert'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        'fertilizerInUse': [fertilizerInUse.first],
        'liter': liter
      }),
    );
  }

  loadSortedMeasurements(Aquarium aquarium) async {
    List<Measurement> dbMeasurements = await Datastore.db.getSortedMeasurmentsList(aquarium);
      measurementIs1 = dbMeasurements.elementAt(0);
      measurementIs2 = dbMeasurements.elementAt(1);
      measurementInterval = dbMeasurements.elementAt(1).measurementDate - dbMeasurements.elementAt(0).measurementDate;
      notifyListeners();
  }

  Future<void> processConsumptionResponse() async {
    await loadSortedMeasurements(selectedAquarium!);
    final httpResponse = await sendConsumptionRequest(measurementIs1, measurementIs2);

    if (httpResponse.statusCode == 200) {
      Map<String, dynamic> response = json.decode(httpResponse.body);
        consumption.nitrate = response['nitrate'];
        consumption.phosphate = response['phosphate'];
        consumption.potassium = response['potassium'];
        consumption.iron = response['iron'];
    }
    notifyListeners();
  }

  Future<http.Response> sendConsumptionRequest(Measurement measurementIs1, Measurement measurementIs2) {
    int days = DateTime.fromMillisecondsSinceEpoch(measurementIs1.measurementDate).difference(DateTime.fromMillisecondsSinceEpoch(measurementIs2.measurementDate)).inDays;
    return http.post(
      Uri.parse('https://q6h486sln5.execute-api.eu-west-2.amazonaws.com/v2/consumption'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        "nitrateIs1": measurementIs1.nitrate,
        "phosphateIs1": measurementIs1.phosphate,
        "potassiumIs1": measurementIs1.potassium,
        "ironIs1": measurementIs1.iron,
        "nitrateIs2": measurementIs2.nitrate,
        "phosphateIs2": measurementIs2.phosphate,
        "potassiumIs2": measurementIs2.potassium,
        "ironIs2": measurementIs2.iron,
        "days": days > 0 ? days : 1
      }),
    );
  }
}


