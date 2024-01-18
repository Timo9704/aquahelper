import 'package:aquahelper/screens/homepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:aquahelper/util/dbhelper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: "erinnerungen_group",
            channelKey: "0",
            channelName: "Erinnerungen",
            channelDescription: "Erinnerungen")
      ],
      channelGroups: [
        NotificationChannelGroup(channelGroupKey: "erinnerungen_group",
        channelGroupName: "Erinnerung Group")
      ]
  );
  bool isAllowedtoSendNotification = await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowedtoSendNotification){
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  await DBHelper.db.initDB();
  runApp(const AquaHelper());
}

class AquaHelper extends StatelessWidget {
  const AquaHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaHelper',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        scaffoldBackgroundColor: const Color.fromRGBO(242, 242, 242, 1)
      ),
      home: const Homepage(),
    );
  }
}
