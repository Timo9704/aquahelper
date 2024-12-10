import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/viewmodels/tools/fertilizer_calculator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/scalesize.dart';

class FertilizerConsumption extends StatelessWidget {
  const FertilizerConsumption({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return Consumer<FertilizerCalculatorViewModel>(
      builder: (context, viewModel, child) =>
          ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                "Berechne den Nährstoffverbrauch deines Aquariums der letzten zwei Messungen:",
                textScaler: TextScaler.linear(textScaleFactor),
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "1. Wähle das Aquarium aus:",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                ),
                DropdownButton<Aquarium>(
                  value: viewModel.selectedAquarium,
                  hint: Text(
                    textScaler: TextScaler.linear(textScaleFactor),
                    'Wähle dein Aquarium',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
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
                        textScaler: TextScaler.linear(textScaleFactor),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "2. Nährstoffverbrauch \n(letzten zwei Messungen):",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                      fontSize: 16,
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
                  columns: <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          textScaler: TextScaler.linear(textScaleFactor),
                          'Nährstoff',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Letzte\nMessung\n(in mg/L)',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Vorletzte\nMessung\n(in mg/L)',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Verbrauch\npro Tag\n(in mg/L)',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Nitrat', textScaler: TextScaler.linear(textScaleFactor))),
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
                        DataCell(Text('Phosphat', textScaler: TextScaler.linear(textScaleFactor))),
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
                        DataCell(Text('Kalium', textScaler: TextScaler.linear(textScaleFactor))),
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
                        DataCell(Text('Eisen', textScaler: TextScaler.linear(textScaleFactor))),
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
                            WidgetStateProperty.all(Colors.lightGreen),
                      ),
                      onPressed: () => {viewModel.processConsumptionResponse()},
                      child: Text("Berechnen", textScaler: TextScaler.linear(textScaleFactor))),
                ),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}
