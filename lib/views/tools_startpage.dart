import 'package:aquahelper/viewmodels/tools_startpage_viewmodel.dart';
import 'package:aquahelper/views/items/icon_button.dart';
import 'package:aquahelper/views/tools/explorer.dart';
import 'package:aquahelper/views/tools/fertilizer_calculator.dart';
import 'package:aquahelper/views/tools/ground_calculator.dart';
import 'package:aquahelper/views/tools/light_calculator.dart';
import 'package:aquahelper/views/tools/multitimer/multi_timer.dart';
import 'package:aquahelper/views/tools/osmosis_calculator.dart';
import 'package:aquahelper/views/tools/runin/runin_intro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToolsStartPage extends StatelessWidget {
  const ToolsStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ToolsStartPageViewModel(),
      child: Consumer<ToolsStartPageViewModel>(
        builder: (context, viewModel, child) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                Expanded(
                  child: GridView.count(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                      crossAxisCount: 2,
                      childAspectRatio: 1.25,
                      children: [
                        IconTextButton(
                          imagePath: 'assets/buttons/explorer.png',
                          text: 'Content-Explorer',
                          onPressed: () {
                            viewModel.logEvent('openContentExplorer');
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const Explorer()),
                            );
                          },
                        ),
                        IconTextButton(
                          imagePath: 'assets/buttons/fertilizer_calculator.png',
                          text: 'Dünger-Rechner',
                          onPressed: () {
                            viewModel.logEvent('openFertilizerCalculator');
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FertilizerCalculator()),
                            );
                          },
                        ),
                        !viewModel.isPremiumUser
                            ? IconTextButton(
                                imagePath:
                                    'assets/buttons/soil_calculator_deactivated.png',
                                text: 'Bodengrund-Rechner',
                                onPressed: () {
                                  viewModel.logEvent('openGroundCalculator');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GroundCalculator()),
                                  );
                                },
                              )
                            : IconTextButton(
                                imagePath:
                                    'assets/buttons/soil_calculator_activated.png',
                                text: 'Bodengrund-Rechner',
                                onPressed: () {
                                  viewModel.logEvent('openGroundCalculator');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GroundCalculator()),
                                  );
                                },
                              ),
                        !viewModel.isPremiumUser
                            ? IconTextButton(
                                imagePath:
                                    'assets/buttons/light_calculator_deactivated.png',
                                text: 'Licht-Rechner',
                                onPressed: () {
                                  viewModel.logEvent('openLightCalculator');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LightCalculator()),
                                  );
                                },
                              )
                            : IconTextButton(
                                imagePath:
                                    'assets/buttons/light_calculator_activated.png',
                                text: 'Licht-Rechner',
                                onPressed: () {
                                  viewModel.logEvent('openLightCalculator');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LightCalculator()),
                                  );
                                },
                              ),
                        !viewModel.isPremiumUser
                            ? IconTextButton(
                                imagePath:
                                    'assets/buttons/runin_deactivated.png',
                                text: '6-Wochen Einfahrguide',
                                onPressed: () {
                                  viewModel.logEvent('runIn');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RunInIntro()),
                                  );
                                },
                              )
                            : IconTextButton(
                                imagePath: 'assets/buttons/runin_activated.png',
                                text: '6-Wochen Einfahrguide',
                                onPressed: () {
                                  viewModel.logEvent('runIn');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RunInIntro()),
                                  );
                                },
                              ),
                        !viewModel.isPremiumUser
                            ? IconTextButton(
                                imagePath:
                                    'assets/buttons/osmosis_deactivated.png',
                                text: 'Osmose-Rechner',
                                onPressed: () {
                                  viewModel.logEvent('osmosisCalculator');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OsmosisCalculator()),
                                  );
                                },
                              )
                            : IconTextButton(
                                imagePath:
                                    'assets/buttons/osmosis_activated.png',
                                text: 'Osmose-Rechner',
                                onPressed: () {
                                  viewModel.logEvent('osmosisCalculator');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OsmosisCalculator()),
                                  );
                                },
                              ),
                        !viewModel.isPremiumUser
                            ? IconTextButton(
                                imagePath:
                                    'assets/buttons/stopwatch_deactivated.png',
                                text: 'Multitimer',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MultiTimer()),
                                  );
                                },
                              )
                            : IconTextButton(
                                imagePath:
                                    'assets/buttons/stopwatch_activated.png',
                                text: 'Multitimer',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MultiTimer()),
                                  );
                                },
                              ),
                      ]),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!viewModel.isPremiumUser)
                      ElevatedButton(
                          onPressed: () => viewModel.showPaywall(context),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.lightGreen),
                            elevation: WidgetStateProperty.all<double>(0),
                            shape: WidgetStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          child: const Text('Premium-Features freischalten')),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
