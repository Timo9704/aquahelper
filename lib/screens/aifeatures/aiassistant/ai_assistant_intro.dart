import 'package:flutter/material.dart';
import '../../../util/scalesize.dart';
import 'ai_assistant_chat.dart';

class AiAssistantIntro extends StatefulWidget {
  const AiAssistantIntro({super.key});

  @override
  State<AiAssistantIntro> createState() => _AiAssistantIntroState();
}

class _AiAssistantIntroState extends State<AiAssistantIntro> {
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
        title: const Text("KI-Assistent"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                Text("KI-Assistent",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(
                    "Entdecke deinen digitalen Aquaristik-Experten! Unser KI-Assistent ist dein persönlicher Berater in der Welt der Aquarienpflege. Stellst du dich der Herausforderung von Fadenalgen? Fragst du dich, welche Pflanzen am besten zu deinem Wasserbiotop passen?",
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
                    "Kein Problem! Mit fundiertem Wissen und praktischen Tipps steht dir unser Assistent zur Seite, um all deine Fragen zu beantworten und dir zu helfen, dein Aquarium in ein blühendes Unterwasserparadies zu verwandeln. Egal ob Anfänger oder erfahrener Aquarianer, unser KI-Assistent ist immer bereit, dir mit Rat und Tat zur Seite zu stehen.",
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
                    MaterialPageRoute(builder: (context) => const AiAssistantChat(optimizerText: "")), // Seite wechseln zu AiAssistantIntro
                  ),
                  child: const Text('KI-Assistent starten', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
