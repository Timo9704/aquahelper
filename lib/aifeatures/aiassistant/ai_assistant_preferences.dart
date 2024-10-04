import 'package:flutter/material.dart';

import '../../model/aquarium.dart';
import '../../model/assistant_preferences.dart';
import '../../util/datastore.dart';
import '../../util/scalesize.dart';

class AiAssistantPreferences extends StatefulWidget {
  const AiAssistantPreferences({super.key});

  @override
  State<AiAssistantPreferences> createState() => _AiAssistantPreferencesState();
}

class _AiAssistantPreferencesState extends State<AiAssistantPreferences> {
  bool useOwnData = false;
  String experienceLevel = 'Anfänger';
  String detailLevel = 'kurz';
  double textScaleFactor = 0;
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];

  @override
  void initState() {
    super.initState();
    loadAquariums();
    getPreferences();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      _aquariumNames = dbAquariums;
      _selectedAquarium = dbAquariums.first;
    });
  }

  void savePreferences() {
    String aquariumId = "";
    final selectedAquarium = _selectedAquarium;
    if(selectedAquarium != null){
      aquariumId = selectedAquarium.aquariumId;
    }
    AssistantPreferences preferences = AssistantPreferences(useOwnData.toString(), aquariumId, experienceLevel, detailLevel);
    Datastore.db.saveAIAssistantPreferences(preferences);
  }

  getPreferences() async {
    AssistantPreferences preferences = await Datastore.db.getAIAssistantPreferences();
    setState(() {
      useOwnData = preferences.useOwnData == 'true';
      experienceLevel = preferences.experienceLevel;
      detailLevel = preferences.detailLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Assistent - Einstellungen"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                Text("Einstellungen",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                Text(
                    "Willkommen in den Einstellungen deines digitalen Aquaristik-Experten! Hier kannst du deinen Assistenten genau an deine Bedürfnisse und dein Aquarium anpassen, um das Beste aus eurer Zusammenarbeit herauszuholen.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 17, color: Colors.black)),
                const SizedBox(height: 10),
                Text(
                    "1. Verwendung von eigenen Daten:",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w800)),
                Text(
                    "Aktiviere diese Option, um dem Assistenten zu erlauben, deine spezifischen Aquariendaten und Wasserwerte zu analysieren.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 15, color: Colors.black)),
                CheckboxListTile(
                  title: const Text("Verwendung eigener Daten zulassen"),
                  value: useOwnData,
                  activeColor: Colors.lightGreen,
                  onChanged: (bool? newValue) {
                    setState(() {
                      useOwnData = newValue!;
                      savePreferences();
                    });
                  },
                ),
                DropdownButton<Aquarium>(
                  value: _selectedAquarium,
                  items: _aquariumNames.map<DropdownMenuItem<Aquarium>>((Aquarium value) {
                    return DropdownMenuItem<Aquarium>(
                      value: value,
                      child: Text(value.name  ,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAquarium = newValue;
                      savePreferences();
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                    "2. Erfahrungslevel:",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w800)),
                Text(
                    "Gib deinen Erfahrungslevel an, um maßgeschneiderte Antworten zu erhalten. Als Anfänger erhältst du einfache, leicht verständliche Antworten. Als Fortgeschrittener bekommst du detailliertere Informationen, während du als Experte weniger allgemeine Erläuterungen erwarten kannst.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 15, color: Colors.black)),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: experienceLevel,
                  items: ['Anfänger', 'Fortgeschritten', 'Experte']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      experienceLevel = newValue!;
                      savePreferences();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                    "3. Ausführlichkeit:",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w800)),
                Text(
                    "Gib den Grad der Ausführlichkeit der Antworten an.  Wähle die kurze Option für schnelle und prägnante Antworten, die normale Option für eine ausgewogene Mischung aus Tiefe und Kürze, oder die ausführliche Option für tiefgreifende, detaillierte Erklärungen und Anleitungen.",
                    textScaler: TextScaler.linear(textScaleFactor),
                    style: const TextStyle(fontSize: 15, color: Colors.black)),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: detailLevel,
                  items: ['kurz', 'normal', 'ausführlich'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      detailLevel = newValue!;
                      savePreferences();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
