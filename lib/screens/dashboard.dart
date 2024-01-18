
import 'package:flutter/material.dart';

import '../util/scalesize.dart';
import '../widget/dashboard/dashboard_health_status.dart';
import '../widget/dashboard/dashboard_measurements.dart';
import '../widget/dashboard/dashboard_news.dart';
import '../widget/dashboard/dashboard_reminder.dart';

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
    double heightFactor = MediaQuery.sizeOf(context).height < 700 ? 0.3 : 0.75;
    String title = MediaQuery.sizeOf(context).height < 700 ? "Dein Dashboard" : "AquaHelper\nDein Dashboard";
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
                  heightFactor: heightFactor,
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
              child: Center(
                child:  Text(title,
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w800)),
              ),
            ))
          ],
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
              children: [
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
