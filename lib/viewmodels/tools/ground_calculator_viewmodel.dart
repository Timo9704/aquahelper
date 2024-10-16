import 'dart:math';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:aquahelper/views/login/login.dart';
import 'package:aquahelper/views/tools/ground/ground_calculator_increase.dart';
import 'package:aquahelper/views/tools/ground/ground_calculator_island.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class GroundCalculatorViewModel extends ChangeNotifier {
  int selectedPage = 0;
  final pageOptions = [
    const GroundCalculatorIncrease(),
    const GroundCalculatorIsland(),
  ];

  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;

  String? selectedGround = "Soil";
  final List<String> groundNames = ["Soil", "Kies", "Sand"];
  Aquarium? selectedAquarium;
  List<Aquarium> aquariumNames = [];

  String ergebnis = "";

  final aquariumHeightController = TextEditingController();
  final aquariumDepthController = TextEditingController();
  final islandHeightController = TextEditingController();
  final islandWidthController = TextEditingController();
  final groundHeightController = TextEditingController();

  String ergebnisIncrease = "";

  final startHeightController = TextEditingController();
  final endHeightController = TextEditingController();

  GroundCalculatorViewModel() {
    loadAquariums();
    isUserPremium().then((result) {
        isPremiumUser = result;
    });
  }

  setSelectedPage(int value) {
    selectedPage = value;
    notifyListeners();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    aquariumNames = dbAquariums;
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

  Future<void> showPaywall(BuildContext context) async {
    await FirebaseAnalytics.instance
        .logEvent(name: 'openPaywall', parameters: null);
    if (user == null) {
      showLoginRequest(context);
    } else {
      PaywallResult result = await RevenueCatUI.presentPaywallIfNeeded(
          "Premium",
          displayCloseButton: true);
      if (result == PaywallResult.purchased) {
          isPremiumUser = true;
      }
    }
  }

  void showLoginRequest(BuildContext context) {
    if (user == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Du bist aktuell nicht angemeldet!"),
            content: const SizedBox(
              height: 80,
              child: Column(
                children: [
                  Text(
                      "Um Premium-Features zu nutzen, musst du dich anmelden. Möchtest du jetzt dein AquaHelper-Konto anlegen?"),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey)),
                child: const Text("Zurück!"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightGreen)),
                child: const Text("Jetzt anmelden!"),
                onPressed: () => {
                  Navigator.pop(context),
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LogIn())),
                },
              ),
            ],
            elevation: 0,
          );
        },
      );
    }
  }

  double parseTextFieldValue(TextEditingController controller){
    if(controller.text.isEmpty){
      controller.text = "0.0";
      return 0.0;
    }
    controller.text = controller.text.replaceAll(RegExp(r','), '.');
    return double.parse(controller.text);
  }

  void calculateGround(BuildContext context) {
    String result = "";
    double triangleVol = 0.0;
    try {

      double aquariumHeight = parseTextFieldValue(aquariumHeightController);
      double aquariumDepth = parseTextFieldValue(aquariumDepthController);

      double plainGroundVolume = aquariumHeight * aquariumDepth * parseTextFieldValue(groundHeightController);

      double topRadius = parseTextFieldValue(islandWidthController) * (1/3);
      double bottomRadius = parseTextFieldValue(islandWidthController);

      if(bottomRadius > aquariumHeight){
        double islandVolume = (1/3) * pi * (parseTextFieldValue(islandHeightController)-parseTextFieldValue(groundHeightController))
            * (pow(topRadius, 2) + topRadius * bottomRadius + pow(bottomRadius, 2));

        triangleVol = (plainGroundVolume + (islandVolume/2)) / 1000;
      }else{
        inputFailure(context);
      }
    } catch (e) {
      triangleVol = 0.0;
      inputFailure(context);
    }

    if (selectedGround == "Soil") {
      result = "${triangleVol.round()}l Soil";
    } else if (selectedGround == "Sand") {
      result = "${(triangleVol * 1.9).round()}kg Sand";
    } else if (selectedGround == "Kies") {
      result = "${(triangleVol * 1.5).round()}kg Kies";
    }

    ergebnis = result;
    notifyListeners();
  }

  void inputFailure(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Fehlerhafte Eingabe"),
          content: const SizedBox(
            height: 60,
            child: Column(
              children: [
                Text("Kontrolliere bitte deine Eingaben! Zahlenwerte sind als Komma- oder Ganzzahl einzugeben."),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
              child: const Text("Schließen"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          elevation: 0,
        );
      },
    );
  }

  void calculateGroundIncrease(BuildContext context) {
    String result = "";
    double triangleVol = 0.0;
    try {
      double start = parseTextFieldValue(startHeightController);
      double end = parseTextFieldValue(endHeightController);
      double rectVol = 0;
      if (start > 0) {
        rectVol = start *
            parseTextFieldValue(aquariumDepthController) *
            parseTextFieldValue(aquariumHeightController) /
            1000;
        end -= start;
      }
      triangleVol = (end * parseTextFieldValue(aquariumDepthController) / 2) *
          parseTextFieldValue(aquariumHeightController) /
          1000;
      triangleVol += rectVol;
    } catch (e) {
      triangleVol = 0.0;
      inputFailure(context);
    }

    if (selectedGround == "Soil") {
      result = "${triangleVol.round()}l Soil";
    } else if (selectedGround == "Sand") {
      result = "${(triangleVol * 1.9).round()}kg Sand";
    } else if (selectedGround == "Kies") {
      result = "${(triangleVol * 1.5).round()}kg Kies";
    }
    ergebnis = result;
    notifyListeners();
  }
}
