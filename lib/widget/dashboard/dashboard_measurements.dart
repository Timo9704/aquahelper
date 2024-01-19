
import 'package:aquahelper/util/dbhelper.dart';
import 'package:flutter/material.dart';

class DashboardMeasurements extends StatefulWidget {

  const DashboardMeasurements({super.key});

  @override
  DashboardMeasurementsState createState() => DashboardMeasurementsState();
}

class DashboardMeasurementsState extends State<DashboardMeasurements> {

  String measurementsAll = "";
  String measurements30days = "";

  @override
  void initState() {
    super.initState();
    getMeasurementsAmount();
  }

  void getMeasurementsAmount() async{
    int now = ((DateTime.now().toUtc().millisecondsSinceEpoch));
    int endInterval = now - 2629743000;
    int measurementsAll = await DBHelper.db.getMeasurementAmountByAllTime();
    int measurements30days = await DBHelper.db.getMeasurementAmountByLast30Days(now, endInterval);
    setState(() {
      this.measurementsAll = measurementsAll.toString();
      this.measurements30days = measurements30days.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 120,
        decoration: BoxDecoration(
          /*border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),*/
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          const Text('Messungen',
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Messungen\n(in 30 Tage)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    const Icon(Icons.check_box_outlined, color: Colors.green),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('${measurements30days}x',
                        style: const TextStyle(
                          fontSize: 10,
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
                  children: [
                    const Text('Messungen\n(gesamt)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    const Icon(Icons.check_box_outlined, color: Colors.green),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('${measurementsAll}x',
                        style: const TextStyle(
                          fontSize: 10,
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
