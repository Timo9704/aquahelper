import 'package:aquahelper/screens/runin/runin_calender.dart';
import 'package:aquahelper/screens/runin/runin_start.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/paywall_result.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import '../../model/aquarium.dart';
import '../../util/datastore.dart';
import '../../util/scalesize.dart';
import '../usermanagement/signin.dart';

class RunInIntro extends StatefulWidget {
  const RunInIntro({super.key});

  @override
  State<RunInIntro> createState() => _RunInIntroState();
}

class _RunInIntroState extends State<RunInIntro> {
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];
  double textScaleFactor = 0;
  late Aquarium aquarium;
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadAquariums();
    isUserPremium().then((result) {
      setState(() {
        isPremiumUser = result;
      });
    });
  }

  void switchToRunInCalender() {
    if(mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RunInCalender(aquarium: aquarium)),
      );
    }
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      _aquariumNames = dbAquariums;
      _selectedAquarium = dbAquariums.first;
      aquarium = _selectedAquarium!;
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

  static const String introText = "Herzlichen Glückwunsch zu deinem neuen Aquarium! Du hast dein Aquarium schon eingerichtet und möchtest nun wissen wie es weitergeht? Dann bist du hier genau richtig! \nDas AquaHelper-Einfahrprogramm hilft dir dabei, dein Aquarium in den ersten 6 Wochen optimal zu pflegen.";

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
          const SizedBox(height: 20),
          const Image(image: AssetImage('assets/images/runin_intro.png')),
          const SizedBox(height: 20),
          Text("Einführung:",
              textScaler: TextScaler.linear(textScaleFactor),
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(introText,
              textScaler: TextScaler.linear(textScaleFactor),
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 23, color: Colors.black)),
          const SizedBox(height: 30),
          Column(children: [
            Text(
                'Welches Aquarium möchtest du einfahren?',
                textScaler: TextScaler.linear(textScaleFactor),
                style: const TextStyle(
                    fontSize: 23, color: Colors.black)),
            DropdownButton<Aquarium>(
              value: _selectedAquarium,
              items: _aquariumNames
                  .map<DropdownMenuItem<Aquarium>>(
                      (Aquarium value) {
                    return DropdownMenuItem<Aquarium>(
                      value: value,
                      child: Text(value.name,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black)),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedAquarium = newValue;
                  aquarium = newValue!;
                });
              },
            ),
          ]),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => {
                if(!isPremiumUser)
                  showPaywall()
                else
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RunInStart(aquarium: aquarium)),
                )},
              style:
                  ElevatedButton.styleFrom(backgroundColor: isPremiumUser ? Colors.lightGreen: Colors.grey),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Starte die Einlaufphase jetzt!", textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 23)),
              ))
        ]),
      ),
    ));
  }
}
