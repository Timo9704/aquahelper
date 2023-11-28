import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.appName;
    });
  }

 String infoText = '''
AquaHelper ist die ultimative App für alle Aquarianer und Aquascaper. Der AquaHelper bietet dir eine einfache und effiziente Möglichkeit Wasserwerte zu verfolgen und zu speichern. Du kannst wichtige Wasserparameter wie pH-Wert, Härte, Nitratgehalt und vieles mehr schnell erfassen.

Features:
- Einfache Dateneingabe: Erfassen Sie Ihre Wasserwerte in wenigen Sekunden.
- Verlaufsanzeige: Visualisieren Sie die Entwicklung Ihrer Wasserwerte über die Zeit hinweg. Diese Funktion hilft Ihnen, Muster zu erkennen und mögliche Probleme in Ihrem Aquarium frühzeitig zu identifizieren.
- Tipps und Tricks: Profitieren Sie von unseren Expertentipps, um Ihr Aquarium in bestem Zustand zu halten.

Wir sind ständig bemüht, die App zu verbessern und zu erweitern, um deine Erfahrungen als Aquarianer oder Aquascaper zu bereichern. Für Feedback, Anregungen oder bei Fragen kannst du uns jederzeit über die unten genannte E-Mail-Adresse erreichen.
''';

  String imprint = '''
Verantwortlich für den Inhalt:

Timo Schmitz
Kirchstraße 48
53332 Bornheim''';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informationen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text('Willkommen bei AquaHelper!',textAlign: TextAlign.center , style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(infoText, style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text('Impressum', textAlign: TextAlign.center , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(imprint, textAlign: TextAlign.center , style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text('App-Version: 1.0.0',textAlign: TextAlign.center , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          // Ihr Impressum-Text hier
        ],
      ),
    );
  }
}
