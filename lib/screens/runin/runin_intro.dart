import 'package:aquahelper/screens/runin/runin_start.dart';
import 'package:flutter/material.dart';

class RunInIntro extends StatelessWidget {
  const RunInIntro({super.key});

  static const String introText = "Herzlichen Glückwunsch zu deinem neuen Aquarium! " +
      "Du hast dein Aquarium schon eingerichtet und möchtest nun wissen wie es weitergeht? " +
      "Dann bist du hier genau richtig! \n\n" +
      "Das AquaHelper-Einfahrprogramm hilft dir dabei, dein Aquarium in den ersten 60 Tagen optimal zu pflegen.";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const Text("60-Tage Einfahrphase",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          const Image(image: AssetImage('assets/images/runin_intro.png')),
          const SizedBox(height: 20),
          const Text("Einführung:",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const Text(introText,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 19, color: Colors.black)),
          const SizedBox(height: 30),
          ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RunInStart()),
                )},
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Starte die Einlaufphase jetzt!", style: TextStyle(fontSize: 20)),
              ))
        ]),
      ),
    );
  }
}
