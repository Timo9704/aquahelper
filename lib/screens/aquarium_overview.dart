import 'dart:io';
import 'package:aquahelper/util/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/measurement.dart';
import 'package:aquahelper/widget/measurement_item.dart';
import 'package:aquahelper/screens/infopage.dart';
import 'package:aquahelper/screens/measurement_form.dart';
import 'package:aquahelper/screens/chart_analysis.dart';
import 'package:aquahelper/util/dbhelper.dart';

import '../widget/reminder_item.dart';

class AquariumOverview extends StatefulWidget {
  final Aquarium aquarium;

  const AquariumOverview({super.key, required this.aquarium});

  @override
  AquariumOverviewState createState() => AquariumOverviewState();
}

class AquariumOverviewState extends State<AquariumOverview> {
  List<Measurement> measurementList = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  bool _notificationsEnabled = false;


  @override
  void initState() {
    super.initState();
    loadMeasurements();
  }

  void loadMeasurements() async {
    List<Measurement> dbMeasurements =
        await DBHelper.db.getMeasurmentsList(widget.aquarium);
    setState(() {
      measurementList = dbMeasurements.reversed.toList();
    });
  }

  Future<void> areNotifcationsEnabledOnAndroid() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                '0', // channel Id
                'general' // channel Name
            )),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.aquarium.name),
        backgroundColor: Colors.lightGreen,
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Informationen"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const InfoPage()),
              );
            }
          }),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: widget.aquarium.imagePath.startsWith('assets/') ? Image.asset(widget.aquarium.imagePath, fit: BoxFit.cover):Image.file(File(widget.aquarium.imagePath),
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alle Erinnerungen:',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                IconButton(
                  onPressed: () async {
                    PermissionStatus status = await Permission.notification.request();
                    if (status.isGranted) {
                      NotificationService().zonedSchedule();
                      final List<PendingNotificationRequest> pendingNotificationRequests =
                      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
                      for(int i = 0; i<pendingNotificationRequests.length; i++){
                        print(pendingNotificationRequests.elementAt(i).title);
                      }
                    }
                    else {
                      // Open settings to enable notification permission
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.lightGreen,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              itemBuilder: (context, index) {
                return const ReminderItem(
                    name: "Wasserwechsel",
                    dueDay: 2);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alle Messungen:',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MeasurementForm(
                              measurementId: '', aquarium: widget.aquarium)),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.lightGreen,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            height: MediaQuery.of(context).size.height * 0.25,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: measurementList.length,
              itemBuilder: (context, index) {
                return MeasurementItem(
                    measurement: measurementList.elementAt(index),
                    aquarium: widget.aquarium);
              },
            ),
          ),
          ElevatedButton(
              onPressed: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ChartAnalysis(
                                aquariumId: widget.aquarium.aquariumId)))
                  },
              child: const Text("Wasserwert-Verlauf"))
        ],
      ),
    );
  }
}
