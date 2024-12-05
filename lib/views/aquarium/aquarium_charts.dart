import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/aquarium/aquarium_charts_viewmodel.dart';

class AquariumCharts extends StatelessWidget {
  final String aquariumId;
  const AquariumCharts({super.key, required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AquariumChartsViewModel(aquariumId),
        child: Consumer<AquariumChartsViewModel>(
        builder: (context, viewModel, child) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 10,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Wasserwert auswählen:",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                DropdownButton<String>(
                  value: viewModel.dropdownWaterValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (String? value) {
                      viewModel.dropdownWaterValue = value!;
                      viewModel.getChartPoints();
                  },
                  items: viewModel.waterValueMap.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Zeitraum auswählen:     ",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                DropdownButton<String>(
                  value: viewModel.dropdownInterval,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (String? value) {
                      viewModel.dropdownInterval = value!;
                      viewModel.getChartPoints();
                  },
                  items: viewModel.intervalMap.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: viewModel.bottomTitleWidgets,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(),
                    minX: viewModel.xMin,
                    maxX: viewModel.xMax,
                    minY: viewModel.yMin,
                    maxY: viewModel.yMax,
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        preventCurveOverShooting: true,
                        spots: viewModel.chartPoints,
                        barWidth: 4,
                        dotData: const FlDotData(),
                        belowBarData: BarAreaData(
                          show: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            viewModel.chartPoints.isEmpty
                ? const Text(
              "Keine Messungen vorhanden",
              style: TextStyle(
                fontSize: 15,
                color: Colors.red,
              ),
            ) :
            const Text(
              "Messung",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ),),);
  }
}
