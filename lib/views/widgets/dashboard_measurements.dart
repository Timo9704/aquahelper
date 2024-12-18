import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../util/scalesize.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class DashboardMeasurements extends StatelessWidget {
  const DashboardMeasurements({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) => Expanded(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          height: Adaptive.sh(viewModel.getAdaptiveSizePerc(18, context)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Messungen',
                textScaler: TextScaler.linear(textScaleFactor),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Messungen\n(in 30 Tage)',
                                  textScaler:
                                      TextScaler.linear(textScaleFactor),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ))),
                          const Icon(Icons.check_box_outlined,
                              color: Colors.green, size: 18),
                          Text(
                            '${viewModel.measurements30days}x',
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                        width: 2,
                        child: ColoredBox(
                          color: Colors.grey,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Messungen\n(gesamt)',
                              textScaler: TextScaler.linear(textScaleFactor),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              )),
                          const Icon(Icons.check_box_outlined,
                              color: Colors.green, size: 18),
                          Text('${viewModel.measurementsAll}x',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
