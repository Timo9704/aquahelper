import 'package:aquahelper/views/tools/runin/runin_calender.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/aquarium.dart';
import '../../../util/scalesize.dart';
import '../../../viewmodels/tools/runin/runin_start_viewmodel.dart';

class RunInStart extends StatelessWidget {
  final Aquarium aquarium;

  const RunInStart({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => RunInStartViewModel(aquarium),
      child: Consumer<RunInStartViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
              title: const Text("6-Wochen Einfahrphase"),
              backgroundColor: Colors.lightGreen),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                Text("Lass uns dein Aquarium einfahren!",
                    textScaler: TextScaler.linear(textScaleFactor),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(RunInStartViewModel.startText,
                    textScaler: TextScaler.linear(textScaleFactor),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 20),
                const Image(image: AssetImage('assets/images/runin_intro.png')),
                const SizedBox(height: 20),
                Text("Dein Aquarium ist gerade erst eingerichtet?",
                    textScaler: TextScaler.linear(textScaleFactor),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => {
                    viewModel.setRunInData(),
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RunInCalender(aquarium: viewModel.aquarium),
                      ),
                    ),
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Heute starten",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
