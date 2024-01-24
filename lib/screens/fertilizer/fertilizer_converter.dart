import 'dart:convert';

import 'package:aquahelper/model/fertilizer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/aquarium.dart';
import '../../util/dbhelper.dart';
import '../../util/scalesize.dart';

class FertilizerConverter extends StatefulWidget {
  const FertilizerConverter({super.key});

  @override
  State<FertilizerConverter> createState() => _FertilizerConverterState();
}

class _FertilizerConverterState extends State<FertilizerConverter> {
  String? _selectedFertilizer;
  List<String> _fertilizerNames = [];
  final List<Fertilizer> _fertilizer = [];
  Fertilizer fertilizer1ml = Fertilizer(0, "", 0, 0, 0, 0, 0, 0);

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
    int liter = 0;
    List<int> fertilizerIds = [];
    if(_selectedAquarium?.liter != null){
      liter = _selectedAquarium!.liter;
      fertilizerIds.add((_fertilizer.firstWhere((element) => element.name == _selectedFertilizer)).id);
      final httpResponse = await sendRequest(fertilizerIds, liter);

      if (httpResponse.statusCode == 200) {
        List<dynamic> response = json.decode(httpResponse.body);
        Fertilizer fertilizer = Fertilizer.fromMap(response.elementAt(0));
        setState(() {
          fertilizer1ml = fertilizer;
        });
      }
    }
  }

  Future<void> _fetchFertilizers() async {
    final httpResponse = await http.get(Uri.parse('https://q6h486sln5.execute-api.eu-west-2.amazonaws.com/v2/getAllFertilizer'));
    List<String> fertilizerNamesList = [];

    if (httpResponse.statusCode == 200) {
      List<dynamic> response = json.decode(httpResponse.body);
      for(int i = 0; i <response.length; i++){
        Fertilizer fertilizer = Fertilizer.fromMap(response.elementAt(i));
        _fertilizer.add(fertilizer);
        fertilizerNamesList.add(fertilizer.name);
      }

      setState(() {
        _fertilizerNames = fertilizerNamesList;
      });
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
        'fertilizerInUse': [fertilizerInUse],
        'liter': 19
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
      Padding(
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
                  const Text("1. Wähle einen Dünger aus:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
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
                  const Text("2. Wähle das Aquarium aus:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
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
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("3. 1 ml Dünger entsprechen:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 10,
                  ),
                  DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Nährstoff',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Menge \n(in mg/L)',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Nitrat')),
                          DataCell(Text(fertilizer1ml.nitrate.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Phosphat')),
                          DataCell(Text(fertilizer1ml.phosphate.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Kalium')),
                          DataCell(Text(fertilizer1ml.potassium.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Eisen')),
                          DataCell(Text(fertilizer1ml.iron.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Magnesium')),
                          DataCell(Text(fertilizer1ml.magnesium.toString())),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () => {processResponse()},
                        child: const Text("Berechnen")),
                  )
                ]),
          ],
        ),
      )]);
  }
}