import 'package:aquahelper/model/aquarium.dart';
import 'package:flutter/material.dart';

import '../../../model/animals.dart';
import '../../../util/datastore.dart';
import '../../../util/scalesize.dart';
import 'create_or_edit_animals.dart';

class AnimalsList extends StatefulWidget {
  final Aquarium aquarium;

  const AnimalsList({super.key, required this.aquarium});

  final String title = 'AquaHelper';

  @override
  State<AnimalsList> createState() => _AnimalsListState();
}

class _AnimalsListState extends State<AnimalsList> {
  double textScaleFactor = 0;
  List<Animals> fishes = [];
  List<Animals> shrimps = [];
  List<Animals> snails = [];

  @override
  void initState() {
    super.initState();
    loadAnimals();
  }

  void loadAnimals() async {
    List<Animals> loadedAnimals =
        await Datastore.db.getAnimalsByAquarium(widget.aquarium);
    setState(() {
      fishes =
          loadedAnimals.where((animal) => animal.type == 'Fische').toList();
      shrimps =
          loadedAnimals.where((animal) => animal.type == 'Garnelen').toList();
      snails =
          loadedAnimals.where((animal) => animal.type == 'Schnecken').toList();
    });
  }

  onPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CreateOrEditAnimals(aquarium: widget.aquarium, animal: null)),
    ).then((value) => loadAnimals());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildSection('Fische', fishes),
          const SizedBox(height: 5),
          buildSection('Garnelen', shrimps),
          const SizedBox(height: 5),
          buildSection('Schnecken', snails),
        ],
      ),
    );
  }

  Widget buildSection(String title, List<Animals> animals) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.lightGreen),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateOrEditAnimals(aquarium: widget.aquarium)),
                      ).then((value) => loadAnimals());
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
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'lat. Name',
                            textScaler:
                            TextScaler.linear(textScaleFactor),
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Anzahl',
                            textScaler:
                            TextScaler.linear(textScaleFactor),
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: animals
                          .map((animal) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Text(animal.name),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateOrEditAnimals(
                                                    aquarium: widget.aquarium,
                                                    animal: animal)),
                                      ).then((value) => loadAnimals());
                                    },
                                  ),
                                  DataCell(
                                    Text(animal.latName),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateOrEditAnimals(
                                                    aquarium: widget.aquarium,
                                                    animal: animal)),
                                      ).then((value) => loadAnimals());
                                    },
                                  ),
                                  DataCell(
                                    Text(animal.amount.toString()),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateOrEditAnimals(
                                                    aquarium: widget.aquarium,
                                                    animal: animal)),
                                      ).then((value) => loadAnimals());
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
