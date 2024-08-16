import 'package:aquahelper/screens/runin/runin_calender.dart';
import 'package:flutter/material.dart';

import '../../model/aquarium.dart';
import '../../util/datastore.dart';
import '../../util/scalesize.dart';

class RunInStart extends StatefulWidget {
  final Aquarium aquarium;
  const RunInStart({super.key, required this.aquarium});

  @override
  State<RunInStart> createState() => _RunInStartState();
}

class _RunInStartState extends State<RunInStart> {
  double textScaleFactor = 0;

  @override
  void initState() {
    super.initState();
  }

  static const String startText =
      "Super, lass uns in den kommenden 6 Wochen dein Aquarium einfahren! \nDu bekommst von uns regelmäßig Tipps und Tricks, wie du dein Aquarium optimal pflegen kannst.";

  void setRunInData() {
    widget.aquarium.runInStatus = 1;
    widget.aquarium.runInStartDate = DateTime.now().millisecondsSinceEpoch;
    Datastore.db.updateAquarium(widget.aquarium);
  }

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
              Text("Lass uns dein Aquarium einfahren!",
                  textScaler: TextScaler.linear(textScaleFactor),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(startText,
                  textScaler: TextScaler.linear(textScaleFactor),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 23, color: Colors.black)),
              const SizedBox(height: 20),
              const Image(image: AssetImage('assets/images/runin_intro.png')),
              const SizedBox(height: 20),
              Text("Dein Aquarium ist gerade erst eingerichtet?",
                  textScaler: TextScaler.linear(textScaleFactor),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 23,
                      color: Colors.black)),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => {
                    setRunInData(),
                    Navigator.push(
                      context,
                        MaterialPageRoute(builder: (context) => RunInCalender(aquarium: widget.aquarium)),
                    )
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Heute starten", textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 23)),
                  )),
              const SizedBox(height: 20),
            ]),
          ),
        ));
  }
}
