import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  String infoText =
      'AquaHelper ist die ultimative App für alle Aquarianer und Aquascaper. '
      'Der AquaHelper bietet dir eine einfache und effiziente Möglichkeit Wasserwerte zu verfolgen und zu speichern. '
      'Du kannst wichtige Wasserparameter wie pH-Wert, Härte, Nitratgehalt und vieles mehr schnell erfassen.';


  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const Text('Über diese App',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height:10),
          Text(infoText,textAlign: TextAlign.justify, style: const TextStyle(fontSize: 16)),
          const SizedBox(height:10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text("FAQ"),
            ),
          ),
          const SizedBox(height:10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text("Software-Version"),
            ),
          ),
          const SizedBox(height:10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text("Feedback geben"),
            ),
          ),
          const SizedBox(height:10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text("Export/Import von Daten"),
            ),
          ),
          const SizedBox(height:10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text("Impressum"),
            ),
          ),
          const SizedBox(height:10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text("Datenschutzbestimmungen"),
            ),
          ),
        ],
      );
  }
}
