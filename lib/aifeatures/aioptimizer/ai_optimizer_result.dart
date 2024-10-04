import 'package:aquahelper/aifeatures/aiassistant/ai_assistant_chat.dart';
import 'package:flutter/material.dart';
import '../../../util/scalesize.dart';
import '../../../aifeatures/aioptimizer/ai_optimizer_guide.dart';

class AiOptimizerResult extends StatefulWidget {
  final Map<String, dynamic> jsonData;

  const AiOptimizerResult({super.key, required this.jsonData});

  @override
  State<AiOptimizerResult> createState() => _AiOptimizerResultState();
}

class _AiOptimizerResultState extends State<AiOptimizerResult> {
  double textScaleFactor = 0;

  @override
  void initState() {
    super.initState();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Anleitung':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AiPlannerGuide()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Optimierer"),
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Anleitung'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Text("KI-Optimierer",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Text(
                  "Hallo! Ich bin dein neuer KI-Optimierer. Ich habe deine Daten gerade analysiert und kann dir endlich die Ergebnisse zeigen:",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Text(
                  "Diese Probleme konnte ich finden:",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Text(
                  widget.jsonData['identified_problems'],
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Text(
                  "Meine Lösungsvorschläge für dich:",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Text(
                  widget.jsonData['suggested_solutions'],
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Column(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightGreen),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(200, 40)),
              ),
              onPressed: () {
                String problems = widget.jsonData['identified_problems'];
                String solutions = widget.jsonData['suggested_solutions'];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AiAssistantChat(
                          optimizerText:
                              'Analysiere die Probleme und gebe eine ausführliche Antwort: $problems $solutions')),
                );
              },
              child: const Text('Mehr Informaionen im KI-Assistent ',
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
