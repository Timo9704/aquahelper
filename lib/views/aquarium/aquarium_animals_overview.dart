import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../model/animals.dart';
import '../../../util/scalesize.dart';
import '../../model/aquarium.dart';
import '../../viewmodels/aquarium/aquarium_animals_overview_viewmodel.dart';
import 'forms/create_or_edit_animal.dart';


class AquariumAnimalsOverview extends StatelessWidget {
  final Aquarium aquarium;

  const AquariumAnimalsOverview({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AquariumAnimalsOverviewViewModel(aquarium),
        child: Consumer<AquariumAnimalsOverviewViewModel>(
        builder: (context, viewModel, child) => Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildSection('Fische', viewModel.fishes, context, viewModel),
          const SizedBox(height: 5),
          buildSection('Garnelen', viewModel.shrimps, context, viewModel),
          const SizedBox(height: 5),
          buildSection('Schnecken', viewModel.snails, context, viewModel),
          const SizedBox(height: 5),
        ],
      ),
    ),),);
  }

  Widget buildSection(String title, List<Animals> animals, BuildContext context, AquariumAnimalsOverviewViewModel viewModel) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return Flexible(
      fit: FlexFit.tight,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    textScaler:
                    TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.lightGreen),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateOrEditAnimal(aquarium: viewModel.aquarium)),
                      ).then((value) => viewModel.loadAnimals());
                    },
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints:
                    const BoxConstraints(minWidth: double.infinity),
                    child: DataTable(
                      headingRowHeight: 25,
                      columnSpacing: 10,
                      dataTextStyle: const TextStyle(fontSize: 10),
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Art',
                            textScaler:
                            TextScaler.linear(textScaleFactor),
                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'lat. Name',
                            textScaler:
                            TextScaler.linear(textScaleFactor),
                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Anzahl',
                            textScaler:
                            TextScaler.linear(textScaleFactor),
                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                          ),
                        ),
                      ],
                      rows: animals
                          .map((animal) => DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(animal.name,
                              textScaler:
                              TextScaler.linear(textScaleFactor),
                              style: const TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateOrEditAnimal(
                                            aquarium: viewModel.aquarium,
                                            animal: animal)),
                              ).then((value) => viewModel.loadAnimals());
                            },
                          ),
                          DataCell(
                            Text(animal.latName,
                              textScaler:
                              TextScaler.linear(textScaleFactor),
                              style: const TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateOrEditAnimal(
                                            aquarium: viewModel.aquarium,
                                            animal: animal)),
                              ).then((value) => viewModel.loadAnimals());
                            },
                          ),
                          DataCell(
                            Text(animal.amount.toString(),
                              textScaler:
                              TextScaler.linear(textScaleFactor),
                              style: const TextStyle(fontSize: 16),),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateOrEditAnimal(
                                            aquarium: viewModel.aquarium,
                                            animal: animal)),
                              ).then((value) => viewModel.loadAnimals());
                            },
                          ),
                        ],
                      ))
                          .toList(),
                    ),
                  ),

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
