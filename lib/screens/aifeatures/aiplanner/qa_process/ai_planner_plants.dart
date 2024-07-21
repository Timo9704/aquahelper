import 'package:aquahelper/screens/aifeatures/aiplanner/ai_planner_guide.dart';
import 'package:flutter/material.dart';
import '../../../../model/ai_planner_storage.dart';
import '../../../../util/scalesize.dart';
import 'ai_planner_animals.dart';

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

  @override
  void initState() {
    super.initState();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Anleitung':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AiPlannerGuide()));
        break;
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                Text("Fragen zur Bepflanzung",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 30, color: Colors.black)),
                const SizedBox(height: 10),
                Text(
                    "Hier kannst du die Bepflanzung deines Aquariums planen. Die folgenden Fragen helfen uns dabei, die passenden Pflanzen für dein Aquarium zu finden. Wir berücksichtigen dabei deine Wünsche und Bedürfnisse, um ein harmonisches Gesamtbild zu schaffen.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 17, color: Colors.black)),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      const SizedBox(height: 20),
                      widget.aiPlannerObject.planningMode == 1
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightGreen),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(200, 40)),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _formKey.currentState?.save();
                                  widget.aiPlannerObject.useForegroundPlants =
                                      useForegroundPlants;
                                  widget.aiPlannerObject.plantingIntensity =
                                      plantingIntensity.toInt();
                                  widget.aiPlannerObject.maintenanceEffort =
                                      maintenanceEffort.toInt();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AiPlannerPlants(
                                            aiPlannerObject:
                                                widget.aiPlannerObject)),
                                  );
                                }
                              },
                              child: const Text("Planung abschließen"),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightGreen),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(200, 40)),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _formKey.currentState?.save();
                                  widget.aiPlannerObject.useForegroundPlants =
                                      useForegroundPlants;
                                  widget.aiPlannerObject.plantingIntensity =
                                      plantingIntensity.toInt();
                                  widget.aiPlannerObject.maintenanceEffort =
                                      maintenanceEffort.toInt();
                                  widget.aiPlannerObject.executePlanning();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AiPlannerAnimals(
                                            aiPlannerObject:
                                                widget.aiPlannerObject)),
                                  );
                                }
                              },
                              child: const Text("Weiter zur Bepflanzung"),
                            ),
                      const SizedBox(height: 20),
                      if (widget.aiPlannerObject.planningMode != 1)
                        Column(children: [
                          LinearProgressIndicator(
                            value: 0.66,
                            backgroundColor: Colors.grey[300],
                            valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                          ),
                          const SizedBox(height: 10),
                          Text("Fortschritt: 99%",
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(fontSize: 20, color: Colors.black)),
                        ],)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
