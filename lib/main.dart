import 'package:aquahelper/model/user_settings.dart';
import 'package:aquahelper/screens/onboarding_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:aquahelper/util/dbhelper.dart';
import 'package:purchases_flutter/models/purchases_configuration.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import 'config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sequence for Firebase (Crashlytics, Firestore, Authentication)
  Platform.isAndroid
      ? await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAxpfoqHOFT78cl6uqNdUzFOHEl-R_rGJg',
          appId: '1:634908914538:android:7449a32a0b2a6cbad1eb13',
          messagingSenderId: '634908914538',
          projectId: 'aquahelper'))
      : await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Initialize sequence for AwesomeNotification (push notifications)
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: "erinnerungen_group",
        channelKey: "0",
        channelName: "Erinnerungen",
        channelDescription: "Erinnerungen")
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "erinnerungen_group",
        channelGroupName: "Erinnerung Group")
  ]);
  bool isAllowedtoSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedtoSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // Initialize sequence for local database and user settings (sqlite)
  await DBHelper.db.initDB();
  List<UserSettings> usList = await DBHelper.db.getUserSettings();
  if(usList.isNotEmpty){
    userSettings = usList.first;
  }else{
    List<bool> measurementItems = List.generate(waterValues.length, (index) => true);
    userSettings = UserSettings(measurementItems.toString());
    DBHelper.db.saveUserSettings(userSettings);
  }
  configureRevenueCat();
  runApp(const AquaHelper());
}

Future<void> configureRevenueCat() async {
  PurchasesConfiguration? configuration;

  if(Platform.isAndroid) {
    configuration = PurchasesConfiguration("goog_MNGBNPoTZWhfizfcKuSrlDxIjxt");
  }

  if(configuration != null) {
    await Purchases.configure(configuration);
  }
}

class AquaHelper extends StatelessWidget {
  const AquaHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaHelper',
      theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
              selectionHandleColor: Colors.lightGreen,
              cursorColor: Colors.black
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
          ),
          primarySwatch: Colors.lightGreen,
          scaffoldBackgroundColor: const Color.fromRGBO(242, 242, 242, 1),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
          )),
      home: const OnBoardingPage(),
    );
  }
}
