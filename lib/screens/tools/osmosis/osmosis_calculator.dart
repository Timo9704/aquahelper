import 'package:aquahelper/screens/tools/osmosis/osmosis_liter_tab.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';

import 'osmosis_waterchange_tab.dart';


class OsmosisCalculator extends StatefulWidget {
  const OsmosisCalculator({super.key});


  @override
  State<OsmosisCalculator> createState() => _OsmosisCalculatorState();
}

class _OsmosisCalculatorState extends State<OsmosisCalculator> {
  int selectedPage = 0;

  final _pageOptions = [
    const OsmosisLiterTab(),
    const OsmosisWaterChangeTab(),
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
            icon: Icon(Icons.switch_left),
            label: 'Osmose-Leitungswasser',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.switch_right),
            label: 'Osmose-Wasserwechsel',
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