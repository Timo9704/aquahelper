import 'package:aquahelper/screens/aifeatures/aiplanner/ai_planner_guide.dart';
import 'package:flutter/material.dart';
import '../../../../model/ai_optimizer_storage.dart';
import '../../../../model/aquarium.dart';
import '../../../../util/datastore.dart';
import '../../../../util/scalesize.dart';
import 'ai_optimizer_animals.dart';

class AiOptimizerAquarium extends StatefulWidget {
  final AiOptimizerStorage aiOptimizerObject;

  const AiOptimizerAquarium({super.key, required this.aiOptimizerObject});


  @override
  State<AiOptimizerAquarium> createState() => _AiOptimizerAquariumState();
}

class _AiOptimizerAquariumState extends State<AiOptimizerAquarium> {
  double textScaleFactor = 0;
  TextEditingController problemDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool waterClear = true;
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];
  Set<String> selectedTags = <String>{};
  List<String> tags = [
    'farblos trüb',
    'weißlich',
    'grünlich',
    'bräunlich'
  ];

  @override
  void initState() {
    super.initState();
    loadAquariums();
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

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      _aquariumNames = dbAquariums;
      _selectedAquarium = dbAquariums.first;
      widget.aiOptimizerObject.aquariumId = _selectedAquarium!.aquariumId;
    });
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Optimierer"),
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
                    "Hier kannst du die Eigenschaften des Aquariums planen. Die folgenden Fragen helfen uns dabei, das passende Aquarium für deine Anforderungen zu finden. Wir berücksichtigen dabei deine Bedürfnisse, um ein harmonisches Gesamtbild zu schaffen.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black)),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(children: [
                        Text(
                            'Welches Aquarium möchtest du optimieren?',
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
                              widget.aiOptimizerObject.aquariumId =
                                  _selectedAquarium!.aquariumId;
                            });
                          },
                        ),
                      ]),
                      const SizedBox(height: 20),
                      Text('Beschreibe in welchen Bereichen du dein Aquarium optimieren möchtest bzw. in welchen Bereichen du unzufrieden bist?',
                          textScaler: TextScaler.linear(textScaleFactor),
                          textAlign: TextAlign.center,
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
                      const SizedBox(height: 20),
                      Text('Ist dein Aquarienwasser glasklar?',
                          textScaler: TextScaler.linear(textScaleFactor),
                          textAlign: TextAlign.center,
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
                              groupValue: waterClear,
                              onChanged: (value) {
                                setState(() {
                                  waterClear = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Nein'),
                              value: false,
                              activeColor: Colors.lightGreen,
                              groupValue: waterClear,
                              onChanged: (value) {
                                setState(() {
                                  waterClear = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if(waterClear == false)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                "Welche Trübung/Verfärbung weisst dein Aquarienwasser auf?",
                                textScaler: TextScaler.linear(textScaleFactor),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black)),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 5.0,
                              alignment: WrapAlignment.center,
                              children: tags
                                  .map((tag) => FilterChip(
                                labelPadding: const EdgeInsets.all(5),
                                label: Text(tag,
                                    textScaler: TextScaler.linear(textScaleFactor),
                                    style: const TextStyle(
                                        fontSize: 14)),
                                selected: selectedTags.contains(tag),
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
                  widget.aiOptimizerObject.waterClear = waterClear;
                  widget.aiOptimizerObject.waterTurbidity = selectedTags.toList().toString();
                  widget.aiOptimizerObject.aquariumProblemDescription = problemDescriptionController.text;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AiOptimizerAnimals(
                              aiOptimizerObject: widget.aiOptimizerObject)));
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
