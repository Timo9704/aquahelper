import 'package:flutter/material.dart';

import '../../../util/scalesize.dart';

class AiPlannerGuide extends StatefulWidget {
  const AiPlannerGuide({super.key});

  @override
  State<AiPlannerGuide> createState() => _AiPlannerGuideState();
}

class _AiPlannerGuideState extends State<AiPlannerGuide> {
  double textScaleFactor = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Optimizer"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.all(22.0),
            child: Column(
              children: [
                Text("Anleitung",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 10),
                Text(
                    "Erlebe den KI-Optimierer – deinen cleveren Assistenten für ein vitales und florierendes Aquarium. Unser innovativer KI-Optimierer wertet Pflegeroutinen, Wasserqualität und die technische Ausrüstung deines Aquariums aus. Er versorgt dich mit individuellen Tipps, um die Lebensbedingungen in deinem Aquarium ideal zu gestalten.\n",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black)),
                Text(
                    "Wichtig für die Nutzung des KI-Optimierers ist die regelmäßige Speicherung deiner Wasserwerte und Pflegeaufgaben. So kann der KI-Optimierer dir die besten Empfehlungen geben, um die Bedingungen in deinem Aquarium zu optimieren. Sobald du genügend Daten gesammelt hast, kannst du den KI-Optimierer starten und von seinen Vorschlägen profitieren.\n",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black)),
                Text(
                  "Der KI-Optimierer sammelt die folgenden Daten: alle Aquariumdaten, Wasserwerte, Pflegeaufgaben und technische Ausstattung. Diese Informationen werden anonymisiert verarbeitet. Deine Daten werden nicht an Dritte weitergegeben.",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black)),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
