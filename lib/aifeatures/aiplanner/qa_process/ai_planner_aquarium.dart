import 'package:aquahelper/model/ai_planner_storage.dart';
import 'package:flutter/material.dart';
import '../../../util/scalesize.dart';
import '../../aioptimizer/ai_optimizer_guide.dart';
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
  double availableSpace = 100;
  double maxVolume = 100;
  double minVolume = 50;
  bool needCabinet = false;
  bool isSet = true;
  double maxCost = 300;

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
                    "Hier kannst du die Eingenschaften des Aquariums planen. Die folgenden Fragen helfen uns dabei, das passende Aquarium für deine Anforderungen zu finden. Wir berücksichtigen dabei deine Bedürfnisse, um ein harmonisches Gesamtbild zu schaffen.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black)),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Wie viel Platz steht dir für dein Aquarium zur Verfügung?',
                          textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black)),
                      Slider(
                        value: availableSpace,
                        min: 10,
                        max: 250,
                        divisions: 24,
                        activeColor: Colors.lightGreen,
                        label: availableSpace.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            availableSpace = value;
                          });
                        },
                      ),
                      Text('maximale Kantenlänge: ${availableSpace.round()} cm',
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black)),
                      const SizedBox(height: 20),
                      Text('Wie viel Liter soll dein Aquarium minimal fassen?',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black)),
                      Slider(
                        value: minVolume,
                        min: 10,
                        max: 500,
                        divisions: 49,
                        activeColor: Colors.lightGreen,
                        label: minVolume.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            minVolume = value;
                          });
                        },
                      ),
                      Text('minimale Literanzahl: ${minVolume.round()} Liter',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black)),
                      const SizedBox(height: 20),
                      Text('Wie viel Liter soll dein Aquarium maximal fassen?',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black)),
                      Slider(
                        value: maxVolume,
                        min: 10,
                        max: 500,
                        divisions: 49,
                        activeColor: Colors.lightGreen,
                        label: maxVolume.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            maxVolume = value;
                          });
                        },
                      ),
                      Text('maximale Literanzahl: ${maxVolume.round()} Liter',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black)),
                      const SizedBox(height: 20),
                      Text('Wie viel soll das Aquarium maximal kosten?',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black)),
                      Slider(
                        value: maxCost,
                        min: 100,
                        max: 1000,
                        divisions: 9,
                        activeColor: Colors.lightGreen,
                        label: '${maxCost.round()} €',
                        onChanged: (value) {
                          setState(() {
                            maxCost = value;
                          });
                        },
                      ),
                      Text('maximaler Preis: ${maxCost.round()} Euro',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black)),
                  const SizedBox(height: 20),
                  Text('Soll das Aquarium ein Set-Aquarium sein?',
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('als Set'),
                          value: true,
                          activeColor: Colors.lightGreen,
                          groupValue: isSet,
                          onChanged: (value) {
                            setState(() {
                              isSet = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Einzeln'),
                          value: false,
                          activeColor: Colors.lightGreen,
                          groupValue: isSet,
                          onChanged: (value) {
                            setState(() {
                              isSet = value!;
                            });
                          },
                        ),
                      ),
                    ]),
                      const SizedBox(height: 20),
                      Text('Brauchst du einen Unterschrank?',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Ja'),
                              value: true,
                              activeColor: Colors.lightGreen,
                              groupValue: needCabinet,
                              onChanged: (value) {
                                setState(() {
                                  needCabinet = value!;
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
                                  needCabinet = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          height: 120,
          child: Column(children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                minimumSize: MaterialStateProperty.all<Size>(const Size(200, 40)),
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  widget.aiPlannerObject.availableSpace = availableSpace.toInt();
                  widget.aiPlannerObject.minVolume = minVolume.toInt();
                  widget.aiPlannerObject.maxVolume = maxVolume.toInt();
                  widget.aiPlannerObject.isSet = isSet;
                  widget.aiPlannerObject.needCabinet = needCabinet;
                  widget.aiPlannerObject.maxCost = maxCost.toInt();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AiPlannerAnimals(aiPlannerObject: widget.aiPlannerObject)),
                  );
                }
              },
              child: const Text("Weiter zum Besatz"),
            ),
            const SizedBox(height: 10),
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
        ),

    );
  }
}
