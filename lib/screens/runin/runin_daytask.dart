import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RunInDayTask extends StatelessWidget {
  RunInDayTask({super.key});

  String infoText = "Super, dass du dich für ein neues Aquarium entschieden hast. " +
      "Heute beginnen wir mit der Einrichtung deines Aquariums und starten die Einlaufphase! " +
      "Die Einlaufphase dient dazu das biologische Gleichgewicht in deinem Aquarium herzustellen. " +
      "Hier unten findest du die Aufgaben für den heutigen Tag:";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("60-Tage Einfahrphase"),
          backgroundColor: Colors.lightGreen),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Starten wir mit Tag 1",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(infoText,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 16, color: Colors.black)),
              const SizedBox(height: 10),
              const Image(image: AssetImage('assets/images/runin_intro.png')),
              const SizedBox(height: 10),
              Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Deine To-Do-Liste für heute:",
                          style: TextStyle(fontSize: 23, color: Colors.black)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.check_box_outlined,
                              color: Colors.lightGreen),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text("Aquarium einrichten & befüllen",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.check_box_outlined,
                              color: Colors.lightGreen),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text("Filter anschließen & einschalten",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.check_box_outlined,
                              color: Colors.lightGreen),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text("Beleuchtung auf 6 Stunden einstellen",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800)),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.check_box_outlined,
                              color: Colors.lightGreen),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text("Filter-Bakterien hinzufügen",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
