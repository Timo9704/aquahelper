import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_overview_viewmodel.dart';
import 'package:aquahelper/views/aquarium/aquarium_animals_overview.dart';
import 'package:aquahelper/views/aquarium/aquarium_measurement_reminder.dart';
import 'package:aquahelper/views/aquarium/aquarium_charts.dart';
import 'package:aquahelper/views/aquarium/aquarium_plants.dart';
import 'package:aquahelper/views/tools/runin/runin_calender.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'aquarium_activities_calender.dart';
import 'aquarium_technic.dart';

class AquariumOverview extends StatelessWidget {
  final Aquarium aquarium;

  const AquariumOverview({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width.toInt();
    return ChangeNotifierProvider(
      create: (context) => AquariumOverviewViewModel(aquarium, width),
      child: Consumer<AquariumOverviewViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
              title: Text(viewModel.aquarium.name),
              backgroundColor: Colors.lightGreen),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BottomNavigationBar(
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
              BottomNavigationBarItem(
                icon: Icon(Icons.eco),
                label: 'Pflanzen',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.build),
                label: 'Technik',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_rounded),
                label: 'Aktivitäten',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Diagramm',
              ),
            ],
                currentIndex: viewModel.selectedPage,
                onTap: (index) {
                  viewModel.setSelectedPage(index);
                },
              ),
              if (!viewModel.isPremium &&
                  viewModel.anchoredAdaptiveAd != null &&
                  viewModel.isLoaded)
                Column(
                  children: <Widget>[
                    SizedBox(
                      height:
                      viewModel.anchoredAdaptiveAd!.size.height.toDouble(),
                      child: AdWidget(ad: viewModel.anchoredAdaptiveAd!),
                    ),
                  ],
                ),
            ],
          ),
          body: IndexedStack(
            index: viewModel.selectedPage,
            children: [
              AquariumMeasurementReminder(aquarium: aquarium),
              AquariumAnimalsOverview(aquarium: aquarium),
              AquariumPlants(aquarium: aquarium),
              AquariumTechnic(aquarium: aquarium),
              AquariumActivitiesCalendar(aquariumId: aquarium.aquariumId),
              AquariumCharts(aquariumId: aquarium.aquariumId),
            ],
          ),
          floatingActionButton: viewModel.selectedPage == 0 &&
                  viewModel.aquarium.runInStatus == 1
              ? ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(20),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(10)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightGreen)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RunInCalender(aquarium: viewModel.aquarium)),
                  ),
                  child: const Text('6-Wochen\nEinlaufprogramm',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                )
              : null,
        ),
      ),
    );
  }
}
