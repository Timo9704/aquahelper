import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/views/login/login.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../util/datastore.dart';

class RunInIntroViewModel extends ChangeNotifier {
  Aquarium? selectedAquarium;
  List<Aquarium> aquariumNames = [];
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;
  late Aquarium aquarium;
  String introText = "Herzlichen Glückwunsch zu deinem neuen Aquarium! Du hast dein Aquarium schon eingerichtet und möchtest nun wissen wie es weitergeht? Dann bist du hier genau richtig! \nDas AquaHelper-Einfahrprogramm hilft dir dabei, dein Aquarium in den ersten 6 Wochen optimal zu pflegen.";

  RunInIntroViewModel() {
    isUserPremium().then((result) {
      isPremiumUser = result;
    });
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    aquariumNames = dbAquariums;
    selectedAquarium = dbAquariums.first;
    aquarium = selectedAquarium!;
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

  void setRunInData() {
    aquarium.runInStatus = 1;
    aquarium.runInStartDate = DateTime.now().millisecondsSinceEpoch;
    Datastore.db.updateAquarium(aquarium);
  }
}
