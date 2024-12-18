import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/viewmodels/dashboard_viewmodel.dart';
import 'package:aquahelper/views/widgets/dashboard_healthstatus.dart';
import 'package:aquahelper/views/widgets/dashboard_measurements.dart';
import 'package:aquahelper/views/widgets/dashboard_news.dart';
import 'package:aquahelper/views/widgets/dashboard_reminder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Dashboard extends StatelessWidget {

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    var viewModel =
    Provider.of<DashboardViewModel>(context, listen: false);
    viewModel.initDashboard(MediaQuery.sizeOf(context).height.toInt());
    viewModel.refresh();
    return Consumer<DashboardViewModel>(
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
                                      fontSize: 35,
                                      height: 1.2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800)),
                              Text(viewModel.loggedInOrLocal,
                                  textScaler: TextScaler.linear(textScaleFactor),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white)),
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
    ),);
  }
}
