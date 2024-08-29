import 'package:aquahelper/screens/general/dashboard.dart';
import 'package:aquahelper/screens/settings/settings.dart';
import 'package:aquahelper/screens/tools/tools_startpage.dart';
import 'package:flutter/material.dart';

import '../aifeatures/aiassistant/ai_assistant_intro.dart';
import 'aquarium_startpage.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});


  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedPage = 0;

  final _pageOptions = [
    const Dashboard(),
    const AquariumStartPage(),
    const ToolsStartPage(),
    const Settings()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("AquaHelper" ),
        backgroundColor: Colors.lightGreen
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.grey[700],
        selectedIconTheme: IconThemeData(color: Colors.grey[700]),
        unselectedIconTheme: IconThemeData(color: Colors.grey[700]),
        unselectedLabelStyle: TextStyle(color: Colors.grey[700]),
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Startseite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rectangle_outlined),
            label: 'Aquarien',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_alt_sharp),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
        currentIndex: selectedPage,
        onTap: (index) async {
          setState(() {
            selectedPage = index;
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          });
        },
      ),
      body: _pageOptions[selectedPage],
      floatingActionButton: selectedPage == 9999 ? ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(20),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(10)),
            backgroundColor:
            MaterialStateProperty.all<Color>(Colors.lightGreen)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AiAssistantIntro()),
        ),
        child: const Text('KI\nAssistent', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
      ) : null,
    );
  }
}