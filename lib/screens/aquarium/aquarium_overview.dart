import 'package:aquahelper/screens/aquarium/activities/activities_calender.dart';
import 'package:aquahelper/screens/aquarium/aquarium_components.dart';
import 'package:aquahelper/screens/runin/runin_calender.dart';
import 'package:flutter/material.dart';

import '../../model/aquarium.dart';
import 'animals/animals_list.dart';
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
        AnimalsList(aquarium: aquarium),
        //PlantsList(aquarium: aquarium),
        AquariumComponents(aquarium: aquarium),
        ActivitiesCalendar(aquariumId: aquarium.aquariumId),
        ChartAnalysis(aquariumId: aquarium.aquariumId),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(aquarium.name),
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
            icon: Icon(Icons.list),
            label: 'Tiere',
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Pflanzen',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Technik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            label: 'Aktivitäten',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Diagramm',
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
      floatingActionButton: selectedPage == 0 && widget.aquarium.runInStatus == 1 ? ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(20),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(10)),
            backgroundColor:
            MaterialStateProperty.all<Color>(Colors.lightGreen)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RunInCalender(aquarium: widget.aquarium)),
        ),
        child: const Text('6-Wochen\nEinlaufprogramm', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
      ) : null,
    );
  }
}