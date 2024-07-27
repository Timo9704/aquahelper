import 'package:aquahelper/model/ai_planner_storage.dart';
import 'package:aquahelper/screens/aifeatures/aiplanner/ai_planner_guide.dart';
import 'package:flutter/material.dart';
import '../../../../util/scalesize.dart';
import 'ai_planner_animals.dart';

class AiPlannerAquarium extends StatefulWidget {
  final AiPlannerStorage aiPlannerObject;

  const AiPlannerAquarium({super.key, required this.aiPlannerObject});


  @override
  State<AiPlannerAquarium> createState() => _AiPlannerAquariumState();
}

class _AiPlannerAquariumState extends State<AiPlannerAquarium> {
  double textScaleFactor = 0;
  final _formKey = GlobalKey<FormState>();
  int? availableSpace;
  int? maxVolume;
  bool? needCabinet;
  int? maxCost;

  @override
  void initState() {
    super.initState();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Anleitung':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AiPlannerGuide()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Planer - Aquarium"),
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
                Text("Fragen zum Aquarium",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.black)),
                const SizedBox(height: 10),
                Text(
                    "Hier kannst du die Ausstattung deines Aquariums planen. Die folgenden Fragen helfen uns dabei, die passenden technischen Geräte für dein Aquarium zu finden. Wir berücksichtigen dabei deine Wünsche und Bedürfnisse, um ein harmonisches Gesamtbild zu schaffen.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black)),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Wie viel Platz steht dir für dein Aquarium zur Verfügung? (in cm)',
                          textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                          ),
                        ),
                        onSaved: (value) {
                          availableSpace = int.tryParse(value ?? '');
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte gib eine Zahl ein';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text('Wie viel Liter soll dein Aquarium maximal fassen? (in Liter)',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                          ),
                        ),
                        onSaved: (value) {
                          maxVolume = int.tryParse(value ?? '');
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte gib eine Zahl ein';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text('Brauchst du einen Unterschrank?',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black)),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Ja'),
                              value: true,
                              activeColor: Colors.lightGreen,
                              groupValue: needCabinet,
                              onChanged: (value) {
                                setState(() {
                                  needCabinet = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Nein'),
                              value: false,
                              activeColor: Colors.lightGreen,
                              groupValue: needCabinet,
                              onChanged: (value) {
                                setState(() {
                                  needCabinet = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Wie viel soll das Aquarium mit Technik maximal kosten? (in Euro)',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                          ),
                        ),
                        onSaved: (value) {
                          maxCost = int.tryParse(value ?? '');
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte gib eine Zahl ein';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                          minimumSize: MaterialStateProperty.all<Size>(const Size(200, 40)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            widget.aiPlannerObject.availableSpace = availableSpace;
                            widget.aiPlannerObject.maxVolume = maxVolume;
                            widget.aiPlannerObject.needCabinet = needCabinet;
                            widget.aiPlannerObject.maxCost = maxCost;

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AiPlannerAnimals(aiPlannerObject: widget.aiPlannerObject)),
                            );
                          }
                        },
                        child: const Text("Weiter zum Besatz"),
                      ),
                      const SizedBox(height: 20),
                      Column(children: [
                        LinearProgressIndicator(
                          value: 0.33,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                        ),
                        const SizedBox(height: 10),
                        Text("Fortschritt: 33%",
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
