import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../model/measurement.dart';
import '../../util/datastore.dart';

class AquariumChartsViewModel extends ChangeNotifier {
  String dropdownWaterValue = "";
  String dropdownInterval = "";
  List<FlSpot> chartPoints = [];
  String aquariumId = "";
  double xMin = 0;
  double yMin = 0;
  double xMax = 0;
  double yMax = 0;

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
    'Leitwert': 'conductance',
    'Silikat': 'silicate'
  };

  var intervalMap = {
    '1 Woche': 604800000,
    '2 Wochen': 1209600000,
    '3 Wochen': 1814400000,
    '4 Wochen': 2419200000,
    '2 Monate': 5184000000,
    '3 Monate': 7776000000
  };

  AquariumChartsViewModel(this.aquariumId) {
    dropdownWaterValue = waterValueMap.keys.first;
    dropdownInterval = intervalMap.keys.first;
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
    if(yMin == 0){
      this.yMin = yMin;
    }else{
      this.yMin = yMin-1;
    }
    this.xMax = xMax;
    this.yMax = yMax + 1;
    notifyListeners();
  }

  Future<List<Measurement>> getMeasurementsByInterval() async {
    int startInterval = ((DateTime.now().toUtc().millisecondsSinceEpoch));
    int endInterval = startInterval - intervalMap[dropdownInterval]!;
    List<Measurement> measurementsInInterval = await Datastore.db
        .getMeasurementsByInterval(aquariumId, startInterval, endInterval);
    return measurementsInInterval;
  }

  void getChartPoints() async {
    List<FlSpot> points = [];
    print("Dropdown Water Value: " + dropdownWaterValue);

    List<Measurement> measurementsInInterval =
    await getMeasurementsByInterval();

    for (int i = 0; i < measurementsInInterval.length; i++) {
      double value = measurementsInInterval.elementAt(i).getValueByName(waterValueMap[dropdownWaterValue]!);
      print("Value: " + value.toString());
      if(value == 9999.0) {
        //points.add(FlSpot.nullSpot);
      }else{
        points.add(FlSpot((i * 10) / 10, value));
      }
    }
    if(points.isEmpty){
      chartPoints = [const FlSpot(0, 0)];

    }else {
      chartPoints = points;
      getXYMinMax();
    }
    notifyListeners();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    value += 1;
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String parts = '';
    parts = value.toInt().toString();
    text = Text(parts, style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
