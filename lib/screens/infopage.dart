import 'dart:ui';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState() {
    super.initState();
  }

  String infoText =
      'AquaHelper ist die ultimative App für alle Aquarianer und Aquascaper. '
      'Der AquaHelper bietet dir eine einfache und effiziente Möglichkeit Wasserwerte zu verfolgen und zu speichern. '
      'Du kannst wichtige Wasserparameter wie pH-Wert, Härte, Nitratgehalt und vieles mehr schnell erfassen.';

  String featureText = 'Features:\n '
      '- Erfassen deine Wasserwerte in wenigen Sekunden.\n '
      '- Visualisieren die Entwicklung der Wasserwerte über die Zeit hinweg.\n'
      'Diese Funktion hilft dir, Muster zu erkennen und mögliche Probleme in Ihrem Aquarium frühzeitig zu identifizieren.\n';

  String contactText =
      'Wir sind ständig bemüht, die App zu verbessern und zu erweitern, um deine Erfahrungen als Aquarianer oder Aquascaper zu bereichern. '
      'Für Feedback, Anregungen oder bei Fragen kannst du uns jederzeit über die unten genannte E-Mail-Adresse erreichen.';

  String imprint =
      'Verantwortlich für den Inhalt:\n Timo Schmitz\n Kirchstraße 48\n 53332 Bornheim';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informationen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const Text('Willkommen bei AquaHelper!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          Card(
            elevation: 15,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(infoText, style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(featureText, style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(contactText, style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  const Text('Impressum',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(imprint,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  const Text('App-Version: 1.0.0',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  // Ihr Impressum-Text hier
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
