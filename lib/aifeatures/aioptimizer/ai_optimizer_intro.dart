import 'package:aquahelper/aifeatures/aioptimizer/qa_process/ai_optimizer_aquarium.dart';
import 'package:flutter/material.dart';

import '../../model/ai_optimizer_storage.dart';
import '../../util/scalesize.dart';

class AiOptimizerIntro extends StatefulWidget {
  const AiOptimizerIntro({super.key});

  @override
  State<AiOptimizerIntro> createState() => _AiOptimizerIntroState();
}

class _AiOptimizerIntroState extends State<AiOptimizerIntro> {
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
        title: const Text("KI-Optimierer"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                Text("KI-Optimierer",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(
                    "Entdecke den KI-Optimierer – deinen intelligenten Helfer für ein gesundes und blühendes Aquarium. Unser fortschrittlicher KI-Optimierer analysiert Pflegeaufgaben, Wasserwerte und die technische Ausstattung deines Aquariums. Er gibt dir maßgeschneiderte Empfehlungen, um die Bedingungen in deinem Aquarium zu optimieren.",
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
                    "Erhalte personalisierte Vorschläge für deine Aquarien! Egal ob es um die Verbesserung der Wasserqualität oder die Effizienz der Technik geht, der KI-Optimierer steht dir zur Seite, damit dein Aquarium nicht nur gut, sondern perfekt läuft.",
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
                      WidgetStateProperty.all<Color>(Colors.lightGreen),
                      minimumSize: WidgetStateProperty.all<Size>(const Size(250, 70)),
                  ),
                  onPressed: () {
                    AiOptimizerStorage aiOptimizerStorageObj = AiOptimizerStorage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AiOptimizerAquarium(aiOptimizerObject: aiOptimizerStorageObj)));
                  },
                  child: const Text('KI-Optimierer starten', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
