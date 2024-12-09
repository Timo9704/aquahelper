import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/viewmodels/tools/light_calculator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/scalesize.dart';

class LightCalculator extends StatelessWidget {
  const LightCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => LightCalculatorViewModel(),
      child: Consumer<LightCalculatorViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Licht-Rechner"),
            backgroundColor: Colors.lightGreen,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("Berechne die Lichtmenge deines Aquariums:",
                      textScaler: TextScaler.linear(textScaleFactor),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
              ExpansionTile(
                title: Text(
                    '1. Aquarium auswählen oder Volumen angeben',
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                    ),
                ),
                children: <Widget>[
                  DropdownButton<Aquarium>(
                    value: viewModel.selectedAquarium,
                    hint: const Text('Wähle dein Aquarium',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.normal)),
                    onChanged: (newValue) {
                      viewModel.setSelectedAquarium(newValue);
                    },
                    items: viewModel.aquariumNames
                        .map<DropdownMenuItem<Aquarium>>((Aquarium value) {
                      return DropdownMenuItem<Aquarium>(
                        value: value,
                        child: Text(value.name,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  const Text("oder",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      )),
                  const SizedBox(height: 10),
                  ListTile(
                    title: TextField(
                      controller: viewModel.aquariumLiterController,
                      decoration: const InputDecoration(
                        labelText: 'Aquarium-Volumen (in Liter)',
                        border: OutlineInputBorder(

                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ],),
                  ExpansionTile(
                    title: Text(
                      '2. Lumen eingeben',
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                    children: <Widget>[
                      Text(
                          "Der Lichtstrom (in Lumen/lm) gibt die Lichtmenge an, die von einer Lichtquelle in alle Richtungen abgestrahlt wird.",
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.justify),
                      ListTile(
                        title: TextField(
                          controller: viewModel.lumenController,
                          decoration: const InputDecoration(
                            labelText: 'Lumen eingeben',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ), 
                  if (viewModel.lumenPerLiter > 0) ...[
                    const SizedBox(height: 20),
                    Text(
                        "Die Lichtmenge beträgt ${viewModel.lumenPerLiter.round()} Lumen pro Liter.",
                        textScaler: TextScaler.linear(textScaleFactor),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 10),
                    Text(viewModel.getDetailsText(),
                        textScaler: TextScaler.linear(textScaleFactor),
                        maxLines: 3,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.justify),
                    const SizedBox(height: 20),
                    viewModel.getLumenIndicator(viewModel.lumenPerLiter),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                viewModel.isPremiumUser
                                    ? Colors.lightGreen
                                    : Colors.grey)),
                        onPressed: () => viewModel.calculateLumenPerLiter(context),
                        child: const Text("Berechnen")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
