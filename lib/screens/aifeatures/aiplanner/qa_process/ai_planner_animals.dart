import 'package:flutter/material.dart';
import '../../../../model/ai_planner_storage.dart';
import '../../../../util/scalesize.dart';
import 'ai_planner_plants.dart';

class AiPlannerAnimals extends StatefulWidget {
  final AiPlannerStorage aiPlannerObject;

  const AiPlannerAnimals({super.key, required this.aiPlannerObject});

  @override
  State<AiPlannerAnimals> createState() => _AiPlannerAnimalsState();
}

class _AiPlannerAnimalsState extends State<AiPlannerAnimals> {
  double textScaleFactor = 0;
  bool? favoritAnimals;
  final _formKey = GlobalKey<FormState>();
  final List<String> favoriteFishList = [];
  final TextEditingController fishController = TextEditingController();
  final Map<String, TextEditingController> waterValues = {
    'pH-Wert': TextEditingController(),
    'GH': TextEditingController(),
    'KH': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Planer - Besatz"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                Text("Fragen zum Besatz",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 30, color: Colors.black)),
                const SizedBox(height: 10),
                Text(
                    "Hier kannst du den Besatz deines Aquariums planen. Die folgenden Fragen helfen uns dabei, die passenden Fische und andere Bewohner für dein Aquarium zu finden. Wir berücksichtigen dabei deine Wünsche und Bedürfnisse, um ein harmonisches Gesamtbild zu schaffen.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 17, color: Colors.black)),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Hast du schon Fische auf deiner Favoritenliste?',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(fontSize: 22, color: Colors.black)),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Ja'),
                              value: true,
                              activeColor: Colors.lightGreen,
                              groupValue: favoritAnimals,
                              onChanged: (value) {
                                setState(() {
                                  favoritAnimals = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Nein'),
                              value: false,
                              activeColor: Colors.lightGreen,
                              groupValue: favoritAnimals,
                              onChanged: (value) {
                                setState(() {
                                  favoritAnimals = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Welche Fische stehen auf deiner Favoritenliste?',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(fontSize: 22, color: Colors.black)),
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
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                favoriteFishList.add(fishController.text);
                                fishController.clear();
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children:
                            favoriteFishList.map((fish) => Text(fish)).toList(),
                      ),
                      const SizedBox(height: 20),
                      Text('Welche Wasserwerte besitzt dein Leitungwasser?',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(fontSize: 22, color: Colors.black)),
                      Table(
                        children: waterValues.keys.map((key) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(key,
                                    style: const TextStyle(fontSize: 22),
                                    textAlign: TextAlign.center),
                              ),
                              TextField(
                                controller: waterValues[key],
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.lightGreen),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      widget.aiPlannerObject.planningMode == 2
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
                                  widget.aiPlannerObject.favoritAnimals =
                                      favoritAnimals;
                                  widget.aiPlannerObject.favoriteFishList =
                                      favoriteFishList.toString();
                                  widget.aiPlannerObject.waterValues =
                                      "ph + ${waterValues['pH-Wert'].toString()}, gh + ${waterValues['GH'].toString()}, kh + ${waterValues['KH'].toString()}";
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
                                  widget.aiPlannerObject.favoritAnimals =
                                      favoritAnimals;
                                  widget.aiPlannerObject.favoriteFishList =
                                      favoriteFishList.toString();
                                  widget.aiPlannerObject.waterValues =
                                      waterValues.toString();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AiPlannerPlants(
                                            aiPlannerObject:
                                                widget.aiPlannerObject)),
                                  );
                                }
                              },
                              child: const Text("Weiter zur Bepflanzung"),
                            ),
                      const SizedBox(height: 20),
                      if (widget.aiPlannerObject.planningMode != 2)
                        Column(children: [
                          LinearProgressIndicator(
                            value: 0.66,
                            backgroundColor: Colors.grey[300],
                            valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                          ),
                          const SizedBox(height: 20),
                          Text("Fortschritt: 66%",
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
