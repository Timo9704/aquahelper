import 'package:aquahelper/views/widgets/dashboard_healthstatus.dart';
import 'package:aquahelper/views/widgets/dashboard_measurements.dart';
import 'package:aquahelper/views/widgets/dashboard_news.dart';
import 'package:aquahelper/views/widgets/dashboard_reminder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/scalesize.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class Dashboard extends StatelessWidget {

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    final height = MediaQuery.of(context).size.height.toInt();
    return ChangeNotifierProvider(
        create: (context) => DashboardViewModel(height),
        child: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) => Stack(
      children: [
        Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      widthFactor: 1,
                      heightFactor: viewModel.heightFactor,
                      child: Image.asset('assets/images/aquarium.jpg')),
                ),
                Positioned.fill(
                    child: Container(
                      width: double.infinity,
                      //height: 155,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.black54,
                      ),
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(viewModel.title,
                                  textScaler: TextScaler.linear(textScaleFactor),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 45,
                                      height: 1.2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800)),
                              Text(viewModel.loggedInOrLocal,
                                  textScaler: TextScaler.linear(textScaleFactor),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ],
                          )),
                    ))
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Row(children: [
                DashboardReminder(),
                SizedBox(
                  width: 5,
                ),
                DashboardMeasurements()
              ]),
            ),
            const DashboardHealthStatus(),
            const Expanded(
              child: DashboardNews(),
            ),
          ],
        ),
        if(viewModel.announcementVisible)
          Align(
            alignment: Alignment.bottomCenter, // Zentriert den Button in der Mitte des Bildschirms
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                      ),
                      onPressed: () => viewModel.showMaterialBanner(context, viewModel.announcement),
                      child: const Text('Wichtige Information')
                  ),
                  const SizedBox(height: 10)
                ]),
          ),
      ],
    ),),);
  }
}
