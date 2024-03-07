import 'package:aquahelper/screens/tools/explorer/podcasts.dart';
import 'package:aquahelper/screens/tools/explorer/websites.dart';
import 'package:flutter/material.dart';


class Explorer extends StatefulWidget {
  const Explorer({super.key});


  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  int selectedPage = 0;

  final _pageOptions = [
    const Podcasts(),
    const Websites(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Content-Explorer" ),
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
            icon: Icon(Icons.mic),
            label: 'Podcasts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web),
            label: 'Webseiten',
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