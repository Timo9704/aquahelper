import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'ai_planner_guide.dart';
class AiPlannerResult extends StatefulWidget {

  const AiPlannerResult({super.key});

  @override
  State<AiPlannerResult> createState() => _AiPlannerResultState();
}

class _AiPlannerResultState extends State<AiPlannerResult> {

  @override
  void initState() {
    super.initState();
  }

  final jsonData = '''
  {
    "aquarium": {
      "aquarium_name" : "Juwel Rio 125",
      "aquarium_liter" : "180",
      "aquarium_price" : "299.99",
      "aquarium_technic" : ["Filter", "Heizer"]
    },
    "special_technic": {
      "filter" : "eingebaut",
      "light" : "Chihiros WRGB2",
      "co2" : "Dennerle ProFlora 360"
    },
    "plants": {
      "foreground" : [
          {
              "name" : "Eleocharis acicularis",
              "amount" : "5",
              "price" : "2.99"
          },
          {
              "name" : "Lilaeopsis brasiliensis",
              "amount" : "3",
              "price" : "3.99"
          }
      ],
      "midground" : [
          {
              "name" : "Cryptocoryne wendtii",
              "amount" : "2",
              "price" : "4.99"
          },
          {
              "name" : "Hygrophila pinnatifida",
              "amount" : "1",
              "price" : "5.99"
          }
      ],
      "background" : [
          {
              "name" : "Echinodorus bleheri",
              "amount" : "1",
              "price" : "6.99"
          },
          {
              "name" : "Vallisneria spiralis",
              "amount" : "3",
              "price" : "7.99"
          }
      ]
    },
    "animals": {
      "fishes" : [
          {
              "name" : "Neons",
              "amount" : "10",
              "price" : "1.99"
          },
          {
              "name" : "Guppys",
              "amount" : "5",
              "price" : "2.99"
          }
      ],
      "shrimps" : [
          {
              "name" : "Red Fire",
              "amount" : "5",
              "price" : "3.99"
          },
          {
              "name" : "Amano",
              "amount" : "3",
              "price" : "4.99"
          }
      ],
      "snails" : [
          {
              "name" : "Posthorn",
              "amount" : "2",
              "price" : "5.99"
          },
          {
              "name" : "Turmdeckelschnecke",
              "amount" : "1",
              "price" : "6.99"
          }
      ]
    }
  }
  ''';

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
    final data = jsonDecode(jsonData);
    return Scaffold(
        appBar: AppBar(
          title: const Text("KI-Planer - Bepflanzung"),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
        children: [
          buildSection('Aquarium & Technik', data['aquarium']),
          buildSection('Zubehör', data['special_technic']),
          buildSection('Besatz', data['animals']),
          buildSection('Bepflanzung', data['plants']),
        ],
      ),
      )
    );
  }

  Widget buildSection(String title, Map<String, dynamic> sectionData) {
    List<Widget> tiles = [Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))];
    sectionData.forEach((key, value) {
      if (value is Map) {
        tiles.add(
            ListTile(
              title: Text(key),
              subtitle: Text(value['name']),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => launch('https://example.com/${value['name']}'),
              ),
            )
        );
      } else if (value is List) {
        for (var item in value) {
          tiles.add(
              ListTile(
                title: Text(key),
                subtitle: Text('Test'),
                trailing: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => launch('https://example.com/${item['name']}'),
                ),
              )
          );
        }
      } else {
        tiles.add(
            ListTile(
              title: Text(key),
              subtitle: Text(value.toString()),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => launch('https://example.com/$key'),
              ),
            )
        );
      }
    });
    return Card(child: Column(children: tiles));
  }
}
