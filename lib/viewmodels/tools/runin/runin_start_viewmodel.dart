import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/views/login/login.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../util/datastore.dart';

class RunInStartViewModel extends ChangeNotifier {
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;
  Aquarium aquarium;
  static const String startText =
      "Super, lass uns in den kommenden 6 Wochen dein Aquarium einfahren! \nDu bekommst von uns regelmäßig Tipps und Tricks, wie du dein Aquarium optimal pflegen kannst.";

  RunInStartViewModel(this.aquarium) {
    isUserPremium().then((result) {
      isPremiumUser = result;
    });
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

  void setRunInData() {
    aquarium.runInStatus = 1;
    aquarium.runInStartDate = DateTime.now().millisecondsSinceEpoch;
    Datastore.db.updateAquarium(aquarium);
  }
}
