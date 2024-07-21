import 'package:aquahelper/model/ai_planner_storage.dart';
import 'package:aquahelper/screens/aifeatures/aiplanner/ai_planner_guide.dart';
import 'package:aquahelper/screens/aifeatures/aiplanner/qa_process/ai_planner_animals.dart';
import 'package:aquahelper/screens/aifeatures/aiplanner/qa_process/ai_planner_aquarium.dart';
import 'package:aquahelper/screens/aifeatures/aiplanner/qa_process/ai_planner_plants.dart';
import 'package:flutter/material.dart';

import '../../../util/scalesize.dart';

class AiPlanner extends StatefulWidget {
  const AiPlanner({super.key});

  @override
  State<AiPlanner> createState() => _AiPlannerState();
}

class _AiPlannerState extends State<AiPlanner> {
  double textScaleFactor = 0;
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
        title: const Text("KI-Assistent"),
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
                const Text("KI-Planer",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                Text(
                    "Willkommen zum Beratungsprozess deines KI-Planers! Mit dem KI-Planer hast du die Möglichkeit ein ganz neues Aquarium zu planen. Falls du schon ein eingerichtetes Aquarium hast, brauchst du keine Sorge zu haben, denn du kannst auch nur einzelne Bereiche planen. Der KI-Planer wird dich durch den gesamten Prozess führen und dir dabei helfen, die besten Entscheidungen für dein Aquarium zu treffen.\nAm Ende erhältst du eine Liste mit allen Produkten, Pflanzen und Tieren, die du für dein Aquarium benötigst.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black)),
                const SizedBox(
                  height: 20,
                ),
                Text("Wie möchtest du beginnen?",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.black)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    AiPlannerStorage aiPlannerObj = AiPlannerStorage();
                    aiPlannerObj.planningMode = 0;
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AiPlannerAquarium(aiPlannerObject: aiPlannerObj)));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(300, 70)),
                  ),
                    child: Text(
                      "Gesamtes Aquarium planen",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black)),
                    ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    AiPlannerStorage aiPlannerObj = AiPlannerStorage();
                    aiPlannerObj.planningMode = 1;
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AiPlannerPlants(aiPlannerObject: aiPlannerObj)));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightGreen),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(300, 70)),
                  ),
                  child: Text(
                      "Bepflanzung planen",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    AiPlannerStorage aiPlannerObj = AiPlannerStorage();
                    aiPlannerObj.planningMode = 2;
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AiPlannerAnimals(aiPlannerObject: aiPlannerObj)));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightGreen),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(300, 70)),
                  ),
                  child: Text(
                      "Besatz planen",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
