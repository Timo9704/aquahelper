import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../model/aquarium.dart';
import '../../../util/datastore.dart';
import '../../signin.dart';

class OsmosisLiterTab extends StatefulWidget {
  const OsmosisLiterTab({super.key});

  @override
  State<OsmosisLiterTab> createState() => _OsmosisLiterTabState();
}

class _OsmosisLiterTabState extends State<OsmosisLiterTab> {
  final _formKey = GlobalKey<FormState>();
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];
  final TextEditingController _tapWaterController = TextEditingController();
  final TextEditingController _osmosisController = TextEditingController();
  final TextEditingController _targetValueController = TextEditingController();
  final TextEditingController _aquariumLiterController =
      TextEditingController();
  double _osmosisLiterController = 0.0;
  double _tapLiterController = 0.0;

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

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      _aquariumNames = dbAquariums;
    });
  }

  double parseTextFieldValue(String value) {
    if (value.isEmpty) {
      return 0.0;
    }
    return double.parse(value.replaceAll(RegExp(r','), '.'));
  }

  void calculateOsmosisRatio() {
    if (!isPremiumUser) {
      showPaywall();
    } else {
      if (_formKey.currentState!.validate()) {
        double tapWaterValue = parseTextFieldValue(_tapWaterController.text);
        double osmosisWaterValue = parseTextFieldValue(_osmosisController.text);
        double targetWaterValue =
            parseTextFieldValue(_targetValueController.text);
        int aquariumLiter = 0;

        if (_selectedAquarium != null) {
          aquariumLiter = _selectedAquarium!.liter;
        }
        if (_aquariumLiterController.text.isNotEmpty) {
          aquariumLiter = int.parse(_aquariumLiterController.text);
        }

        double osmosisIntermediate =
            (osmosisWaterValue - targetWaterValue).abs();
        double tapIntermediate = (tapWaterValue - targetWaterValue).abs();

        double sumRelation = osmosisIntermediate + tapIntermediate;
        double relationPart = aquariumLiter / sumRelation;

        setState(() {
          _osmosisLiterController = double.parse(
              (osmosisIntermediate * relationPart).toStringAsFixed(1));
          _tapLiterController =
              double.parse((tapIntermediate * relationPart).toStringAsFixed(1));
        });
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

  Widget getLumenIndicator() {
    Color color = Colors.lightGreen;
    double position = (_osmosisLiterController / 60).clamp(0.0, 1.0);
    int aquariumLiter = 0;
    if (_selectedAquarium != null) {
      aquariumLiter = _selectedAquarium!.liter;
    } else {
      if (_aquariumLiterController.text.isNotEmpty) {
        aquariumLiter = int.parse(_aquariumLiterController.text);
      }
    }
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
                "Es werden $_osmosisLiterController Liter Osmosewasser und $_tapLiterController Leitungswasser benötigt.",
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                const Text(
                    "Berechne das Verhältnis von Leitungs- zu Osmosewasser:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("GH/KH/LW-Leitungswasser",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                )),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              controller: _tapWaterController,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Feld darf nicht leer sein';
                                }
                                if (double.tryParse(
                                        value.replaceAll(RegExp(r','), '.')) ==
                                    null) {
                                  return 'Bitte Zahl eingeben';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("GH/KH/LW-Osmosewasser",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                )),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              controller: _osmosisController,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Feld darf nicht leer sein';
                                }
                                if (double.tryParse(
                                        value.replaceAll(RegExp(r','), '.')) ==
                                    null) {
                                  return 'Bitte Zahl eingeben';
                                }
                                if (double.parse(
                                        value.replaceAll(RegExp(r','), '.')) >=
                                    double.parse(_tapWaterController.text
                                        .replaceAll(RegExp(r','), '.'))) {
                                  return 'Größer als Leitungswasser';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("GH/KH/LW-Zielwert",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          )),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        controller: _targetValueController,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          fillColor: Colors.grey,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Feld darf nicht leer sein';
                          }
                          if (double.tryParse(
                                  value.replaceAll(RegExp(r','), '.')) ==
                              null) {
                            return 'Bitte Zahl eingeben';
                          }
                          if (double.parse(
                                  value.replaceAll(RegExp(r','), '.')) >=
                              double.parse(_tapWaterController.text
                                  .replaceAll(RegExp(r','), '.'))) {
                            return 'Größer als Leitungswasser';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                      const Text("zu mischendes Volumen in Liter:",
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
                Column(
                  children: [
                    const Text("Ergebnis:",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 20),
                    SizedBox(height: 100, child: getLumenIndicator()),
                  ],
                ),
                const SizedBox(height: 20),
                isPremiumUser
                    ? SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightGreen)),
                            onPressed: calculateOsmosisRatio,
                            child: const Text("Berechnen")),
                      )
                    : SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey)),
                            onPressed: calculateOsmosisRatio,
                            child: const Text("Berechnen")),
                      )
              ]),
            )));
  }
}
