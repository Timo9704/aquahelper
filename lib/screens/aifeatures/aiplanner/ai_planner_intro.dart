import 'package:flutter/material.dart';

class AiPlannerIntro extends StatefulWidget {
  const AiPlannerIntro({super.key});

  @override
  State<AiPlannerIntro> createState() => _AiPlannerIntroState();
}

class _AiPlannerIntroState extends State<AiPlannerIntro> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Assistent"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                const Text("KI-Planer",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                const Text(
                    "Der KI-Assistent hilft dir bei allen Fragen rund um die Aquaristik. Was sind Fadenalgen und wie kann ich sie bekämpfen? Welche Pflanzen passen in mein Aquarium? Der KI-Assistent beantwortet dir alle Fragen.",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black)),
                const SizedBox(height: 10),
                Image.asset(
                    'assets/ai_assistant/ai_assistant.png',
                    fit: BoxFit.contain,
                  ),
                const SizedBox(height: 10),
                const Text(
                    "Der KI-Assistent hilft dir bei allen Fragen rund um die Aquaristik. Was sind Fadenalgen und wie kann ich sie bekämpfen? Welche Pflanzen passen in mein Aquarium? Der KI-Assistent beantwortet dir alle Fragen.",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black)),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen)),
                  onPressed: () => {},
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
