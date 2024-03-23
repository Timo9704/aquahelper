import 'package:aquahelper/screens/tools/explorer/explorer.dart';
import 'package:aquahelper/screens/tools/fertilizer_calculator.dart';
import 'package:aquahelper/screens/tools/ground_calculator.dart';
import 'package:aquahelper/screens/tools/light_calculator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class ToolsStartPage extends StatefulWidget {
  const ToolsStartPage({super.key});

  @override
  State<ToolsStartPage> createState() => _ToolsStartPageState();
}

class _ToolsStartPageState extends State<ToolsStartPage> {
  bool isPremiumUser = false;
  @override
  void initState(){
    super.initState();
    isPremiumUser = isUserPremium();
  }

  User? user = FirebaseAuth.instance.currentUser;

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
                child: const Text("Nein!"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey)),
                child: const Text("Ja, jetzt anmelden!"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
            elevation: 0,
          );
        },
      );
    }
  }

  getCustomerInfo() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo;
    } catch (e) {
      return null;
    }
  }

  bool isUserPremium() {
    try {
      CustomerInfo customerInfo = getCustomerInfo() ;
      return (
          customerInfo.entitlements.all["premium"] != null &&
              customerInfo.entitlements.all["premium"]!.isActive == true);
    } catch (e) {
      return false;
    }
  }

  Future<void> showPaywall() async {
    await FirebaseAnalytics.instance.logEvent(name: 'openPaywall', parameters: null);
    if (user == null) {
      showLoginRequest();
    } else {
      await RevenueCatUI.presentPaywallIfNeeded("Premium",
          displayCloseButton: true);
    }
  }

  Future<void> logEvent(String logFunction) async {
    await FirebaseAnalytics.instance
        .logEvent(name: logFunction, parameters: null);
  }

  @override
  Widget build(BuildContext context){
    return Column(children: [
      Expanded(
          child:
              GridView.count(crossAxisCount: 2, childAspectRatio: 1, children: [
        IconTextButton(
          imagePath: 'assets/buttons/soil_calculator.png',
          text: 'Bodengrund-Rechner',
          onPressed: () {
            logEvent('openGroundCalculator');
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const GroundCalculator()),
            );
          },
        ),
        IconTextButton(
          imagePath: 'assets/buttons/fertilizer_calculator.png',
          text: 'Dünger-Rechner',
          onPressed: () {
            logEvent('openFertilizerCalculator');
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const FertilizerCalculator()),
            );
          },
        ),
        IconTextButton(
          imagePath: 'assets/buttons/explorer.png',
          text: 'Content-Explorer',
          onPressed: () {
            logEvent('openContentExplorer');
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Explorer()),
            );
          },
        ),
        IconTextButton(
          imagePath: 'assets/buttons/light_calculator.png',
          text: 'Licht-Rechner',
          onPressed: () {
            logEvent('openLightCalculator');
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LightCalculator()),
            );
          },
        ),
      ])),
      Column(
        children: [
          const SizedBox(height: 10),
          const Text(
              'Premium-Tools',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
            ),
          const Padding(padding: EdgeInsets.all(10), child:
          Text(
            'Derzeit befinden sich verschiedene Premium-Funktionen in der Entwicklung. Diese werden in Kürze verfügbar sein. Unterstütze die Entwicklung von AquaHelper mit deinem Premium-Abo!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),),
          const SizedBox(height: 20),
          isPremiumUser ?
          const Text('Danke für deine Unterstützung!', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),):
          ElevatedButton(
              onPressed: showPaywall,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                elevation: MaterialStateProperty.all<double>(0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              child: const Text('Premium-Features freischalten')),
          /*IconTextButton(
            imagePath: 'assets/buttons/ai_assistant.png',
            text: 'pH-KH-CO2-Rechner',
            onPressed: () async {
              if(await isUserPremium()) {
                showLightCalculator();
              } else {
                showPaywall();
              }
            },
          ),*/
          const SizedBox(height: 20),
        ],
      ),
    ]);
  }
}

class IconTextButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  const IconTextButton(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(imagePath, width: 120, height: 120),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
