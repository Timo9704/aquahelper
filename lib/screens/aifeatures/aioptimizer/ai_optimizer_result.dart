
import 'package:aquahelper/screens/aifeatures/aiassistant/ai_assistant_chat.dart';
import 'package:flutter/material.dart';
import 'ai_optimizer_guide.dart';

class AiOptimizerResult extends StatefulWidget {
  final Map<String, dynamic> jsonData;


  const AiOptimizerResult(
      {super.key, required this.jsonData});

  @override
  State<AiOptimizerResult> createState() => _AiOptimizerResultState();
}

class _AiOptimizerResultState extends State<AiOptimizerResult> {
  double textScaleFactor = 0;
  final bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hallo! Ich bin dein neuer KI-Optimierer. Ich habe deine Daten gerade analysiert und kann dir endlich die Ergebnisse zeigen:', 'isMe': false},
  ];

  @override
  void initState() {
    super.initState();
    _messages.add({'text': widget.jsonData['identified_problems'], 'isMe': false});
    _messages.add({'text': widget.jsonData['suggested_solutions'], 'isMe': false});
  }

  void handleClick(String value) {
    switch (value) {
      case 'Anleitung':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AiPlannerGuide()));
        break;
    }
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final bool isMe = message['isMe'];
    final color = isMe ? Colors.blue[100] : Colors.grey[300];
    final textAlign = isMe ? TextAlign.start : TextAlign.start;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Text(
          message['text'],
          textAlign: textAlign,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
          children: [
            const Text("KI-Optimierer",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w800)),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.lightGreen),
                minimumSize: MaterialStateProperty.all<Size>(const Size(250, 70)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AiAssistantChat(optimizerText: 'Analysiere die Probleme und gebe eine ausführliche Antwort: \n $widget.jsonData[\'identified_problems\'] $widget.jsonData[\'suggested_solutions\']')),
                );
              },
              child: const Text('Mehr Informaionen im KI-Assistent ', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20),
            ]),);

  }
}
