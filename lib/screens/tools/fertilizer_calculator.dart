import 'package:aquahelper/screens/tools/fertilizer/fertilizer_consumption.dart';
import 'package:flutter/material.dart';

import 'fertilizer/fertilizer_converter.dart';


class FertilizerCalculator extends StatefulWidget {
  const FertilizerCalculator({super.key});


  @override
  State<FertilizerCalculator> createState() => _FertilizerCalculatorState();
}

class _FertilizerCalculatorState extends State<FertilizerCalculator> {
  int selectedPage = 0;

  final _pageOptions = [
    const FertilizerConverter(),
    const FertilizerConsumption(),
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
            label: 'Konverter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled),
            label: 'Verbrauch',
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