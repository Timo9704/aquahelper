import 'package:aquahelper/screens/runin/runin_calender.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../model/aquarium.dart';
import '../../util/datastore.dart';
import '../../util/scalesize.dart';
import '../usermanagement/signin.dart';

class RunInStart extends StatefulWidget {
  final Aquarium aquarium;
  const RunInStart({super.key, required this.aquarium});

  @override
  State<RunInStart> createState() => _RunInStartState();
}

class _RunInStartState extends State<RunInStart> {
  double textScaleFactor = 0;
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    isUserPremium().then((result) {
      setState(() {
        isPremiumUser = result;
      });
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

  Future<void> showPaywall() async {
    await FirebaseAnalytics.instance
        .logEvent(name: 'openPaywall', parameters: null);
    if (user == null) {
      showLoginRequest();
    } else {
      PaywallResult result = await RevenueCatUI.presentPaywallIfNeeded(
          "Premium",
          displayCloseButton: true);
      if (result == PaywallResult.purchased) {
        setState(() {
          isPremiumUser = true;
        });
      }
    }
  }

  void showLoginRequest() {
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
                      MaterialPageRoute(builder: (context) => const SignIn())),
                },
              ),
            ],
            elevation: 0,
          );
        },
      );
    }
  }

  static const String startText =
      "Super, lass uns in den kommenden 6 Wochen dein Aquarium einfahren! \nDu bekommst von uns regelmäßig Tipps und Tricks, wie du dein Aquarium optimal pflegen kannst.";

  void setRunInData() {
    widget.aquarium.runInStatus = 1;
    widget.aquarium.runInStartDate = DateTime.now().millisecondsSinceEpoch;
    Datastore.db.updateAquarium(widget.aquarium);
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
        appBar: AppBar(
            title: const Text("6-Wochen Einfahrphase"),
            backgroundColor: Colors.lightGreen),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Text("Lass uns dein Aquarium einfahren!",
                  textScaler: TextScaler.linear(textScaleFactor),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(startText,
                  textScaler: TextScaler.linear(textScaleFactor),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 23, color: Colors.black)),
              const SizedBox(height: 20),
              const Image(image: AssetImage('assets/images/runin_intro.png')),
              const SizedBox(height: 20),
              Text("Dein Aquarium ist gerade erst eingerichtet?",
                  textScaler: TextScaler.linear(textScaleFactor),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 23,
                      color: Colors.black)),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => {
                    if(!isPremiumUser){
                      showPaywall()
                    } else {
                    setRunInData(),
                    Navigator.push(
                      context,
                        MaterialPageRoute(builder: (context) => RunInCalender(aquarium: widget.aquarium)),
                    )}
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Heute starten", textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 23)),
                  )),
              const SizedBox(height: 20),
            ]),
          ),
        ));
  }
}
