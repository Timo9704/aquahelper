import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../model/aquarium.dart';
import '../../../model/assistantpreferences.dart';
import '../../../model/measurement.dart';
import '../../../util/datastore.dart';
import '../../../util/loading_indicator.dart';
import 'ai_assistant_guide.dart';
import 'ai_assistant_preferences.dart';

class AiAssistantChat extends StatefulWidget {
  const AiAssistantChat({super.key});

  @override
  State<AiAssistantChat> createState() => _AiAssistantChatState();
}

class _AiAssistantChatState extends State<AiAssistantChat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  String sessionId = "";
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hallo! Ich bin dein neuer KI-Assistent. Wobei kann ich dir helfen?', 'isMe': false},
  ];
  bool _isLoading = false;
  late AssistantPreferences assistantPreferences;
  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  getPreferences() async {
    AssistantPreferences preferences = await Datastore.db.getAIAssistantPreferences();
    setState(() {
      assistantPreferences = preferences;
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final String messageText = _controller.text;

    setState(() {
      _messages.add({'text': messageText, 'isMe': true});
      _isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    _controller.clear();

    Aquarium aquarium = await Datastore.db.getAquariumById(assistantPreferences.aquarium);

    List<Measurement> measurementsList = await Datastore.db.getSortedMeasurmentsList(aquarium);

    Measurement latestMeasurement = measurementsList.first;

    final Map<String, dynamic> preferences = {
      "experience_level": assistantPreferences.experienceLevel,
      "detail_level": assistantPreferences.detailLevel,
    };

    final Map<String, String> latestWaterParameters = {
      "ph": latestMeasurement.ph.toString(),
      "gh": latestMeasurement.totalHardness.toString(),
      "kh": latestMeasurement.carbonateHardness.toString(),
      "no2": latestMeasurement.nitrite.toString(),
      "no3": latestMeasurement.nitrate.toString(),
      "po4": latestMeasurement.phosphate.toString(),
      "fe": latestMeasurement.iron.toString(),
      "k": latestMeasurement.potassium.toString()
    };

    final Map<String, dynamic> aquariumData = {
      "aquarium_liter": aquarium.liter.toString(),
      "water_parameters": latestWaterParameters
    };

    Map<String, dynamic> aiInput;
    if(sessionId.isEmpty) {
      aiInput = {
        "human_input": messageText
      };
    } else {
      aiInput = {
        "human_input": messageText,
        "session_id": sessionId
      };
    }

    final postData = jsonEncode({
      "preferences": preferences,
      "aquarium_data": aquariumData,
      "ai_input": aiInput
    });

    final response = await http.post(
      Uri.parse('https://1gbk36sq3g.execute-api.eu-west-2.amazonaws.com/v1/assistant'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: postData,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        sessionId = responseData['session_id'];
      });
      setState(() {
        _messages.add({'text': responseData['answer'], 'isMe': false});
      });
    } else {
      setState(() {
        _messages.add({'text': 'Fehler beim Senden der Nachricht', 'isMe': false});
      });
    }
    setState(() {
      _isLoading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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

  Widget buildLoadingIndicator() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: LoadingIndicator(),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Einstellungen':
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AiAssistantPreferences()));
        break;
      case 'Anleitung':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AiAssistantGuide()));
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Assistent"),
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Einstellungen', 'Anleitung'}.map((String choice) {
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
          const Text("KI-Assistent",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w800)),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return buildLoadingIndicator();
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Nachricht eingeben...',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.lightGreen,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  onPressed: _sendMessage,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.lightGreen),
                  ),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
          const Text("Der KI-Assistent kann Fehler machen. Überprüfe wichtige Informationen.",
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.w300)),
          const SizedBox(
            height: 10,)
        ],
      ),
    );
  }
}