import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/viewmodels/tools/light_calculator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LightCalculator extends StatelessWidget {
  const LightCalculator({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const Text("Berechne die Lichtmenge deines Aquariums:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  const Text("1. Aquarium auswählen oder Volumen angeben:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      )),
                  const SizedBox(height: 10),
                  DropdownButton<Aquarium>(
                    value: viewModel.selectedAquarium,
                    hint: const Text('Wähle dein Aquarium',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.normal)),
                    onChanged: (newValue) {
                      viewModel.selectedAquarium = newValue;
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
                  Container(
                    width: MediaQuery.sizeOf(context).width - 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Aquarium-Volumen (in Liter)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            )),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          controller: viewModel.aquariumLiterController,
                          style: const TextStyle(fontSize: 20),
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            fillColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("2. Lumen oder Lampe angeben:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      )),
                  const SizedBox(height: 10),
                  ExpansionTile(
                    title: const Text('Lichtstrom (Lumen/lm)'),
                    initiallyExpanded: true,
                    children: <Widget>[
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
                        "Die Lichtmenge beträgt ${viewModel.lumenPerLiter.round()} Lumen pro Liter."),
                    const SizedBox(height: 10),
                    Text(viewModel.getDetailsText(),
                        maxLines: 3,
                        style: const TextStyle(fontSize: 15),
                        textAlign: TextAlign.justify),
                    const SizedBox(height: 20),
                    viewModel.getLumenIndicator(viewModel.lumenPerLiter),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                viewModel.isPremiumUser
                                    ? Colors.lightGreen
                                    : Colors.grey)),
                        onPressed: () => viewModel.calculateLumenPerLiter,
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
