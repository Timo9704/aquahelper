import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/paywall_result.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../model/aquarium.dart';
import '../../../util/datastore.dart';
import '../../signin.dart';

class OsmosisWaterChangeTab extends StatefulWidget {
  const OsmosisWaterChangeTab({super.key});

  @override
  State<OsmosisWaterChangeTab> createState() => _OsmosisWaterChangeTabState();
}

class _OsmosisWaterChangeTabState extends State<OsmosisWaterChangeTab> {
  final _formKey = GlobalKey<FormState>();
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];
  final TextEditingController _currentValueController = TextEditingController();
  final TextEditingController _targetValueController = TextEditingController();
  final TextEditingController _osmosisValueController = TextEditingController();
  double _waterChangeLiter = 0.0;

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
        double currentValue = parseTextFieldValue(_currentValueController.text);
        double targetValue = parseTextFieldValue(_targetValueController.text);
        double osmosisValue = parseTextFieldValue(_osmosisValueController.text);
        int aquariumLiter = _selectedAquarium!.liter;

        double waterChangePercentage = aquariumLiter *
            (currentValue - targetValue) /
            (currentValue - osmosisValue);

        setState(() {
          _waterChangeLiter =
              double.parse((waterChangePercentage).toStringAsFixed(1));
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
    int aquariumLiter = 1;
    if (_selectedAquarium != null) {
      aquariumLiter = _selectedAquarium!.liter;
    }
    double position = (_waterChangeLiter / aquariumLiter).clamp(0.0, 1.0);

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
                Text("${aquariumLiter} Liter"),
              ],
            ),
            const SizedBox(height: 10),
            Text(
                "Um den Zielwert zu erreichen, müssen $_waterChangeLiter Liter (${((_waterChangeLiter / aquariumLiter) * 100).round()}%) gewechselt werden.",
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
                "Berechne die prozentuale Menge für deinen Wasserwechsel:",
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
                        const Text("GH/KH/LW-Aquariumwasser",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            )),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          controller: _currentValueController,
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
                          controller: _osmosisValueController,
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
                                double.parse(_currentValueController.text
                                    .replaceAll(RegExp(r','), '.'))) {
                              return 'Größer als Aquariumwasser';
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
                      if (double.parse(value.replaceAll(RegExp(r','), '.')) >=
                          double.parse(_currentValueController.text
                              .replaceAll(RegExp(r','), '.'))) {
                        return 'Größer als Aquarienwasser';
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
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                );
              }).toList(),
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightGreen)),
                        onPressed: calculateOsmosisRatio,
                        child: const Text("Berechnen")),
                  )
                : SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey)),
                        onPressed: calculateOsmosisRatio,
                        child: const Text("Berechnen")),
                  )
          ]),
        ),
      ),
    );
  }
}
