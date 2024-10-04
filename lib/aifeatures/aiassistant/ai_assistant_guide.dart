import 'package:flutter/material.dart';

import '../../../util/scalesize.dart';

class AiAssistantGuide extends StatefulWidget {
  const AiAssistantGuide({super.key});

  @override
  State<AiAssistantGuide> createState() => _AiAssistantGuideState();
}

class _AiAssistantGuideState extends State<AiAssistantGuide> {
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
                Text("Anleitung KI-Assistent",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(
                    "Einführung in deinen KI-Aquaristik-Assistenten",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black)),
                const SizedBox(height: 10),
                Text(
                    "Dein KI-Assistent ist eine fortschrittliche Künstliche Intelligenz, die speziell darauf trainiert wurde, umfangreiches Wissen über Aquaristik bereitzustellen. Die Datenbank des Assistenten wird kontinuierlich erweitert und aktualisiert, um dir die relevantesten Informationen und Ratschläge zu liefern. Bitte beachte, dass trotz unserer Bemühungen, die Genauigkeit stetig zu verbessern, manchmal auch fehlerhafte Antworten auftreten können.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black)),
                const SizedBox(height: 20),
                Text(
                    "So interagierst du mit deinem KI-Assistenten:",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black)),
                const SizedBox(height: 10),
                Text(
                    "Um eine Frage zu stellen, tippe einfach deinen Text in das dafür vorgesehene Textfeld und sende die Nachricht ab. Der Assistent wird deine Anfrage analysieren und dir eine Antwort zurückgeben. Während einer Sitzung im Chat bleibt der Kontext deiner Fragen erhalten, sodass der Assistent auf frühere Interaktionen Bezug nehmen kann, um eine kohärente Konversation zu gewährleisten.Bitte beachte, dass der Kontext deiner Fragen und Antworten nur während der aktuellen Chat-Sitzung gespeichert wird. Sobald du den Chat verlässt, werden alle Informationen gelöscht, um deine Privatsphäre und Datensicherheit zu gewährleisten.Mit diesen einfachen Schritten kannst du sofort beginnen, deinen KI-Assistenten zu nutzen und deine Aquaristik-Kenntnisse zu erweitern.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black)),
                const SizedBox(height: 20),
                Text(
                    "Dir ist ein Fehler aufgefallen?",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black)),
                const SizedBox(height: 10),
                Text(
                    "Solltest du auf einen Fehler stoßen oder feststellen, dass bestimmte Themen in unserer Datenbank fehlen, zögere nicht, uns darüber zu informieren. Bitte nutze die Option 'Feedback geben' in den Einstellungen, um uns deine Anmerkungen und Vorschläge mitzuteilen.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
