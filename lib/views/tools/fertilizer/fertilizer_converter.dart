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
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                const Text(
                    "Nährstoffe für die Größe deines Aquariums umrechnen:",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Column(children: [
                  const Text("1. Wähle einen Dünger aus:",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: viewModel.selectedFertilizer,
                    hint: Text('Wähle deinen Dünger',
                        textScaler: TextScaler.linear(textScaleFactor),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black)),
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
                                fontSize: 18, color: Colors.black)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("2. Wähle das Aquarium aus:",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  DropdownButton<Aquarium>(
                    value: viewModel.selectedAquarium,
                    hint: const Text('Wähle dein Aquarium',
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                    onChanged: (newValue) {
                      viewModel.setSelectedAquarium(newValue!);
                    },
                    items: viewModel.aquariumNames
                        .map<DropdownMenuItem<Aquarium>>((Aquarium value) {
                      return DropdownMenuItem<Aquarium>(
                        value: value,
                        child: Text(value.name,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("3. 1 ml Dünger entsprechen:",
                      style: TextStyle(
                          fontSize: 18,
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
                          DataCell(
                              Text(viewModel.fertilizer1ml.nitrate.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Phosphat')),
                          DataCell(Text(
                              viewModel.fertilizer1ml.phosphate.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Kalium')),
                          DataCell(Text(
                              viewModel.fertilizer1ml.potassium.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Eisen')),
                          DataCell(
                              Text(viewModel.fertilizer1ml.iron.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Magnesium')),
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
                              MaterialStateProperty.all(Colors.lightGreen)),
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
