import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/aquarium.dart';
import '../util/dbhelper.dart';
import '../util/scalesize.dart';
import 'infopage.dart';

class FertilizerCalculator extends StatefulWidget {
  const FertilizerCalculator({super.key});

  @override
  State<FertilizerCalculator> createState() => _FertilizerCalculatorState();
}

class _FertilizerCalculatorState extends State<FertilizerCalculator> {
  String? _selectedFertilizer;
  List<String> _fertilizerNames = [];

  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];

  @override
  void initState() {
    super.initState();
    _fetchFertilizers();
    loadAquariums();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await DBHelper.db.getAquariums();
    setState(() {
      _aquariumNames = dbAquariums;
    });
  }

  Future<void> processResponse() async {
    try {
      http.Response response = await sendRequest();

      if (response.statusCode == 200) {
        // Der Request war erfolgreich
        var responseData = jsonDecode(response.body);

        // Verarbeiten Sie die responseData hier...
        print('Response data: $responseData');
      } else {
        // Fehlerbehandlung für nicht erfolgreiche Anfragen
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Fehlerbehandlung für Ausnahmen beim Senden des Requests
      print('Error occurred: $e');
    }
  }

  Future<void> _fetchFertilizers() async {
    final response = await http.get(Uri.parse('https://q6h486sln5.execute-api.eu-west-2.amazonaws.com/v2/getAllFertilizer'));

    if (response.statusCode == 200) {
      List<dynamic> fertilizers = json.decode(response.body);
      setState(() {
        _fertilizerNames = fertilizers.map((fertilizer) => fertilizer['name'].toString()).toList();
      });
    } else {
      throw Exception('Failed to load fertilizers');
    }
  }


  Future<http.Response> sendRequest() {
    int num = 0;
    if(_selectedAquarium?.liter != null){
      num = _selectedAquarium!.liter;
    }
    return http.post(
      Uri.parse('https://q6h486sln5.execute-api.eu-west-2.amazonaws.com/v2/convert'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        'fertilizerInUse': [2],
        'liter': num.toString()
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dünger-Rechner"),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Informationen"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const InfoPage()),
                );
              }
            }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              const Text("Nährstoffe für die Größe deines Aquariums umrechnen:",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Column(
              children: [
                DropdownButton<String>(
                value: _selectedFertilizer,
                hint: Text('Wähle deinen Dünger',
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                    style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black)),
                onChanged: (newValue) {
                  setState(() {
                    _selectedFertilizer = newValue;
                  });
                },
                items: _fertilizerNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        textScaleFactor: ScaleSize.textScaleFactor(context),
                        style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black)),
                  );
                }).toList(),
              ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton<Aquarium>(
                  value: _selectedAquarium,
                  hint: const Text('Wähle dein Aquarium',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black)),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAquarium = newValue;
                    });
                    processResponse();
                  },
                  items: _aquariumNames.map<DropdownMenuItem<Aquarium>>((Aquarium value) {
                    return DropdownMenuItem<Aquarium>(
                      value: value,
                      child: Text(value.name  ,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black)),
                    );
                  }).toList(),
                ),
        ]),
            ],
            ),
            ),
    );
  }
}