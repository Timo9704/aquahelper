import 'dart:convert';

import 'package:aquahelper/model/measurement.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/aquarium.dart';
import '../../util/datastore.dart';

class FertilizerConsumption extends StatefulWidget {
  const FertilizerConsumption({super.key});

  @override
  State<FertilizerConsumption> createState() => _FertilizerConsumptionState();
}

class _FertilizerConsumptionState extends State<FertilizerConsumption> {
  List<Measurement> measurementList = [];
  Measurement measurementIs1 = Measurement("X", "X", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "X", 0);
  Measurement measurementIs2 = Measurement("X", "X", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "X", 0);
  Measurement consumption = Measurement("X", "X", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "X", 0);
  int measurementInterval = 0;

  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];

  @override
  void initState() {
    super.initState();
    loadAquariums();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      _aquariumNames = dbAquariums;
    });
  }

   loadSortedMeasurements(Aquarium aquarium) async {
    List<Measurement> dbMeasurements = await Datastore.db.getSortedMeasurmentsList(aquarium);
    setState(() {
      measurementIs1 = dbMeasurements.elementAt(0);
      measurementIs2 = dbMeasurements.elementAt(1);
      measurementInterval = dbMeasurements.elementAt(1).measurementDate - dbMeasurements.elementAt(0).measurementDate;
    });
  }

  Future<void> processResponse() async {
    await loadSortedMeasurements(_selectedAquarium!);
    final httpResponse = await sendRequest(measurementIs1, measurementIs2);

    if (httpResponse.statusCode == 200) {
      Map<String, dynamic> response = json.decode(httpResponse.body);
      setState(() {
        consumption.nitrate = response['nitrate'];
        consumption.phosphate = response['phosphate'];
        consumption.potassium = response['potassium'];
        consumption.iron = response['iron'];
      });
    }
  }

  Future<http.Response> sendRequest(Measurement measurementIs1, Measurement measurementIs2) {
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
        "days":7
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
                  const Text("Berechne den Nährstoffverbrauch deines Aquariums:",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("1. Wähle das Aquarium aus:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w800)),
                        DropdownButton<Aquarium>(
                          value: _selectedAquarium,
                          hint: const Text('Wähle dein Aquarium',
                              style: TextStyle(
                                  fontSize: 18,
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
                        const Text("2. Nährstoffverbrauch \n(letzten zwei Messungen):",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(
                          height: 10,
                        ),
                        DataTable(
                          horizontalMargin: 0,
                          headingRowHeight: 70.0,
                          columnSpacing: 15.0,
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
                                  'Letzte\nMessung\n(in mg/L)',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Vorletzte\nMessung\n(in mg/L)',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Verbrauch \n(in mg/L)',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                          ],
                          rows: <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Nitrat')),
                                DataCell(Text(measurementIs1.nitrate.toString())),
                                DataCell(Text(measurementIs2.nitrate.toString())),
                                DataCell(Text(consumption.nitrate.toString())),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Phosphat')),
                                DataCell(Text(measurementIs1.phosphate.toString())),
                                DataCell(Text(measurementIs2.phosphate.toString())),
                                DataCell(Text(consumption.phosphate.toString())),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Kalium')),
                                DataCell(Text(measurementIs1.potassium.toString())),
                                DataCell(Text(measurementIs2.potassium.toString())),
                                DataCell(Text(consumption.potassium.toString())),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Eisen')),
                                DataCell(Text(measurementIs1.iron.toString())),
                                DataCell(Text(measurementIs2.iron.toString())),
                                DataCell(Text(consumption.iron.toString())),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightGreen)),
                              onPressed: () => {processResponse()},
                              child: const Text("Berechnen")),
                        )
                      ]),
                ],
              ),
            )]);
  }
}