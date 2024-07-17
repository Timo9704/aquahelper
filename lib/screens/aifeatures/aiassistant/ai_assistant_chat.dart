import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiAssistantChat extends StatefulWidget {
  const AiAssistantChat({super.key});

  @override
  State<AiAssistantChat> createState() => _AiAssistantChatState();
}

class _AiAssistantChatState extends State<AiAssistantChat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hallo! Ich bin dein neuer KI-Assistent. Wobei kann ich dir helfen?', 'isMe': false},
  ];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final String messageText = _controller.text;

    setState(() {
      _messages.add({'text': messageText, 'isMe': true});
      _isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    //_controller.clear();

    // Hier wird der API-Request abgesetzt
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/assistant/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "human_input": messageText,
        "session_id": ""
      }),
    );
    print(jsonEncode(<String, String>{
      "human_input": messageText,
      "session_id": ""
    }));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
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
      duration: Duration(milliseconds: 300),
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
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
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

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Assistent"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          Text("KI-Assistent",
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
                  return _buildLoadingIndicator();
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nachricht eingeben...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: _sendMessage,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.lightGreen),
                  ),
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildLoadingIndicator() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: LoadingIndicator(),
    ),
  );
}
}

class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<int>? _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    _dotsAnimation = StepTween(
      begin: 0,
      end: 3,
    ).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotsAnimation!,
      builder: (context, child) {
        String dots = '.' * _dotsAnimation!.value;
        return Text('KI-Assistent schreibt $dots', style: TextStyle(fontSize: 16.0));
      },
    );
  }
}