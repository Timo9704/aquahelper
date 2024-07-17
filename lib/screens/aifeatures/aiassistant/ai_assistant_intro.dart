import 'package:flutter/material.dart';

import 'ai_assistant_chat.dart';

class AiAssistantIntro extends StatefulWidget {
  const AiAssistantIntro({super.key});

  @override
  State<AiAssistantIntro> createState() => _AiAssistantIntroState();
}

class _AiAssistantIntroState extends State<AiAssistantIntro> {
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
            padding: EdgeInsets.all(22.0),
            child: Column(
              children: [
                Text("KI-Assistent",
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
                SizedBox(height: 10),
                Image.asset(
                    'assets/ai_assistant/ai_assistant.png',
                    fit: BoxFit.contain,
                  ),
                SizedBox(height: 10),
                Text(
                    "Der KI-Assistent hilft dir bei allen Fragen rund um die Aquaristik. Was sind Fadenalgen und wie kann ich sie bekämpfen? Welche Pflanzen passen in mein Aquarium? Der KI-Assistent beantwortet dir alle Fragen.",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black)),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AiAssistantChat()), // Seite wechseln zu AiAssistantIntro
                  ),
                  child: Text('KI-Assistent starten', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
