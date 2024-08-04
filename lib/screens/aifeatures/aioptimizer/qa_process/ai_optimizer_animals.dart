import 'package:flutter/material.dart';
import '../../../../model/ai_optimizer_storage.dart';
import '../../../../util/scalesize.dart';
import 'ai_optimizer_plants.dart';

class AiOptimizerAnimals extends StatefulWidget {
  final AiOptimizerStorage aiOptimizerObject;

  const AiOptimizerAnimals({super.key, required this.aiOptimizerObject});

  @override
  State<AiOptimizerAnimals> createState() => _AiOptimizerAnimalsState();
}

class _AiOptimizerAnimalsState extends State<AiOptimizerAnimals> {
  TextEditingController problemDescriptionController = TextEditingController();
  double textScaleFactor = 0;
  bool fishHealthy = true;
  bool fishDiverseFeed = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Optimierer"),
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
                          Text('Hast du das Gefühl, dass des deinem Besatz gut geht?',
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
                                  groupValue: fishHealthy,
                                  onChanged: (value) {
                                    setState(() {
                                      fishHealthy = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text('Nein'),
                                  value: false,
                                  activeColor: Colors.lightGreen,
                                  groupValue: fishHealthy,
                                  onChanged: (value) {
                                    setState(() {
                                      fishHealthy = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('Nutzt du verschiedene Futterarten (z.B. Flocken, Granulat, Lebend- oder Frostfutter)?',
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
                                  groupValue: fishDiverseFeed,
                                  onChanged: (value) {
                                    setState(() {
                                      fishDiverseFeed = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text('Nein'),
                                  value: false,
                                  activeColor: Colors.lightGreen,
                                  groupValue: fishDiverseFeed,
                                  onChanged: (value) {
                                    setState(() {
                                      fishDiverseFeed = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Text('Beschreibe deine Beobachtungen mit den Tieren in deinem Aquarium.',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black)),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
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
                  widget.aiOptimizerObject.fishHealthProblem = fishHealthy;
                  widget.aiOptimizerObject.fishDiverseFeed = fishDiverseFeed;
                  widget.aiOptimizerObject.fishProblemDescription = problemDescriptionController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AiOptimizerPlants(
                        aiOptimizerObject: widget.aiOptimizerObject,
                      ),
                    ),
                  );
                }
              },
              child: const Text("Weiter zur Bepflanzung"),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                LinearProgressIndicator(
                  value: 0.66,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                ),
                const SizedBox(height: 10),
                Text("Fortschritt: 66%",
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
