import 'package:flutter/material.dart';

class AiPlannerGuide extends StatefulWidget {
  const AiPlannerGuide({super.key});

  @override
  State<AiPlannerGuide> createState() => _AiPlannerGuideState();
}

class _AiPlannerGuideState extends State<AiPlannerGuide> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    "Der KI-Assistent hilft dir bei allen Fragen rund um die Aquaristik. Was sind Fadenalgen und wie kann ich sie bekämpfen? Welche Pflanzen passen in mein Aquarium? Der KI-Assistent beantwortet dir alle Fragen.",
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
