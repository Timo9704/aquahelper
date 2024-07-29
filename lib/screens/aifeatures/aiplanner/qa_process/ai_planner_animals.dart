import 'package:flutter/material.dart';
import '../../../../model/ai_planner_storage.dart';
import '../../../../model/aquarium.dart';
import '../../../../util/datastore.dart';
import '../../../../util/scalesize.dart';
import '../ai_planner_result.dart';
import 'ai_planner_plants.dart';

class AiPlannerAnimals extends StatefulWidget {
  final AiPlannerStorage aiPlannerObject;

  const AiPlannerAnimals({super.key, required this.aiPlannerObject});

  @override
  State<AiPlannerAnimals> createState() => _AiPlannerAnimalsState();
}

class _AiPlannerAnimalsState extends State<AiPlannerAnimals> {
  double textScaleFactor = 0;
  bool _isLoading = false;
  double phValue = 7.0;
  double ghValue = 10.0;
  double khValue = 5.0;
  final _formKey = GlobalKey<FormState>();
  final List<String> favoriteFishList = [];
  final TextEditingController fishController = TextEditingController();
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];

  @override
  void initState() {
    super.initState();
    loadAquariums();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      _aquariumNames = dbAquariums;
      _selectedAquarium = dbAquariums.first;
      widget.aiPlannerObject.aquariumId = _selectedAquarium!.aquariumId;
    });
  }

  Future<void> _executePlanning() async {
    setState(() {
      _isLoading = true;
    });

    widget.aiPlannerObject.executePlanning().then((map) {
      if (mounted && map.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AiPlannerResult(
                  jsonData: map,
                  planningMode: widget.aiPlannerObject.planningMode)),
        );
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Planer - Besatz"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: [
                    Text("Fragen zum Besatz",
                        textScaler: TextScaler.linear(textScaleFactor),
                        style:
                            const TextStyle(fontSize: 30, color: Colors.black)),
                    const SizedBox(height: 10),
                    Text(
                        "Hier kannst du den Besatz deines Aquariums planen. Die folgenden Fragen helfen uns dabei, die passenden Fische und andere Bewohner für dein Aquarium zu finden. Wir berücksichtigen dabei deine Wünsche und Bedürfnisse, um ein harmonisches Gesamtbild zu schaffen.",
                        textScaler: TextScaler.linear(textScaleFactor),
                        style:
                            const TextStyle(fontSize: 17, color: Colors.black)),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (widget.aiPlannerObject.planningMode == 1)
                            Column(children: [
                              Text(
                                  'Für welches Aquarium möchtest du den Besatz planen?',
                                  textScaler:
                                      TextScaler.linear(textScaleFactor),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              DropdownButton<Aquarium>(
                                value: _selectedAquarium,
                                items: _aquariumNames
                                    .map<DropdownMenuItem<Aquarium>>(
                                        (Aquarium value) {
                                  return DropdownMenuItem<Aquarium>(
                                    value: value,
                                    child: Text(value.name,
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.black)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedAquarium = newValue;
                                    widget.aiPlannerObject.aquariumId =
                                        _selectedAquarium!.aquariumId;
                                  });
                                },
                              ),
                            ]),
                          const SizedBox(height: 20),
                          Text(
                              'Welche Fische möchtest du auf jeden Fall pflegen? Füge sie mit dem "+"-Button hinzu.',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black)),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: fishController,
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.lightGreen),
                                    ),
                                    hintText: 'Fischart eingeben',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.lightGreen,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (fishController.text.isNotEmpty) {
                                      favoriteFishList.add(fishController.text);
                                      fishController.clear();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                              'Wenn du keine Favoriten hast, lass das Feld leer.',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black)),
                          const SizedBox(height: 10),
                          Column(
                            children: favoriteFishList
                                .map((fish) => Text(fish))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          Text(
                              'Welche Wasserwerte besitzt dein Leitungwasser ungefähr?',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black)),
                          const SizedBox(height: 10),
                          Slider(
                            value: phValue,
                            min: 4,
                            max: 9,
                            divisions: 50,
                            activeColor: Colors.lightGreen,
                            label: phValue.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                phValue =
                                    double.parse(value.toStringAsFixed(1));
                              });
                            },
                          ),
                          Text('pH-Wert: $phValue',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                          Slider(
                            value: ghValue,
                            min: 0,
                            max: 20,
                            divisions: 20,
                            activeColor: Colors.lightGreen,
                            label: ghValue.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                ghValue = value;
                              });
                            },
                          ),
                          Text('GH-Wert: ${ghValue.round()}',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                          Slider(
                            value: khValue,
                            min: 0,
                            max: 20,
                            divisions: 20,
                            activeColor: Colors.lightGreen,
                            label: khValue.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                khValue =
                                    double.parse(value.toStringAsFixed(1));
                              });
                            },
                          ),
                          Text('KH-Wert: ${khValue.round()}',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black87,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          strokeWidth: 15,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                        ),
                      ),
                      SizedBox(height: 20), // Abstände hinzufügen
                      Text(
                        "Einen Moment Geduld, bitte!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Dein Aquarium wird gerade geplant.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Dieser Vorgang kann einige Zeit\nin Anspruch nehmen.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _isLoading
          ? null
          : BottomAppBar(
              height: 120,
              child: Column(
                children: [
                  widget.aiPlannerObject.planningMode == 1
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightGreen),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(200, 40)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              _formKey.currentState?.save();
                              widget.aiPlannerObject.favoriteFishList =
                                  favoriteFishList.toString();
                              widget.aiPlannerObject.waterValues =
                                  "pH-Wert: $phValue, GH-Wert: $ghValue, KH-Wert: $khValue";
                              await _executePlanning();
                            }
                          },
                          child: const Text("Planung abschließen"),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightGreen),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(200, 40)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              _formKey.currentState?.save();
                              widget.aiPlannerObject.favoriteFishList =
                                  favoriteFishList.toString();
                              widget.aiPlannerObject.waterValues =
                                  "pH-Wert: $phValue, GH-Wert: $ghValue, KH-Wert: $khValue";
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AiPlannerPlants(
                                          aiPlannerObject:
                                              widget.aiPlannerObject)));
                            }
                          },
                          child: const Text("Weiter zur Bepflanzung"),
                        ),
                  const SizedBox(height: 10),
                  if (widget.aiPlannerObject.planningMode != 1)
                    Column(
                      children: [
                        LinearProgressIndicator(
                          value: 0.66,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.lightGreen),
                        ),
                        const SizedBox(height: 10),
                        Text("Fortschritt: 66%",
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black)),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
