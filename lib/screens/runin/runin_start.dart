import 'package:aquahelper/screens/runin/runin_calender.dart';
import 'package:flutter/material.dart';

class RunInStart extends StatelessWidget {
  const RunInStart({super.key});

  static const String startText =
      "Super, lass uns in den kommenden 60 Tagen dein Aquarium einfahren! \n" +
          "Du bekommst von uns regelmäßig Tipps und Tricks, wie du dein Aquarium optimal pflegen kannst.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("60-Tage Einfahrphase"),
            backgroundColor: Colors.lightGreen),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              const Text("Lass uns dein Aquarium einfahren!",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              const Text(startText,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 19, color: Colors.black)),
              const SizedBox(height: 20),
              const Image(image: AssetImage('assets/images/runin_intro.png')),
              const SizedBox(height: 20),
              const Text("Dein Aquarium ist gerade erst eingerichtet?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black)),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RunInCalender()),
                    )
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Heute starten", style: TextStyle(fontSize: 20)),
                  )),
              const SizedBox(height: 20),
              const Text("Dein Aquarium ist schon länger eingerichtet?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black)),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Datum eingeben", style: TextStyle(fontSize: 20)),
                  ))
            ]),
          ),
        ));
  }
}
