import 'dart:convert';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/fertilizer.dart';
import 'package:aquahelper/views/tools/fertilizer/fertilizer_consumption.dart';
import 'package:aquahelper/views/tools/fertilizer/fertilizer_converter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    print(selectedAquarium?.liter);
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
}


