import 'package:aquahelper/screens/aifeatures/aiplanner/ai_planner.dart';
import 'package:flutter/material.dart';

import '../../../util/scalesize.dart';

class AiPlannerIntro extends StatefulWidget {
  const AiPlannerIntro({super.key});

  @override
  State<AiPlannerIntro> createState() => _AiPlannerIntroState();
}

class _AiPlannerIntroState extends State<AiPlannerIntro> {
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                Text("KI-Planer",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(
                    "Entdecke den KI-Planer, dein perfekter Begleiter für die Gestaltung deines Traumaquariums! Durch eine Reihe gezielter Fragen analysiert unser KI-Planer deine Vorstellungen und Bedingungen, um das optimale Setup für dein Aquarium zu entwerfen, sei es in Bezug auf die Bepflanzung oder den Fischbesatz.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black)),
                const SizedBox(height: 10),
                Image.asset(
                    'assets/ai_assistant/ai_assistant.png',
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    fit: BoxFit.contain,
                  ),
                const SizedBox(height: 10),
                Text(
                    "Erhalte personalisierte Vorschläge, die genau zu deinen Wünschen passen, um eine harmonische Umgebung für deine Wasserbewohner zu schaffen, die sowohl ästhetisch ansprechend als auch biologisch nachhaltig ist.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black)),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(250, 70)),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AiPlanner()),
                  ),
                  child: const Text('KI-Planer starten', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
