import 'dart:convert';

import 'package:aquahelper/util/datastore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/scalesize.dart';
import '../../widget/dashboard/dashboard_health_status.dart';
import '../../widget/dashboard/dashboard_measurements.dart';
import '../../widget/dashboard/dashboard_news.dart';
import '../../widget/dashboard/dashboard_reminder.dart';

import 'package:http/http.dart' as http;

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

  bool announcementVisible = false;
  String announcement = '';
  String announcementUrl = '';

  @override
  void initState() {
    super.initState();
    loggedInOrLocal =
        user != null ? "eingeloggt als: ${user!.email!}" : "lokaler Modus";
    _fetchAnnouncement();
  }

  Future<void> _fetchAnnouncement() async {
    final response = await http.get(Uri.parse('https://aquaristik-kosmos.de/announcement.json'));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);

      setState(() {
        parsed.forEach((key, value) {
          announcement = value[0]['text'];
          announcementUrl = value[1]['url'];
          announcementVisible = true;
        });
      });
    }
  }

  void showMaterialBanner() {
    final materialBanner = MaterialBanner(
      padding: const EdgeInsets.all(20),
      content: Text(announcement),
      leading: const Icon(Icons.notification_important),
      backgroundColor: Colors.white,
      actions: <Widget>[
        TextButton(
          onPressed: () => {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner()
          },
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 10),
            backgroundColor: Colors.grey,
          ),
          child: const Text('Schließen'),
        ),
        TextButton(
          onPressed: _launchRedirect,
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 10),
            backgroundColor: Colors.lightGreen,
          ),
          child: const Text('Weiterlesen'),
        ),
      ],
    );
    ScaffoldMessenger.of(context).showMaterialBanner(materialBanner);
  }

  Future<void> _launchRedirect() async {
    await launchUrl(Uri.parse(announcementUrl));
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    heightFactor = MediaQuery.sizeOf(context).height < 700 ? 0.35 : 0.65;
    title = MediaQuery.sizeOf(context).height < 700
        ? "Dashboard"
        : "AquaHelper\nDashboard";
    return Stack(
      children: [
        Column(
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
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title,
                          textScaler: TextScaler.linear(textScaleFactor),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 45,
                              height: 1.2,
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                      Text(loggedInOrLocal,
                          textScaler: TextScaler.linear(textScaleFactor),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white)),
                    ],
                  )),
                ))
              ],
            ),
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
            const Expanded(
                child: DashboardNews(),
            ),
          ],
        ),
        if(announcementVisible)
          Align(
            alignment: Alignment.bottomCenter, // Zentriert den Button in der Mitte des Bildschirms
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                      ),
                      onPressed: showMaterialBanner,
                      child: const Text('Wichtige Information')
                  ),
                  const SizedBox(height: 10)
                ]),
          ),
      ],
    );
  }
}
