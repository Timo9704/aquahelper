import 'package:aquahelper/model/aquarium.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../ad_helper.dart';
import '../../../model/animals.dart';
import '../../../util/datastore.dart';
import '../../../util/premium.dart';
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
  Premium premium = Premium();
  bool _isPremium = false;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    loadAnimals();
    _bannerAd = createBannerAd();
  }

  BannerAd? createBannerAd(){
    return BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: AdHelper.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  void loadAnimals() async {
    _isPremium = await premium.isUserPremium();
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
          const SizedBox(height: 5),
          if(!_isPremium)
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              width: MediaQuery.of(context).size.width, // Nimmt die volle Breite des Bildschirms
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
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
                                                CreateOrEditAnimals(
                                                    aquarium: widget.aquarium,
                                                    animal: animal)),
                                      ).then((value) => loadAnimals());
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
                                                CreateOrEditAnimals(
                                                    aquarium: widget.aquarium,
                                                    animal: animal)),
                                      ).then((value) => loadAnimals());
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
