import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/views/tools/osmosis/osmosis_liter_tab.dart';
import 'package:aquahelper/views/tools/osmosis/osmosis_waterchange_tab.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../util/datastore.dart';
import '../../views/login/login.dart';

class OsmosisCalculatorViewModel extends ChangeNotifier {
  int selectedPage = 0;
  final pageOptions = [
    const OsmosisLiterTab(),
    const OsmosisWaterChangeTab(),
  ];

  final formKey = GlobalKey<FormState>();
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;
  Aquarium? selectedAquarium;
  List<Aquarium> aquariumNames = [];
  final TextEditingController tapWaterController = TextEditingController();
  final TextEditingController osmosisController = TextEditingController();
  final TextEditingController targetValueController = TextEditingController();
  final TextEditingController aquariumLiterController = TextEditingController();
  double osmosisLiterController = 0.0;
  double tapLiterController = 0.0;

  final formKeyChange = GlobalKey<FormState>();
  final TextEditingController currentValueController = TextEditingController();
  final TextEditingController targetChangeValueController = TextEditingController();
  final TextEditingController osmosisValueController = TextEditingController();
  double waterChangeLiter = 0.0;

  OsmosisCalculatorViewModel() {
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

  double parseTextFieldValue(String value) {
    if (value.isEmpty) {
      return 0.0;
    }
    return double.parse(value.replaceAll(RegExp(r','), '.'));
  }

  void calculateOsmosisRatio(BuildContext context) {
    if (!isPremiumUser) {
      showPaywall(context);
    } else {
      if (formKey.currentState!.validate()) {
        double tapWaterValue = parseTextFieldValue(tapWaterController.text);
        double osmosisWaterValue = parseTextFieldValue(osmosisController.text);
        double targetWaterValue =
        parseTextFieldValue(targetValueController.text);
        int aquariumLiter = 0;

        if (selectedAquarium != null) {
          aquariumLiter = selectedAquarium!.liter;
        }
        if (aquariumLiterController.text.isNotEmpty) {
          aquariumLiter = int.parse(aquariumLiterController.text);
        }

        double osmosisIntermediate =
        (osmosisWaterValue - targetWaterValue).abs();
        double tapIntermediate = (tapWaterValue - targetWaterValue).abs();

        double sumRelation = osmosisIntermediate + tapIntermediate;
        double relationPart = aquariumLiter / sumRelation;

        tapLiterController = double.parse(
              (osmosisIntermediate * relationPart).toStringAsFixed(1));
        osmosisLiterController =
              double.parse((tapIntermediate * relationPart).toStringAsFixed(1));
        notifyListeners();
      }
    }
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
    notifyListeners();
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

  Widget getLumenIndicator() {
    Color color = Colors.lightGreen;

    int aquariumLiter = 0;
    if (selectedAquarium != null) {
      aquariumLiter = selectedAquarium!.liter;
    } else {
      if (aquariumLiterController.text.isNotEmpty) {
        aquariumLiter = int.parse(aquariumLiterController.text);
      }
    }
    double position = (osmosisLiterController / aquariumLiter).clamp(0.0, 1.0);
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
                  child: const Icon(Icons.arrow_drop_up,
                      size: 30, color: Colors.black),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("0 Liter"),
                Text("$aquariumLiter Liter"),
              ],
            ),
            const SizedBox(height: 10),
            Text(
                "Es werden $osmosisLiterController Liter Osmosewasser und $tapLiterController Leitungswasser benötigt.",
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center),
          ],
        );
      },
    );
  }

  void calculateOsmosisRatioChange(BuildContext context) {
    if (!isPremiumUser) {
      showPaywall(context);
    } else {
      if (formKeyChange.currentState!.validate()) {
        double currentValue = parseTextFieldValue(currentValueController.text);
        double targetValue = parseTextFieldValue(targetValueController.text);
        double osmosisValue = parseTextFieldValue(osmosisValueController.text);
        int aquariumLiter = selectedAquarium!.liter;

        double waterChangePercentage = aquariumLiter *
            (currentValue - targetValue) /
            (currentValue - osmosisValue);

          waterChangeLiter = double.parse((waterChangePercentage).toStringAsFixed(1));
      }
      notifyListeners();
    }
  }

  Widget getChangeIndicator() {
    Color color = Colors.lightGreen;
    int aquariumLiter = 1;
    if (selectedAquarium != null) {
      aquariumLiter = selectedAquarium!.liter;
    }
    double position = (waterChangeLiter / aquariumLiter).clamp(0.0, 1.0);

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
                  child: const Icon(Icons.arrow_drop_up,
                      size: 30, color: Colors.black),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("0 Liter"),
                Text("$aquariumLiter Liter"),
              ],
            ),
            const SizedBox(height: 10),
            Text(
                "Um den Zielwert zu erreichen, müssen $waterChangeLiter Liter (${((waterChangeLiter / aquariumLiter) * 100).round()}%) gewechselt werden.",
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center),
          ],
        );
      },
    );
  }

}
