import 'package:flutter/material.dart';

import 'ai_planner_guide.dart';

class AiPlannerResult extends StatefulWidget {
  final Map<String, dynamic> jsonData;
  final int planningMode;
  const AiPlannerResult({super.key, required this.jsonData, required this.planningMode});

  @override
  State<AiPlannerResult> createState() => _AiPlannerResultState();
}

class _AiPlannerResultState extends State<AiPlannerResult> {
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
    final Map<String, dynamic> data = widget.jsonData;

    return Scaffold(
      appBar: AppBar(
        title: const Text("KI-Planer"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("KI-Planer",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w800)),
            const Text("Planungsergebnis",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            const SizedBox(height: 10),
            if(widget.planningMode == 0)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columnSpacing: 10,
                  dataRowMaxHeight: 50,
                  columns: [
                    DataColumn(
                      label: const SizedBox(
                        width: 130, // gleiche Breite für alle Spalten
                        child: Text(''),
                      ),
                      onSort: (int columnIndex, bool ascending) => {},
                    ),
                    const DataColumn(
                      label: SizedBox(
                        width: 160, // gleiche Breite für alle Spalten
                        child: Text('Name'),
                      ),
                    ),
                    const DataColumn(
                      label: SizedBox(
                        width: 50, // gleiche Breite für alle Spalten
                        child: Text(''),
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('Aquarium-Modell')),
                      DataCell(Text(data['aquarium']['aquarium_name'])),
                      DataCell(LinkWidget(data['aquarium']['link'])),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Preis')),
                      DataCell(Text(data['aquarium']['aquarium_price'])),
                      DataCell(SizedBox.shrink()),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Bestandteile')),
                      DataCell(
                          Text(data['aquarium']['included_items'].join(', '))),
                      DataCell(SizedBox.shrink()),
                    ]),
                  ],
                ),
              ),
            if(widget.planningMode == 0 || widget.planningMode == 1)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columnSpacing: 10,
                  dataRowMaxHeight: 50,
                  columns: [
                    DataColumn(
                      label: const SizedBox(
                        width: 130, // gleiche Breite für alle Spalten
                        child: Text('Fischart'),
                      ),
                      onSort: (int columnIndex, bool ascending) => {},
                    ),
                    const DataColumn(
                      label: SizedBox(
                        width: 160, // gleiche Breite für alle Spalten
                        child: Text('Menge'),
                      ),
                    ),
                    const DataColumn(
                      label: SizedBox(
                        width: 50, // gleiche Breite für alle Spalten
                        child: Text(''),
                      ),
                    ),
                  ],
                  rows: data['fish']
                      .map<DataRow>((fish) => DataRow(cells: [
                            DataCell(Text(fish['fish_common_name'])),
                            DataCell(Text(fish['quantity'].toString())),
                            DataCell(LinkWidget(fish['link'])),
                          ]))
                      .toList(),
                ),
              ),
            if(widget.planningMode == 0 || widget.planningMode == 2)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columnSpacing: 10,
                  dataRowMaxHeight: 50,
                  columns: [
                    DataColumn(
                      label: const SizedBox(
                        width: 130, // gleiche Breite für alle Spalten
                        child: Text('Pflanzenart'),
                      ),
                      onSort: (int columnIndex, bool ascending) => {},
                    ),
                    const DataColumn(
                      label: SizedBox(
                        width: 160, // gleiche Breite für alle Spalten
                        child: Text('Gestaltungstyp'),
                      ),
                    ),
                    const DataColumn(
                      label: SizedBox(
                        width: 50, // gleiche Breite für alle Spalten
                        child: Text(''),
                      ),
                    ),
                  ],
                  rows: data['plants']
                      .map<DataRow>((plant) => DataRow(cells: [
                            DataCell(Text(plant['plant_name'])),
                            DataCell(Text(plant['plant_type'].toString())),
                            DataCell(LinkWidget(plant['link'])),
                          ]))
                      .toList(),
                ),
              ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: Text(data['reason']),
              ),
          ],
        ),
      ),
    );
  }
}

class LinkWidget extends StatelessWidget {
  final String url;

  LinkWidget(this.url);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Icon(Icons.shopping_cart, color: Colors.lightGreen),
      onTap: () => launchURL(url),
    );
  }

  void launchURL(String url) async {
    // Hier solltest du den URL im Browser öffnen. In einem richtigen App würde man Flutter's url_launcher benutzen.
    print('Öffne URL: $url');
  }
}
