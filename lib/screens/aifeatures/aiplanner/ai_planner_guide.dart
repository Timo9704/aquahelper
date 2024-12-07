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
        title: const Text("KI-Planer"),
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
                    "Entdecke den KI-Planer, dein perfekter Begleiter für die Gestaltung deines Traumaquariums! Durch eine Reihe gezielter Fragen analysiert unser KI-Planer deine Vorstellungen und Bedingungen, um das optimale Setup für dein Aquarium zu entwerfen, sei es in Bezug auf die Bepflanzung oder den Fischbesatz. Erhalte personalisierte Vorschläge, die genau zu deinen Wünschen und den Bedürfnissen deiner zukünftigen Wasserbewohner passen.",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black)),
                Text(
                    "Der KI-Assistent hilft dir bei allen Fragen rund um die Aquaristik. Was sind Fadenalgen und wie kann ich sie bekämpfen? Welche Pflanzen passen in mein Aquarium? Der KI-Assistent beantwortet dir alle Fragen.",
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
