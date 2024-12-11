import 'package:aquahelper/model/animals.dart';
import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_animals_overview_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forms/create_or_edit_animal.dart';

class AquariumAnimalsOverview extends StatelessWidget {
  final Aquarium aquarium;

  const AquariumAnimalsOverview({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    var viewModel =
        Provider.of<AquariumAnimalsOverviewViewModel>(context, listen: false);
    if (viewModel.aquarium != aquarium) {
      viewModel.initAnimalsOverview(aquarium);
    }

    return Consumer<AquariumAnimalsOverviewViewModel>(
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
      ),
    );
  }

  Widget buildSection(String title, List<Animals> animals, BuildContext context,
      AquariumAnimalsOverviewViewModel viewModel) {
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
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      icon: const Icon(Icons.add, color: Colors.lightGreen),
                      onPressed: () => viewModel.onPressedAdd(context, title)),
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
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'lat. Name',
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Anzahl',
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                        ),
                      ],
                      rows: animals
                          .map((animal) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Text(
                                      animal.name,
                                      textScaler:
                                          TextScaler.linear(textScaleFactor),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateOrEditAnimal(
                                                  aquarium: viewModel.aquarium!,
                                                  animal: animal),
                                        ),
                                      );
                                    },
                                  ),
                                  DataCell(
                                    Text(
                                      animal.latName,
                                      textScaler:
                                          TextScaler.linear(textScaleFactor),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateOrEditAnimal(
                                                    aquarium:
                                                        viewModel.aquarium!,
                                                    animal: animal)),
                                      );
                                    },
                                  ),
                                  DataCell(
                                    Text(
                                      animal.amount.toString(),
                                      textScaler:
                                          TextScaler.linear(textScaleFactor),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateOrEditAnimal(
                                                    aquarium:
                                                        viewModel.aquarium!,
                                                    animal: animal)),
                                      );
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
