import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'dart:math';

import '../../../model/aquarium.dart';
import '../../../util/datastore.dart';
import '../../usermanagement/signin.dart';

class GroundCalculatorIsland extends StatefulWidget {
  const GroundCalculatorIsland({super.key});

  @override
  State<GroundCalculatorIsland> createState() => _GroundCalculatorIslandState();
}

class _GroundCalculatorIslandState extends State<GroundCalculatorIsland> {
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;

  String? _selectedGround = "Soil";
  final List<String> _groundNames = ["Soil", "Kies", "Sand"];
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];

  String ergebnis = "";

  final _aquariumHeightController = TextEditingController();
  final _aquariumDepthController = TextEditingController();
  final _islandHeightController = TextEditingController();
  final _islandWidthController = TextEditingController();
  final _groundHeightController = TextEditingController();

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

  double parseTextFieldValue(TextEditingController controller){
    if(controller.text.isEmpty){
      controller.text = "0.0";
      return 0.0;
    }
    controller.text = controller.text.replaceAll(RegExp(r','), '.');
    return double.parse(controller.text);
  }

  void calculateGround() {
    String result = "";
    double triangleVol = 0.0;
    try {

      double aquariumHeight = parseTextFieldValue(_aquariumHeightController);
      double aquariumDepth = parseTextFieldValue(_aquariumDepthController);

      double plainGroundVolume = aquariumHeight * aquariumDepth * parseTextFieldValue(_groundHeightController);

      double topRadius = parseTextFieldValue(_islandWidthController) * (1/3);
      double bottomRadius = parseTextFieldValue(_islandWidthController);

      if(bottomRadius > aquariumHeight){
        double islandVolume = (1/3) * pi * (parseTextFieldValue(_islandHeightController)-parseTextFieldValue(_groundHeightController))
            * (pow(topRadius, 2) + topRadius * bottomRadius + pow(bottomRadius, 2));

        triangleVol = (plainGroundVolume + (islandVolume/2)) / 1000;
      }else{
        inputFailure();
      }
    } catch (e) {
      triangleVol = 0.0;
      inputFailure();
    }

    if (_selectedGround == "Soil") {
      result = "${triangleVol.round()}l Soil";
    } else if (_selectedGround == "Sand") {
      result = "${(triangleVol * 1.9).round()}kg Sand";
    } else if (_selectedGround == "Kies") {
      result = "${(triangleVol * 1.5).round()}kg Kies";
    }

    setState(() {
      ergebnis = result;
    });
  }

  void inputFailure() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Fehlerhafte Eingabe"),
          content: const SizedBox(
            height: 60,
            child: Column(
              children: [
                Text("Kontrolliere bitte deine Eingaben! Zahlenwerte sind als Komma- oder Ganzzahl einzugeben."),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
              child: const Text("Schließen"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          elevation: 0,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/images/island.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              children: [
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
                      _aquariumHeightController.text = _selectedAquarium!.width.toString();
                      _aquariumDepthController.text = _selectedAquarium!.height.toString();
                    });
                  },
                  items: _aquariumNames.map<DropdownMenuItem<Aquarium>>((Aquarium value) {
                    return DropdownMenuItem<Aquarium>(
                      value: value,
                      child: Text(
                          value.name,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Aquarium Länge (in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _aquariumHeightController,
                            style: const TextStyle(fontSize: 17),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(3),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Aquarium Tiefe (in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _aquariumDepthController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(3),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Insel-Breite (in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _islandWidthController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(3),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Insel-Höhe (in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _islandHeightController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(3),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Höhe vorn/seitlich (in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _groundHeightController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(3),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Wähle deine Bodengrund-Art:',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
                DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: _selectedGround,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGround = newValue;
                    });
                  },
                  items: _groundNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black)),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width - 80,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Du benötigst ungefähr: $ergebnis",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)),
                      onPressed: () => {calculateGround()},
                      child: const Text("Berechnen")),
                )
              ],
            ),
          ),
          ],)
        );
  }
}
