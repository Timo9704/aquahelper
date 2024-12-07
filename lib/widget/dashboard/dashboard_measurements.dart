
import 'package:flutter/material.dart';

import '../../util/datastore.dart';
import '../../util/scalesize.dart';

class DashboardMeasurements extends StatefulWidget {

  const DashboardMeasurements({super.key});

  @override
  DashboardMeasurementsState createState() => DashboardMeasurementsState();
}

class DashboardMeasurementsState extends State<DashboardMeasurements> {
  double textScaleFactor = 0;
  String measurementsAll = "0";
  String measurements30days = "0";

  @override
  void initState() {
    super.initState();
    getMeasurementsAmount();
  }

  void getMeasurementsAmount() async{
    int now = ((DateTime.now().toUtc().millisecondsSinceEpoch));
    int endInterval = now - 2629743000;
    int measurementsAll = await Datastore.db.getMeasurementAmountByAllTime();
    int measurements30days = await Datastore.db.getMeasurementAmountByLast30Days(now, endInterval);
    setState(() {
      this.measurementsAll = measurementsAll.toString();
      this.measurements30days = measurements30days.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
            FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Messungen',
                textScaler: TextScaler.linear(textScaleFactor),
              style: const TextStyle(
                fontSize: 21,
                color: Colors.black,
              ))),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  FittedBox(
                  fit: BoxFit.scaleDown,
                    child: Text('Messungen\n(in 30 Tage)',
                        textScaler: TextScaler.linear(textScaleFactor),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ))),
                    const Icon(Icons.check_box_outlined, color: Colors.green),
                    Text('${measurements30days}x',
                        textScaler: TextScaler.linear(textScaleFactor),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 50,
                  width: 2,
                  child: ColoredBox(
                    color: Colors.grey,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Messungen\n(gesamt)',
                        textScaler: TextScaler.linear(textScaleFactor),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        )),
                    const Icon(Icons.check_box_outlined, color: Colors.green),
                    Text('${measurementsAll}x',
                        textScaler: TextScaler.linear(textScaleFactor),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        )),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
