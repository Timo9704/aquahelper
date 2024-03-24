import 'package:aquahelper/model/user_settings.dart';
import 'package:aquahelper/screens/homepage.dart';
import 'package:aquahelper/screens/signin.dart';
import 'package:aquahelper/util/dbhelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:convert';

import '../../config.dart';
import '../../util/firebasehelper.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  UserSettingsPageState createState() => UserSettingsPageState();
}

class UserSettingsPageState extends State<UserSettingsPage> {
  late UserSettings us;
  User? user = FirebaseAuth.instance.currentUser;
  List<bool> measurementItemsList = [];
  bool isPremiumUser = false;

  String infoText = 'Hier kannst du die App nach deinen Bedürfnissen anpassen. '
      'Aktiviere oder deaktiviere verschiedene Eingabefelder für die Wasserwerte. '
      'Die bisher gespeicherte Werte gehen dabei nicht verloren! ';

  String loginText =
      'Melde dich in der App an, um deine Daten zu synchronisieren. '
      'So kannst du deine Daten auf mehreren Geräten nutzen und verlierst sie nicht, wenn du die App neu installierst. '
      'Deine Daten werden dabei sicher in der Cloud gespeichert.';

  @override
  void initState() {
    super.initState();
    loadSettings();
    isUserPremium().then((result) {
      setState(() {
        isPremiumUser = result;
      });
    });
  }

  void loadSettings() async {
    List<UserSettings> usList = await DBHelper.db.getUserSettings();
    List<bool> measurementItems =
        List.generate(waterValues.length, (index) => true);
    if (usList.isEmpty) {
      Map<String, dynamic> map = {
        'measurementItems': measurementItems.toString()
      };
      setState(() {
        us = UserSettings.fromMap(map);
        measurementItemsList =
            json.decode(us.measurementItems).cast<bool>().toList();
      });
    } else {
      setState(() {
        us = usList.first;
        measurementItemsList =
            json.decode(us.measurementItems).cast<bool>().toList();
      });
    }
  }

  void saveSettings() async {
    await DBHelper.db.saveUserSettings(us);
    userSettings = us;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Benutzereinstellungen"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(children: [
                Text(loginText,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16)),
              ])),
          const SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Icon(Icons.account_circle,
                    size: 50, color: Colors.lightGreen),
                user?.email != null
                    ? Text(
                        user!.email!,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Du bist nicht angemeldet!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isPremiumUser
                  ? const Column(
                      children: [
                        Text(
                          'Premium-Version',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Dein Abo kannst du über den PlayStore verwalten.',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        )
                      ],
                    )
                  : const Text(
                      'Free-Version',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 10),
          user != null
              ? ElevatedButton(
                  onPressed: () => {
                        FirebaseHelper.db.signOut(),
                        Purchases.logIn(user!.uid),
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Homepage()))
                      },
                  child: const Text(
                    'Ausloggen',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ))
              : ElevatedButton(
                  onPressed: () => {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SignIn()))
                      },
                  child: const Text(
                    'Bei AquaHelper anmelden',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(infoText,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                ExpansionTile(
                  title: const Text('Messung-Einstellungen'),
                  subtitle: const Text('Wähle deine Wasserwerte aus!'),
                  children: <Widget>[
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.0,
                      ),
                      itemCount: waterValues.length,
                      itemBuilder: (BuildContext context, int index) {
                        String key =
                            waterValuesTextMap.entries.elementAt(index).value;
                        return Column(
                          children: [
                            Text(key),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.all(Colors.lightGreen),
                              value: measurementItemsList[index],
                              onChanged: (bool? value) {
                                setState(
                                  () {
                                    measurementItemsList[index] = value!;
                                    us.measurementItems =
                                        measurementItemsList.toString();
                                    saveSettings();
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
