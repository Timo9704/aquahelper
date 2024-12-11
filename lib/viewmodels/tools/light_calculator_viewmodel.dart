import 'package:aquahelper/views/login/login.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../model/aquarium.dart';
import '../../util/datastore.dart';

class LightCalculatorViewModel extends ChangeNotifier {
  final TextEditingController aquariumLiterController = TextEditingController();
  final TextEditingController lumenController = TextEditingController();

  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;

  Aquarium? selectedAquarium;
  List<Aquarium> aquariumNames = [];
  double lumenPerLiter = 0.0;
  String selectedLamp = 'LED Lampe';
  String ergebnis = "";
  String detailsText = "";
  Map<String, double> lampOptions = {
    'LED Lampe': 30.0,
    'T5 Röhrenlampe': 40.0,
    'Halogenlampe': 20.0,
  };

  LightCalculatorViewModel() {
    loadAquariums();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    aquariumNames = dbAquariums;
    isUserPremium().then((result) {
        isPremiumUser = result;
    });
    notifyListeners();
  }

  void setSelectedAquarium(Aquarium? value) {
    selectedAquarium = value;
    if (selectedAquarium != null) {
      aquariumLiterController.text = selectedAquarium!.liter.toString();
    }
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
    if (user == null && context.mounted) {
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
                    WidgetStateProperty.all<Color>(Colors.grey)),
                child: const Text("Zurück!"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.lightGreen)),
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

  void calculateLumenPerLiter(BuildContext context) {
    if(!isPremiumUser) {
      showPaywall(context);
      return;
    }
    num volume = selectedAquarium != null
        ? selectedAquarium!.liter
        : double.tryParse(aquariumLiterController.text) ?? 0.0;
    double lumen = double.tryParse(lumenController.text) ??
        lampOptions[selectedLamp] ??
        0.0;
    if (volume > 0) {
        lumenPerLiter = lumen / volume;
    }
    notifyListeners();
  }

  String getDetailsText() {
    if (lumenPerLiter < 20) {
      return "Deine Pflanzen bekommen recht wenig Licht. Einige Pflanzen kommen mit wenig Licht aus, jedoch benötigen die meisten Pflanzen mehr Licht.";
    } else if (lumenPerLiter < 40) {
      return "Deine Pflanzen bekommen ausreichend Licht. Jedoch kann es auch Pflanzensorten geben, welche mehr Licht benötigen.";
    } else {
      return "Deine Pflanzen bekommen viel Licht. Die Beleuchtungsstärke sollte in der Regel für alle Pflanzen ausreichen.";
    }
  }

  Widget getLumenIndicator(double lumenPerLiter) {
    Color color;
    if (lumenPerLiter < 20) {
      color = Colors.red;
    } else if (lumenPerLiter < 40) {
      color = Colors.yellow;
    } else {
      color = Colors.lightGreen;
    }
    double position = (lumenPerLiter / 60).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double barPosition = position * constraints.maxWidth;
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: barPosition,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  left: barPosition - 15,
                  bottom: -15,
                  top: 0,
                  child:
                  const Icon(Icons.arrow_drop_up, size: 30, color: Colors.black),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("gering"),
                Text("mittel"),
                Text("stark"),
              ],)
          ],
        );
      },
    );
  }

}
