import 'package:aquahelper/screens/tools/groundcalc/ground_calc_increase.dart';
import 'package:aquahelper/screens/tools/groundcalc/ground_calc_island.dart';
import 'package:flutter/material.dart';


class GroundCalculator extends StatefulWidget {
  const GroundCalculator({super.key});


  @override
  State<GroundCalculator> createState() => _GroundCalculatorState();
}

class _GroundCalculatorState extends State<GroundCalculator> {
  int selectedPage = 0;

  final _pageOptions = [
    const GroundCalculatorIncrease(),
    const GroundCalculatorIsland(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bodengrund-Rechner"),
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
            icon: Icon(Icons.bubble_chart),
            label: 'aufsteigend',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            label: 'Insel',
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