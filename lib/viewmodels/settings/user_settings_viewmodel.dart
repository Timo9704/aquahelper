import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../model/user_settings.dart';
import '../../util/config.dart';
import '../../util/dbhelper.dart';
import '../../util/firebasehelper.dart';
import '../../views/homepage.dart';


class UserSettingsViewModel extends ChangeNotifier {
  late UserSettings us;
  User? user = FirebaseAuth.instance.currentUser;
  List<bool> measurementItemsList = [];
  bool isPremiumUser = false;
  bool measurementLimits = true;
  String infoText = 'Hier kannst du die App nach deinen Bedürfnissen anpassen. '
      'Aktiviere oder deaktiviere verschiedene Eingabefelder für die Wasserwerte. '
      'Die bisher gespeicherte Werte gehen dabei nicht verloren! ';

  String loginText =
      'Melde dich in der App an, um deine Daten zu synchronisieren. '
      'So kannst du deine Daten auf mehreren Geräten nutzen und verlierst sie nicht, wenn du die App neu installierst. '
      'Deine Daten werden dabei sicher in der Cloud gespeichert.';

  UserSettingsViewModel() {
    loadSettings();
  }

  void loadSettings() async {
    List<UserSettings> usList = await DBHelper.db.getUserSettings();
    List<bool> measurementItems =
    List.generate(waterValues.length, (index) => true);
    if (usList.isEmpty) {
      Map<String, dynamic> map = {
        'measurementItems': measurementItems.toString(),
        'measurementLimits': 1
      };
      us = UserSettings.fromMap(map);
      measurementItemsList = json.decode(us.measurementItems).cast<bool>().toList();
      measurementLimits = us.measurementLimits == 1;
    } else {
      us = usList.first;
      measurementItemsList = json.decode(us.measurementItems).cast<bool>().toList();
      measurementLimits = us.measurementLimits == 1;
    }
    notifyListeners();
  }

  void saveSettings() async {
    await DBHelper.db.saveUserSettings(us);
    userSettings = us;
    notifyListeners();
  }

  Future<bool> isUserPremium() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return (customerInfo.entitlements.all["Premium"] != null &&
          customerInfo.entitlements.all["Premium"]!.isActive == true);
    } catch (e) {
      return false;
    }
  }

  void showDeleteRequest(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konto löschen"),
          content: const Text("Möchtest du dein AquaHelper-Konto wirklich löschen? All deine Daten, Bilder und Einstellungen  werden dabei unwiderruflich gelöscht!"),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => deleteUserAccount(context),
              child: const Text("Ja, Konto löschen"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Nein, Konto behalten"),
            ),
          ],
        );
      },
    );
  }

  void deleteUserAccount(BuildContext context) {
    FirebaseHelper.db.deleteUserAccount();
    Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Homepage()));
  }

}






