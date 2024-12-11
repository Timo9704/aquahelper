import 'package:aquahelper/views/tools/runin/runin_start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/aquarium.dart';
import '../../../util/scalesize.dart';
import '../../../viewmodels/tools/runin/runin_intro_viewmodel.dart';

class RunInIntro extends StatelessWidget {
  const RunInIntro({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => RunInIntroViewModel(),
      child: Consumer<RunInIntroViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
              title: const Text("6-Wochen Einfahrphase"),
              backgroundColor: Colors.lightGreen),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                const SizedBox(height: 10),
                const Image(image: AssetImage('assets/images/runin_intro.png')),
                const SizedBox(height: 20),
                Text("Einführung:",
                    textScaler: TextScaler.linear(textScaleFactor),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(viewModel.introText,
                    textScaler: TextScaler.linear(textScaleFactor),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 30),
                Column(children: [
                  Text('Welches Aquarium möchtest du einfahren?',
                      textScaler: TextScaler.linear(textScaleFactor),
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                  DropdownButton<Aquarium>(
                    value: viewModel.aquarium,
                    items: viewModel.aquariumNames
                        .map<DropdownMenuItem<Aquarium>>((Aquarium value) {
                      return DropdownMenuItem<Aquarium>(
                        value: value,
                        child: Text(value.name,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      viewModel.setAquarium(newValue!);
                    },
                  ),
                ]),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => {
                          if (!viewModel.isPremiumUser)
                            viewModel.showPaywall(context)
                          else
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RunInStart(aquarium: viewModel.aquarium)),
                            )
                        },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: viewModel.isPremiumUser
                            ? Colors.lightGreen
                            : Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Starte die Einlaufphase jetzt!",
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(fontSize: 16)),
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
