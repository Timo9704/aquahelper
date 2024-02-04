import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:aquahelper/model/measurement.dart';
import 'package:aquahelper/util/dbhelper.dart';

var waterValueMap = {
  'Temperatur': 'temperature',
  'pH-Wert': 'ph',
  'Gesamthärte': 'totalHardness',
  'Karbonathärte': 'carbonateHardness',
  'Nitrit': 'nitrite',
  'Nitrat': 'nitrate',
  'Phosphat': 'phosphate',
  'Kalium': 'potassium',
  'Eisen': 'iron',
  'Magnesium': 'magnesium',
};

var intervalMap = {
  '1 Woche': 604800000,
  '2 Wochen': 1209600000,
  '3 Wochen': 1814400000,
  '4 Wochen': 2419200000
};

class ChartAnalysis extends StatefulWidget {
  final String aquariumId;

  const ChartAnalysis({super.key, required this.aquariumId});

  @override
  ChartAnalysisState createState() => ChartAnalysisState();
}

class ChartAnalysisState extends State<ChartAnalysis> {
  String dropdownWaterValue = waterValueMap.keys.first;
  String dropdownInterval = intervalMap.keys.first;
  List<FlSpot> chartPoints = [];
  double xMin = 0;
  double yMin = 0;
  double xMax = 0;
  double yMax = 0;

  @override
  void initState() {
    super.initState();
    getChartPoints();
  }

  void getXYMinMax() {
    double xMin = chartPoints.elementAt(0).x;
    double yMin = chartPoints.elementAt(0).y;
    double xMax = chartPoints.elementAt(0).x;
    double yMax = chartPoints.elementAt(0).y;
    for (int i = 0; i < chartPoints.length; i++) {
      if (xMin > chartPoints.elementAt(i).x) {
        xMin = chartPoints.elementAt(i).x;
      }
      if (xMax < chartPoints.elementAt(i).x) {
        xMax = chartPoints.elementAt(i).x;
      }
      if (yMin > chartPoints.elementAt(i).y) {
        yMin = chartPoints.elementAt(i).y;
      }
      if (yMax < chartPoints.elementAt(i).y) {
        yMax = chartPoints.elementAt(i).y;
      }
    }
    this.xMin = xMin;
    this.yMin = yMin;
    this.xMax = xMax;
    this.yMax = yMax + 1;
  }

  Future<List<Measurement>> getMeasurementsByInterval() async {
    int startInterval = ((DateTime.now().toUtc().millisecondsSinceEpoch));
    int endInterval = startInterval - intervalMap[dropdownInterval]!;
    List<Measurement> measurementsInInterval = await DBHelper.db
        .getMeasurementsByInterval(
            widget.aquariumId, startInterval, endInterval);
    return measurementsInInterval;
  }

  void getChartPoints() async {
    List<FlSpot> points = [];

    List<Measurement> measurementsInInterval =
        await getMeasurementsByInterval();
    
    for (int i = 0; i < measurementsInInterval.length; i++) {
      points.add(FlSpot(
          (i * 10) / 10,
          measurementsInInterval
              .elementAt(i)
              .getValueByName(waterValueMap[dropdownWaterValue]!)));
    }
    setState(() {
      chartPoints = points;
      getXYMinMax();
    });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    value += 1;
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    String parts = '';
    /*
    if (value.toInt() % 2 != 0) {
      parts = '${value.round()} Messung';
    }*/

    parts = value.toInt().toString();
    text = Text(parts, style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      value: dropdownWaterValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownWaterValue = value!;
                          getChartPoints();
                        });
                      },
                      items: waterValueMap.keys
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
                      value: dropdownInterval,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownInterval = value!;
                          getChartPoints();
                        });
                      },
                      items: intervalMap.keys
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
                            getTitlesWidget: bottomTitleWidgets,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(),
                      minX: xMin,
                      maxX: xMax,
                      minY: yMin,
                      maxY: yMax,
                      lineBarsData: [
                        LineChartBarData(
                          spots: chartPoints,
                          barWidth: 5,
                          dotData: const FlDotData(),
                          belowBarData: BarAreaData(),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
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
        );
  }
}
