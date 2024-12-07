import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/viewmodels/tools/ground_calculator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroundCalculatorIsland extends StatelessWidget {
  const GroundCalculatorIsland({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroundCalculatorViewModel>(
      builder: (context, viewModel, child) => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/images/island.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  children: [
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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width / 2 - 25,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Aquarium Länge (in cm)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  )),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                controller: viewModel.aquariumHeightController,
                                style: const TextStyle(fontSize: 17),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(3),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  fillColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width / 2 - 25,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Aquarium Tiefe (in cm)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  )),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                controller: viewModel.aquariumDepthController,
                                style: const TextStyle(fontSize: 20),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(3),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  fillColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width / 2 - 25,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Insel-Breite (in cm)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  )),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                controller: viewModel.islandWidthController,
                                style: const TextStyle(fontSize: 20),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(3),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  fillColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width / 2 - 25,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Insel-Höhe (in cm)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  )),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                controller: viewModel.islandHeightController,
                                style: const TextStyle(fontSize: 20),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(3),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  fillColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width / 2 - 25,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Höhe vorn/seitlich (in cm)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  )),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                controller: viewModel.groundHeightController,
                                style: const TextStyle(fontSize: 20),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(3),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  fillColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Wähle deine Bodengrund-Art:',
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                    DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: viewModel.selectedGround,
                      onChanged: (newValue) {
                        viewModel.setSelectedGround(newValue!);
                      },
                      items: viewModel.groundNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width - 80,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Du benötigst ungefähr: ${viewModel.resultIsland}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    viewModel.isPremiumUser ?
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.lightGreen)),
                          onPressed: () => {viewModel.calculateGroundIsland(context)},
                          child: const Text("Berechnen")),
                    ) :
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey)),
                          onPressed: () => {viewModel.calculateGroundIsland(context)},
                          child: const Text("Berechnen")),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
