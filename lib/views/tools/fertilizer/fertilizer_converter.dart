import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/aquarium.dart';
import '../../../util/scalesize.dart';
import '../../../viewmodels/tools/fertilizer_calculator_viewmodel.dart';

class FertilizerConverter extends StatelessWidget {
  const FertilizerConverter({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return Consumer<FertilizerCalculatorViewModel>(
      builder: (context, viewModel, child) => ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                    "Nährstoffkonzentrationen eines Düngers für die Größe deines Aquariums umrechnen:",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black)),
                const SizedBox(height: 10),
                Column(children: [
                  Text("1. Wähle einen Dünger aus:",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 5),
                  DropdownButton<String>(
                    value: viewModel.selectedFertilizer,
                    hint: Text('Wähle deinen Dünger',
                        textScaler: TextScaler.linear(textScaleFactor),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black)),
                    onChanged: (newValue) {
                      viewModel.setSelectedFertilizer(newValue);
                    },
                    items: viewModel.fertilizerNames
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("2. Wähle das Aquarium aus:",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 5),
                  DropdownButton<Aquarium>(
                    value: viewModel.selectedAquarium,
                    hint: Text('Wähle dein Aquarium',
                        textScaler: TextScaler.linear(textScaleFactor),
                        style: const TextStyle(fontSize: 16, color: Colors.black),),
                    onChanged: (newValue) {
                      viewModel.setSelectedAquarium(newValue!);
                    },
                    items: viewModel.aquariumNames
                        .map<DropdownMenuItem<Aquarium>>((Aquarium value) {
                      return DropdownMenuItem<Aquarium>(
                        value: value,
                        child: Text(value.name,
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("3. 1 ml Dünger entsprechen:",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 10,
                  ),
                  DataTable(
                    dataRowMaxHeight: 40,
                    dataRowMinHeight: 20,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Nährstoff',
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Menge \n(in mg/L)',
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Nitrat', textScaler: TextScaler.linear(textScaleFactor)),),
                          DataCell(
                              Text(viewModel.fertilizer1ml.nitrate.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Phosphat', textScaler: TextScaler.linear(textScaleFactor)),),
                          DataCell(Text(
                              viewModel.fertilizer1ml.phosphate.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Kalium',textScaler: TextScaler.linear(textScaleFactor)),),
                          DataCell(Text(
                              viewModel.fertilizer1ml.potassium.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Eisen',textScaler: TextScaler.linear(textScaleFactor)),),
                          DataCell(
                              Text(viewModel.fertilizer1ml.iron.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Magnesium', textScaler: TextScaler.linear(textScaleFactor)),),
                          DataCell(Text(
                              viewModel.fertilizer1ml.magnesium.toString())),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.lightGreen)),
                      onPressed: () => {viewModel.processResponse()},
                      child: const Text("Berechnen"),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
