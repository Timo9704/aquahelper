import 'package:flutter/material.dart';

import '../model/aquarium.dart';
import 'aquarium_measurement_reminder.dart';
import 'chart_analysis.dart';


class AquariumOverview extends StatefulWidget {
  const AquariumOverview({super.key, required this.aquarium});
  final Aquarium aquarium;


  @override
  State<AquariumOverview> createState() => _AquariumOverviewState();
}

class _AquariumOverviewState extends State<AquariumOverview> {
  int selectedPage = 0;
  late Aquarium aquarium;

  var _pageOptions = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      aquarium = widget.aquarium;
      _pageOptions = [
        AquariumMeasurementReminder(aquarium: aquarium),
        ChartAnalysis(aquariumId: aquarium.aquariumId),
        AquariumMeasurementReminder(aquarium: aquarium),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("AquaHelper"),
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
            icon: Icon(Icons.dashboard),
            label: 'Übersicht',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Wasserwertverlauf',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            label: 'Besatz',
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