import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/aquarium.dart';
import '../../util/scalesize.dart';
import '../../viewmodels/widgets/dashboard_healthstatus_viewmodel.dart';

class DashboardHealthStatus extends StatelessWidget {
  const DashboardHealthStatus({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => DashboardHealthStatusViewModel(),
      child: Consumer<DashboardHealthStatusViewModel>(
        builder: (context, viewModel, child) => Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              //border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text('Health Status',
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 21, color: Colors.black, fontWeight: FontWeight.bold)),
                Text(
                    'keine Messung in den letzten 7 Tagen (gelb) / 14 (orange) / 30 (rot) ',
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
                const SizedBox(height: 5),
                SizedBox(
                  height: 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: viewModel.aquariums
                            .map((aquarium) => buildAquariumItem(aquarium))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAquariumItem(Aquarium aquarium) {
    List<Color> colorCodes = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lightbulb,
              size: 30, color: colorCodes.elementAt(aquarium.healthStatus)),
          const SizedBox(height: 3),
          Text(aquarium.name,
              style: const TextStyle(fontSize: 12, color: Colors.black))
        ],
      ),
    );
  }
}
