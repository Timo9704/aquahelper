import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/viewmodels/tools/osmosis_calculator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OsmosisLiterTab extends StatelessWidget {
  const OsmosisLiterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OsmosisCalculatorViewModel>(
      builder: (context, viewModel, child) => SingleChildScrollView(
        child: Form(
          key: viewModel.formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                    "Berechne das Verhältnis von Leitungs- zu Osmosewasser:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("GH/KH/LW-Leitungswasser",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                )),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              controller: viewModel.tapWaterController,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Feld darf nicht leer sein';
                                }
                                if (double.tryParse(
                                        value.replaceAll(RegExp(r','), '.')) ==
                                    null) {
                                  return 'Bitte Zahl eingeben';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("GH/KH/LW-Osmosewasser",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                )),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              controller: viewModel.osmosisController,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Feld darf nicht leer sein';
                                }
                                if (double.tryParse(
                                        value.replaceAll(RegExp(r','), '.')) ==
                                    null) {
                                  return 'Bitte Zahl eingeben';
                                }
                                if (double.parse(
                                        value.replaceAll(RegExp(r','), '.')) >=
                                    double.parse(viewModel
                                        .tapWaterController.text
                                        .replaceAll(RegExp(r','), '.'))) {
                                  return 'Größer als Leitungswasser';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("GH/KH/LW-Zielwert",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          )),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        controller: viewModel.targetValueController,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          fillColor: Colors.grey,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Feld darf nicht leer sein';
                          }
                          if (double.tryParse(
                                  value.replaceAll(RegExp(r','), '.')) ==
                              null) {
                            return 'Bitte Zahl eingeben';
                          }
                          if (double.parse(
                                  value.replaceAll(RegExp(r','), '.')) >=
                              double.parse(viewModel.tapWaterController.text
                                  .replaceAll(RegExp(r','), '.'))) {
                            return 'Größer als Leitungswasser';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton<Aquarium>(
                  value: viewModel.selectedAquarium,
                  hint: const Text('Wähle dein Aquarium',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  onChanged: (newValue) {
                    viewModel.setSelectedAquarium(newValue!);
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
                      const Text("zu mischendes Volumen in Liter:",
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
                Column(
                  children: [
                    const Text("Ergebnis:",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 20),
                    SizedBox(height: 100, child: viewModel.getLumenIndicator()),
                  ],
                ),
                const SizedBox(height: 20),
                viewModel.isPremiumUser
                    ? SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(
                                        Colors.lightGreen)),
                            onPressed: () =>
                                viewModel.calculateOsmosisRatio(context),
                            child: const Text("Berechnen")),
                      )
                    : SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.grey)),
                          onPressed: () => viewModel.calculateOsmosisRatio(context),
                          child: const Text("Berechnen"),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
