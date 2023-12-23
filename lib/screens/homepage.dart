import 'package:aquahelper/screens/dashboard.dart';
import 'package:aquahelper/screens/tools_startpage.dart';
import 'package:flutter/material.dart';

import 'package:aquahelper/screens/infopage.dart';

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
    const ToolsStartPage()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AquaHelper"),
        backgroundColor: Colors.lightGreen,
        actions: [
          PopupMenuButton(
              itemBuilder: (context){
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Informationen"),
                  ),
                ];
              },
              onSelected:(value) {
                if (value == 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const InfoPage()),
                  );
                }
              }
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.settings),
            label: 'Tools',
          ),
        ],
        currentIndex: selectedPage,
        onTap: (index){
          setState(() {
            selectedPage = index;
          });
        },
      ),
      body: _pageOptions[selectedPage],
    );
  }
}