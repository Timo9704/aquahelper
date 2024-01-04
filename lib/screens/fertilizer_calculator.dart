import 'package:aquahelper/screens/fertilizer/fertilizer_consumption.dart';
import 'package:flutter/material.dart';

import 'package:aquahelper/screens/infopage.dart';
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