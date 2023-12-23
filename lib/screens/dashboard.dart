import 'package:aquahelper/widget/dashboard_health_status.dart';
import 'package:aquahelper/widget/dashboard_measurements.dart';
import 'package:aquahelper/widget/dashboard_news.dart';
import 'package:aquahelper/widget/dashboard_reminder.dart';

import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 0.75,
                  child: Image.asset('assets/images/aquarium.jpg')),
            ),
            Positioned.fill(
              child: Container(
              width: double.infinity,
              //height: 155,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.black54,
              ),
              child: const Padding(
                padding: EdgeInsets.all(30.0),
                child:  Text('AquaHelper\nDein Dashboard',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.w800)),
              ),
            ))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('Hier findest du alle Informationen zu deinen Aquarien:',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, color: Colors.black)),
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(children: [
            DashboardReminder(),
            SizedBox(
              width: 5,
            ),
            DashboardMeasurements()
          ]),
        ),
        const DashboardHealthStatus(),
        const DashboardNews(),
      ],
    );
  }
}
