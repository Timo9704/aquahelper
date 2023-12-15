import 'package:flutter/material.dart';

class ToolsStartPage extends StatefulWidget {
  const ToolsStartPage({super.key});

  @override
  State<ToolsStartPage> createState() => _ToolsStartPageState();
}

class _ToolsStartPageState extends State<ToolsStartPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              Text('Dieser Abschnitt befindet sich gerade im Aufbau!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w800)),
        ],
      );
  }
}