import 'dart:convert';

import 'package:aquahelper/model/user_settings.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_animals_overview_viewmodel.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_measurements_reminder_viewmodel.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_plants_viewmodel.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_technic_viewmodel.dart';
import 'package:aquahelper/viewmodels/dashboard_viewmodel.dart';
import 'package:aquahelper/views/onboarding.dart';
import 'package:aquahelper/util/rate_app_init_widget.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:aquahelper/util/dbhelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sizer/sizer.dart';

import 'util/config.dart';

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
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);

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
  if (usList.isNotEmpty) {
    List<bool> currentList =
        json.decode(usList.first.measurementItems).cast<bool>().toList();
    if (currentList.length < waterValues.length) {
      //this is needed to have same amount of items for the list of displayed measurements - loop needed if user is more than one addition behind
      int diff = waterValues.length - currentList.length;
      for (int i = 0; i < diff; i++) {
        currentList.add(true);
      }
      userSettings = UserSettings(currentList.toString(), 1);
      DBHelper.db.saveUserSettings(userSettings);
    }
    userSettings = usList.first;
  } else {
    List<bool> measurementItems =
        List.generate(waterValues.length, (index) => true);
    userSettings = UserSettings(measurementItems.toString(), 1);
    DBHelper.db.saveUserSettings(userSettings);
  }
  configureRevenueCat();
  MobileAds.instance.initialize();

  runApp(const AquaHelper());
}

Future<void> configureRevenueCat() async {
  PurchasesConfiguration? configuration;

  String? uid = FirebaseAuth.instance.currentUser?.uid;

  if (Platform.isAndroid) {
    if (uid != null) {
      configuration = PurchasesConfiguration("goog_MNGBNPoTZWhfizfcKuSrlDxIjxt")
        ..appUserID = FirebaseAuth.instance.currentUser?.uid;
    } else {
      configuration =
          PurchasesConfiguration("goog_MNGBNPoTZWhfizfcKuSrlDxIjxt");
    }
  }

  if (configuration != null) {
    await Purchases.configure(configuration);
  }
}

class AquaHelper extends StatelessWidget {
  const AquaHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<DashboardViewModel>(create: (_) => DashboardViewModel(800)),
            ChangeNotifierProvider<AquariumMeasurementReminderViewModel>(create: (_) => AquariumMeasurementReminderViewModel()),
            ChangeNotifierProvider<AquariumAnimalsOverviewViewModel>(create: (_) => AquariumAnimalsOverviewViewModel()),
            ChangeNotifierProvider<AquariumTechnicViewModel>(create: (_) => AquariumTechnicViewModel()),
            ChangeNotifierProvider<AquariumPlantsViewModel>(create: (_) => AquariumPlantsViewModel())
          ],
          child: MaterialApp(
            title: 'AquaHelper',
            theme: ThemeData(
                textSelectionTheme: const TextSelectionThemeData(
                    selectionHandleColor: Colors.lightGreen,
                    cursorColor: Colors.black),
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
            home: RateAppInitWidget(
                builder: (rateMyApp) => const OnBoardingPage()),
          ),
        );
      },
    );
  }
}
