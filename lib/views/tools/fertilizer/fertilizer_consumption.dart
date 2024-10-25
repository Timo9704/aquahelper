import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/viewmodels/tools/fertilizer_calculator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FertilizerConsumption extends StatelessWidget {
  const FertilizerConsumption({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FertilizerCalculatorViewModel>(
      builder: (context, viewModel, child) =>
          ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              const Text(
                "Berechne den Nährstoffverbrauch deines Aquariums:",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Column(children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "1. Wähle das Aquarium aus:",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                ),
                DropdownButton<Aquarium>(
                  value: viewModel.selectedAquarium,
                  hint: const Text(
                    'Wähle dein Aquarium',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onChanged: (newValue) {
                    viewModel.setSelectedAquarium(newValue!);
                  },
                  items: viewModel.aquariumNames
                      .map<DropdownMenuItem<Aquarium>>((Aquarium value) {
                    return DropdownMenuItem<Aquarium>(
                      value: value,
                      child: Text(
                        value.name,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "2. Nährstoffverbrauch \n(letzten zwei Messungen):",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                ),
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
                        DataCell(
                            Text(viewModel.measurementIs1.nitrate.toString())),
                        DataCell(
                            Text(viewModel.measurementIs2.nitrate.toString())),
                        DataCell(
                            Text(viewModel.consumption.nitrate.toString())),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('Phosphat')),
                        DataCell(Text(
                            viewModel.measurementIs1.phosphate.toString())),
                        DataCell(Text(
                            viewModel.measurementIs2.phosphate.toString())),
                        DataCell(
                            Text(viewModel.consumption.phosphate.toString())),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('Kalium')),
                        DataCell(Text(
                            viewModel.measurementIs1.potassium.toString())),
                        DataCell(Text(
                            viewModel.measurementIs2.potassium.toString())),
                        DataCell(
                            Text(viewModel.consumption.potassium.toString())),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('Eisen')),
                        DataCell(
                            Text(viewModel.measurementIs1.iron.toString())),
                        DataCell(
                            Text(viewModel.measurementIs2.iron.toString())),
                        DataCell(Text(viewModel.consumption.iron.toString())),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightGreen),
                      ),
                      onPressed: () => {viewModel.processConsumptionResponse()},
                      child: const Text("Berechnen")),
                ),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}
