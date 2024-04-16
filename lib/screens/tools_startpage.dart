import 'package:aquahelper/screens/signin.dart';
import 'package:aquahelper/screens/tools/explorer/explorer.dart';
import 'package:aquahelper/screens/tools/fertilizer_calculator.dart';
import 'package:aquahelper/screens/tools/ground_calculator.dart';
import 'package:aquahelper/screens/tools/light_calculator.dart';
import 'package:aquahelper/screens/tools/multitimer/multitimer.dart';
import 'package:aquahelper/screens/tools/osmosis/osmosis_calculator.dart';
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
  void initState() {
    super.initState();
    // Initialize isPremiumUser in initState
    isUserPremium().then((result) {
      setState(() {
        isPremiumUser = result;
      });
    });
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

  Future<void> logEvent(String logFunction) async {
    await FirebaseAnalytics.instance
        .logEvent(name: logFunction, parameters: null);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Column(children: [
        Expanded(
          child:
              GridView.count(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  children: [
            IconTextButton(
              imagePath: 'assets/buttons/soil_calculator.png',
              text: 'Bodengrund-Rechner',
              onPressed: () {
                logEvent('openGroundCalculator');
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const GroundCalculator()),
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
                  MaterialPageRoute(
                      builder: (context) => const LightCalculator()),
                );
              },
            ),
            !isPremiumUser
                ? IconTextButton(
                    imagePath: 'assets/buttons/osmosis_deactivated.png',
                    text: 'Osmose-Rechner',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const OsmosisCalculator()),
                      );
                    },
                  )
                : IconTextButton(
                    imagePath: 'assets/buttons/osmosis_activated.png',
                    text: 'Osmose-Rechner',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const OsmosisCalculator()),
                      );
                    },
                  ),
            !isPremiumUser
                ? IconTextButton(
                    imagePath: 'assets/buttons/stopwatch_deactivated.png',
                    text: 'Multitimer',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const MultiTimer()),
                      );
                    },
                  )
                : IconTextButton(
                    imagePath: 'assets/buttons/stopwatch_activated.png',
                    text: 'Multitimer',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const MultiTimer()),
                      );
                    },
                  ),
          ]),
        ),
      ]),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!isPremiumUser)
            ElevatedButton(
                onPressed: showPaywall,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen),
                  elevation: MaterialStateProperty.all<double>(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                child: const Text('Premium-Features freischalten')),
          const SizedBox(height: 10),
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
