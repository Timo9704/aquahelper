import 'package:aquahelper/util/datastore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  double textScaleFactor = 0;
  double heightFactor = 0;
  String title = '';
  String loggedInOrLocal = '';
  User? user = Datastore.db.user;

  @override
  void initState() {
    super.initState();
    loggedInOrLocal = user != null ? "eingeloggt als: " + user!.email! : "lokaler Modus";
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    heightFactor = MediaQuery.sizeOf(context).height < 700 ? 0.3 : 0.75;
    title = MediaQuery.sizeOf(context).height < 700 ? "Dashboard" : "AquaHelper\nDashboard";
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
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                    textScaler: TextScaler.linear(textScaleFactor),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 50,
                        height: 1.2,
                        color: Colors.white,
                        fontWeight: FontWeight.w800)),
                    Text(loggedInOrLocal,
                        textScaler: TextScaler.linear(textScaleFactor),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white)),
                ],)
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
