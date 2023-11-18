import 'package:aquahelper/screens/create_or_edit_aquarium.dart';
import 'package:aquahelper/util/dbhelper.dart';
import 'package:aquahelper/widget/aquarium_item.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'model/aquarium.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.db.initDB();
  await DBHelper.db.insertAquarien();
  runApp(const AquaHelper());
}

class AquaHelper extends StatelessWidget {
  const AquaHelper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaHelper',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
          //scaffoldBackgroundColor: const Color(0xFF343434)
      ),
      home: const AquaHelperStartPage(title: 'AquaHelper'),
    );
  }
}

class AquaHelperStartPage extends StatefulWidget {
  const AquaHelperStartPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AquaHelperStartPage> createState() => _AquaHelperStartPageState();
}

class _AquaHelperStartPageState extends State<AquaHelperStartPage> {
  List<Aquarium> aquariums = [];

  void initState() {
    super.initState();
    loadAquariums();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await DBHelper.db.getAquariums();
    setState(() {
      aquariums = dbAquariums;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("AquaHelper"),
        backgroundColor: Colors.lightGreen,
        actions: [
          PopupMenuButton(
              itemBuilder: (context){
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Informationen"),
                  ),

                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Export"),
                  ),
                ];
              },
              onSelected:(value) {
                if (value == 0) {
                  print("My account menu is selected.");
                } else if (value == 1) {
                  print("Settings menu is selected.");
                }
              }
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Alle Aquarien:', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w800)),
                IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateOrEditAquarium()),
                    ),
                    icon: const Icon(Icons.add,
                      color: Colors.lightGreen,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: aquariums.length,
              itemBuilder: (context, index) {
                return AquariumItem(aquarium: aquariums.elementAt(index));
              },
            ),
          )
        ],
      ),
    );
  }
}
