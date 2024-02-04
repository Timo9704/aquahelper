import 'package:aquahelper/model/user_settings.dart';
import 'package:aquahelper/util/dbhelper.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../../config.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  UserSettingsPageState createState() => UserSettingsPageState();
}

class UserSettingsPageState extends State<UserSettingsPage> {
  late UserSettings us;
  List<bool> measurementItemsList = [];

  String infoText =
      'Hier kannst du die App nach deinen Bedürfnissen anpassen. '
      'Aktiviere oder deaktiviere verschiedene Eingabefelder für die Wasserwerte. '
      'Die bisher gespeicherte Werte gehen dabei nicht verloren! ';

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    List<UserSettings> usList = await DBHelper.db.getUserSettings();
    List<bool> measurementItems = List.generate(waterValues.length, (index) => true);
    if(usList.isEmpty){
        Map<String, dynamic> map = {
          'measurementItems': measurementItems.toString()
        };
        setState(() {
          us = UserSettings.fromMap(map);
          measurementItemsList = json.decode(us.measurementItems).cast<bool>().toList();
        });
    }else{
      setState(() {
        us = usList.first;
        measurementItemsList = json.decode(us.measurementItems).cast<bool>().toList();
      });
    }
  }

  void saveSettings() async {
    await DBHelper.db.saveUserSettings(us);
    userSettings = us;
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
      body: ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
      Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
          children: [
            const SizedBox(height: 10),
            Text(infoText,
                textAlign: TextAlign.justify, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
      ExpansionTile(
      title: const Text('Messung-Einstellungen'),
      subtitle: const Text('Wähle deine Wasserwerte aus!'),
      children: <Widget>[
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              ),
              itemCount: waterValues.length,
              itemBuilder: (BuildContext context, int index) {
              String key = waterValuesTextMap.entries.elementAt(index).value;
              return Column(children: [
                Text(key),
                Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.all(Colors.lightGreen),
                value: measurementItemsList[index],
                onChanged: (bool? value) {
                  setState(() {
                    measurementItemsList[index] = value!;
                    us.measurementItems = measurementItemsList.toString();
                    saveSettings();
                  });
                },
              ),
              ],);
              }),
        ])]))]));
  }
}
