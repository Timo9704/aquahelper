import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../model/aquarium.dart';
import '../../util/datastore.dart';
import '../usermanagement/signin.dart';

class LightCalculator extends StatefulWidget {
  const LightCalculator({super.key});

  @override
  State<LightCalculator> createState() => _LightCalculatorState();
}

class _LightCalculatorState extends State<LightCalculator> {
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];
  final TextEditingController _aquariumLiterController = TextEditingController();
  final TextEditingController _lumenController = TextEditingController();
  double _lumenPerLiter = 0.0;
  Map<String, double> lampOptions = {
    'LED Lampe': 30.0,
    'T5 Röhrenlampe': 40.0,
    'Halogenlampe': 20.0,
    // Fügen Sie hier weitere Lampenoptionen hinzu
  };
  final String _selectedLamp = 'LED Lampe';

  String ergebnis = "";

  String detailsText = "";

  @override
  void initState() {
    super.initState();
    loadAquariums();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      _aquariumNames = dbAquariums;
    });
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

  void calculateLumenPerLiter() {
    if(!isPremiumUser) {
      showPaywall();
      return;
    }
    num volume = _selectedAquarium != null
        ? _selectedAquarium!.liter
        : double.tryParse(_aquariumLiterController.text) ?? 0.0;
    double lumen = double.tryParse(_lumenController.text) ??
        lampOptions[_selectedLamp] ??
        0.0;
    if (volume > 0) {
      setState(() {
        _lumenPerLiter = lumen / volume;
      });
    }
  }

  String getDetailsText() {
    if (_lumenPerLiter < 20) {
      return "Deine Pflanzen bekommen recht wenig Licht. Einige Pflanzen kommen mit wenig Licht aus, jedoch benötigen die meisten Pflanzen mehr Licht.";
    } else if (_lumenPerLiter < 40) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Licht-Rechner"),
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text("Berechne die Lichtmenge deines Aquariums:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 20),
                const Text("1. Aquarium auswählen oder Volumen angeben:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                const SizedBox(height: 10),
                DropdownButton<Aquarium>(
                  value: _selectedAquarium,
                  hint: const Text('Wähle dein Aquarium',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAquarium = newValue;
                    });
                  },
                  items: _aquariumNames
                      .map<DropdownMenuItem<Aquarium>>((Aquarium value) {
                    return DropdownMenuItem<Aquarium>(
                      value: value,
                      child: Text(value.name,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                const Text("oder",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.sizeOf(context).width - 200,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Aquarium-Volumen (in Liter)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          )),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        controller: _aquariumLiterController,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          fillColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text("2. Lumen oder Lampe angeben:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                const SizedBox(height: 10),
                ExpansionTile(
                  title: const Text('Lichtstrom (Lumen/lm)'),
                  initiallyExpanded: true,
                  children: <Widget>[
                    ListTile(
                      title: TextField(
                        controller: _lumenController,
                        decoration: const InputDecoration(
                          labelText: 'Lumen eingeben',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                /*ExpansionTile(
                  title: const Text('Lampe/Produkt'),
                  children: lampOptions.keys.map((String key) {
                    return RadioListTile<String>(
                      title: Text(key),
                      value: key,
                      groupValue: _selectedLamp,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _selectedLamp = value;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),*/
                if (_lumenPerLiter > 0) ...[
                  const SizedBox(height: 20),
                  Text("Die Lichtmenge beträgt ${_lumenPerLiter.round()} Lumen pro Liter."),
                  const SizedBox(height: 10),
                  Text(getDetailsText(), maxLines: 3, style: const TextStyle(fontSize: 15), textAlign: TextAlign.justify),
                  const SizedBox(height: 20),
                  getLumenIndicator(_lumenPerLiter),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              isPremiumUser ? Colors.lightGreen : Colors.grey)),
                      onPressed: calculateLumenPerLiter,
                      child: const Text("Berechnen")),
                )
              ],
            ),
          ),
        ));
  }
}
