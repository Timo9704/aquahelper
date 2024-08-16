import 'package:aquahelper/screens/runin/runin_calender.dart';
import 'package:aquahelper/screens/runin/runin_start.dart';
import 'package:flutter/material.dart';
import '../../model/aquarium.dart';
import '../../util/datastore.dart';
import '../../util/scalesize.dart';

class RunInIntro extends StatefulWidget {
  const RunInIntro({super.key});

  @override
  State<RunInIntro> createState() => _RunInIntroState();
}

class _RunInIntroState extends State<RunInIntro> {
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];
  double textScaleFactor = 0;
  late Aquarium aquarium;

  @override
  void initState() {
    super.initState();
    loadAquariums();
  }

  void switchToRunInCalender() {
    if(mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RunInCalender(aquarium: aquarium)),
      );
    }
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      _aquariumNames = dbAquariums;
      _selectedAquarium = dbAquariums.first;
      aquarium = _selectedAquarium!;
    });
  }

  static const String introText = "Herzlichen Glückwunsch zu deinem neuen Aquarium! Du hast dein Aquarium schon eingerichtet und möchtest nun wissen wie es weitergeht? Dann bist du hier genau richtig! \nDas AquaHelper-Einfahrprogramm hilft dir dabei, dein Aquarium in den ersten 6 Wochen optimal zu pflegen.";

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
        appBar: AppBar(
        title: const Text("6-Wochen Einfahrphase"),
    backgroundColor: Colors.lightGreen),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const SizedBox(height: 20),
          const Image(image: AssetImage('assets/images/runin_intro.png')),
          const SizedBox(height: 20),
          Text("Einführung:",
              textScaler: TextScaler.linear(textScaleFactor),
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(introText,
              textScaler: TextScaler.linear(textScaleFactor),
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 23, color: Colors.black)),
          const SizedBox(height: 30),
          Column(children: [
            Text(
                'Welches Aquarium möchtest du einfahren?',
                textScaler: TextScaler.linear(textScaleFactor),
                style: const TextStyle(
                    fontSize: 23, color: Colors.black)),
            DropdownButton<Aquarium>(
              value: _selectedAquarium,
              items: _aquariumNames
                  .map<DropdownMenuItem<Aquarium>>(
                      (Aquarium value) {
                    return DropdownMenuItem<Aquarium>(
                      value: value,
                      child: Text(value.name,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black)),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedAquarium = newValue;
                  aquarium = newValue!;
                });
              },
            ),
          ]),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RunInStart(aquarium: aquarium)),
                )},
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Starte die Einlaufphase jetzt!", textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 23)),
              ))
        ]),
      ),
    ));
  }
}
