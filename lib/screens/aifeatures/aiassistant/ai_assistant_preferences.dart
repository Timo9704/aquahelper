import 'package:flutter/material.dart';

class AiAssistantPreferences extends StatefulWidget {
  const AiAssistantPreferences({super.key});

  @override
  State<AiAssistantPreferences> createState() => _AiAssistantPreferencesState();
}

class _AiAssistantPreferencesState extends State<AiAssistantPreferences> {
  bool useOwnData = false;
  String experienceLevel = 'Anfänger';
  String detailLevel = 'kurz';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Assistent - Einstellungen"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                const Text("Einstellungen",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                const Text(
                    "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black)),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text("Verwendung eigener Daten zulassen"),
                  value: useOwnData,
                  onChanged: (bool? newValue) {
                    setState(() {
                      useOwnData = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Erfahrungslevel'),
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
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Ausführlichkeit'),
                  value: detailLevel,
                  items: ['kurz', 'normal', 'ausführlich']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      detailLevel = newValue!;
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
