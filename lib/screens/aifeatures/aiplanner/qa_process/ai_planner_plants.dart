import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../model/aquarium.dart';
import '../../../../util/datastore.dart';
import '../ai_planner_guide.dart';
import '../ai_planner_result.dart';
import '../../../../model/ai_planner_storage.dart';
import '../../../../util/scalesize.dart';

class AiPlannerPlants extends StatefulWidget {
  final AiPlannerStorage aiPlannerObject;

  const AiPlannerPlants({super.key, required this.aiPlannerObject});

  @override
  State<AiPlannerPlants> createState() => _AiPlannerPlantsState();
}

class _AiPlannerPlantsState extends State<AiPlannerPlants> {
  double textScaleFactor = 0;
  final _formKey = GlobalKey<FormState>();
  bool? useForegroundPlants = true;
  double plantingIntensity = 3;
  double maintenanceEffort = 3;
  bool _isLoading = false;
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];

  @override
  void initState() {
    super.initState();
    loadAquariums();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Anleitung':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AiPlannerGuide()));
        break;
    }
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

    try {
      Map<String, dynamic> map = await widget.aiPlannerObject.executePlanning();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AiPlannerResult(jsonData: map, planningMode: widget.aiPlannerObject.planningMode)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Planer - Bepflanzung"),
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Anleitung'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: [
                    Text("Fragen zur Bepflanzung",
                        textScaler: TextScaler.linear(textScaleFactor),
                        style:
                            const TextStyle(fontSize: 30, color: Colors.black)),
                    const SizedBox(height: 10),
                    Text(
                        "Hier kannst du die Bepflanzung deines Aquariums planen. Die folgenden Fragen helfen uns dabei, die passenden Pflanzen für dein Aquarium zu finden. Wir berücksichtigen dabei deine Wünsche und Bedürfnisse, um ein harmonisches Gesamtbild zu schaffen.",
                        textScaler: TextScaler.linear(textScaleFactor),
                        style:
                            const TextStyle(fontSize: 17, color: Colors.black)),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (widget.aiPlannerObject.planningMode == 2)
                            Column(children: [
                              Text(
                                  'Für welches Aquarium möchtest du die Bepflanzung planen?',
                                  textScaler:
                                      TextScaler.linear(textScaleFactor),
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.black)),
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
                                    widget.aiPlannerObject.aquariumId = _selectedAquarium!.aquariumId;
                                  });
                                },
                              ),
                            ]),
                          Text(
                              'Soll dein Aquarium auch mit Bodendeckern/Rasen bepflanzt werden?',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.black)),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text('Ja'),
                                  value: true,
                                  activeColor: Colors.lightGreen,
                                  groupValue: useForegroundPlants,
                                  onChanged: (value) {
                                    setState(() {
                                      useForegroundPlants = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text('Nein'),
                                  value: false,
                                  activeColor: Colors.lightGreen,
                                  groupValue: useForegroundPlants,
                                  onChanged: (value) {
                                    setState(() {
                                      useForegroundPlants = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text('Wie stark soll dein Aquarium bepflanzt werden?',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.black)),
                          Slider(
                            value: plantingIntensity,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            activeColor: Colors.lightGreen,
                            label: plantingIntensity.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                plantingIntensity = value;
                              });
                            },
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('sehr wenig'),
                              Text('sehr stark'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text('Wie hoch darf der Pflegeaufwand maximal sein?',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.black)),
                          Slider(
                            value: maintenanceEffort,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            activeColor: Colors.lightGreen,
                            label: maintenanceEffort.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                maintenanceEffort = value;
                              });
                            },
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('sehr gering'),
                              Text('sehr hoch'),
                            ],
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.lightGreen),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            const Size(200, 40)),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      _formKey.currentState?.save();
                                      widget.aiPlannerObject
                                              .useForegroundPlants =
                                          useForegroundPlants;
                                      widget.aiPlannerObject.plantingIntensity =
                                          plantingIntensity.toInt();
                                      widget.aiPlannerObject.maintenanceEffort =
                                          maintenanceEffort.toInt();
                                      await _executePlanning();
                                    }
                                  },
                                  child: const Text("Planung abschließen"),
                                ),
                          const SizedBox(height: 40),
                          if (widget.aiPlannerObject.planningMode != 2)
                            Column(
                              children: [
                                LinearProgressIndicator(
                                  value: 0.99,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.lightGreen),
                                ),
                                const SizedBox(height: 10),
                                Text("Fortschritt: 99%",
                                    textScaler:
                                        TextScaler.linear(textScaleFactor),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black)),
                              ],
                            )
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
    );
  }
}