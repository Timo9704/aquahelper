import 'package:flutter/material.dart';
import '../../util/datastore.dart';

class DashboardMeasurementsViewModel extends ChangeNotifier {
  double textScaleFactor = 0;
  String measurementsAll = "0";
  String measurements30days = "0";

  DashboardMeasurementsViewModel() {
    getMeasurementsAmount();
  }

  double getAdaptiveSizePerc(int perc, BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    if (deviceHeight < 700) {
      return perc*1;
    } else if (deviceHeight < 900) {
      return perc*0.8;
    } else {
      return perc*0.6;
    }
  }

  void getMeasurementsAmount() async {
    int now = ((DateTime
        .now()
        .toUtc()
        .millisecondsSinceEpoch));
    int endInterval = now - 2629743000;
    int measurementsAll = await Datastore.db.getMeasurementAmountByAllTime();
    int measurements30days = await Datastore.db
        .getMeasurementAmountByLast30Days(now, endInterval);
    this.measurementsAll = measurementsAll.toString();
    this.measurements30days = measurements30days.toString();
    notifyListeners();
  }
}