import 'package:flutter/material.dart';
import '../../../../model/ai_optimizer_storage.dart';
import '../../../../util/scalesize.dart';
import '../ai_optimizer_result.dart';

class AiOptimizerPlants extends StatefulWidget {
  final AiOptimizerStorage aiOptimizerObject;

  const AiOptimizerPlants({super.key, required this.aiOptimizerObject});

  @override
  State<AiOptimizerPlants> createState() => _AiOptimizerPlantsState();
}

class _AiOptimizerPlantsState extends State<AiOptimizerPlants> {
  double textScaleFactor = 0;
  TextEditingController problemDescriptionController = TextEditingController();
  bool _isLoading = false;
  bool plantGrowthProblem = false;
  bool plantDeficiencySymptom = false;
  Set<String> selectedTags = <String>{};
  final _formKey = GlobalKey<FormState>();
  List<String> tags = [
    'löchrige Blätter',
    'verkümmerte Triebe',
    'gelbe Blätter',
    'weißliche Blätter/Triebe',
    'gammelige Blätter'
  ];

  @override
  void initState() {
    super.initState();
  }

  void executeOptimizer() async {
    var jsonData = await widget.aiOptimizerObject.executeOptimizer();
    if (jsonData.isNotEmpty && mounted) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AiOptimizerResult(
            jsonData: jsonData,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Optimierer"),
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
                    Text("Fragen zur Bepflanzung",
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
                          Text(
                              'Wie würdest du das Wachstum deiner Pflanzen beurteilen?',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text('Gut'),
                                  value: true,
                                  activeColor: Colors.lightGreen,
                                  groupValue: plantGrowthProblem,
                                  onChanged: (value) {
                                    setState(() {
                                      plantGrowthProblem = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text('Nicht gut'),
                                  value: false,
                                  activeColor: Colors.lightGreen,
                                  groupValue: plantGrowthProblem,
                                  onChanged: (value) {
                                    setState(() {
                                      plantGrowthProblem = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                              'Zeigen deine Pflanzen Mangelerscheinungen (wie z.B. weiße/verkümmerte Triebe, gelbe/löchrige Blätter)?',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text('Ja'),
                                  value: true,
                                  activeColor: Colors.lightGreen,
                                  groupValue: plantDeficiencySymptom,
                                  onChanged: (value) {
                                    setState(() {
                                      plantDeficiencySymptom = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text('Nein'),
                                  value: false,
                                  activeColor: Colors.lightGreen,
                                  groupValue: plantDeficiencySymptom,
                                  onChanged: (value) {
                                    setState(() {
                                      plantDeficiencySymptom = value!;
                                      selectedTags.clear();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (plantDeficiencySymptom == true)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    "Welche Mangelerscheinungen besitzen deine Pflanzen?",
                                    textScaler:
                                        TextScaler.linear(textScaleFactor),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black)),
                                const SizedBox(height: 5),
                                Wrap(
                                  spacing: 5.0,
                                  alignment: WrapAlignment.center,
                                  children: tags
                                      .map((tag) => FilterChip(
                                            labelPadding:
                                                const EdgeInsets.all(5),
                                            label: Text(tag,
                                                textScaler: TextScaler.linear(
                                                    textScaleFactor),
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                            selected:
                                                selectedTags.contains(tag),
                                            backgroundColor: Colors.white,
                                            selectedColor: Colors.lightGreen,
                                            checkmarkColor: Colors.white,
                                            showCheckmark: false,
                                            onSelected: (selected) {
                                              setState(() {
                                                selected
                                                    ? selectedTags.add(tag)
                                                    : selectedTags.remove(tag);
                                              });
                                            },
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          Text(
                              'Beschreibe deine Beobachtungen mit den Pflanzen in deinem Aquarium.',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black)),
                          const SizedBox(height: 10),
                          TextField(
                            controller: problemDescriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Beschreibe deine Beobachtungen...',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.lightGreen,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
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
      bottomNavigationBar: BottomAppBar(
        height: 120,
        child: Column(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightGreen),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(200, 40)),
              ),
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  setState(() {
                    _isLoading = true;
                  });
                  widget.aiOptimizerObject.plantGrowthProblem =
                      plantGrowthProblem;
                  widget.aiOptimizerObject.plantDeficiencySymptom =
                      plantDeficiencySymptom;
                  widget.aiOptimizerObject.plantDeficiencySymptomDescription =
                      selectedTags.toList().toString();
                  widget.aiOptimizerObject.plantProblemDescription =
                      problemDescriptionController.text;
                  executeOptimizer();
                }
              },
              child: const Text("Analyse starten"),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                LinearProgressIndicator(
                  value: 0.99,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                ),
                const SizedBox(height: 10),
                Text("Fortschritt: 99%",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
