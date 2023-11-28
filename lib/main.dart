import 'package:flutter/material.dart';
import 'dart:async';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/widget/aquarium_item.dart';
import 'package:aquahelper/screens/create_or_edit_aquarium.dart';
import 'package:aquahelper/screens/infopage.dart';
import 'package:aquahelper/util/dbhelper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.db.initDB();
  runApp(const AquaHelper());
}

class AquaHelper extends StatelessWidget {
  const AquaHelper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaHelper',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen
      ),
      home: const AquaHelperStartPage(),
    );
  }
}

class AquaHelperStartPage extends StatefulWidget {
  const AquaHelperStartPage({Key? key}) : super(key: key);

  final String title = 'AquaHelper';

  @override
  State<AquaHelperStartPage> createState() => _AquaHelperStartPageState();
}

class _AquaHelperStartPageState extends State<AquaHelperStartPage> {
  List<Aquarium> aquariums = [];

  @override
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
                ];
              },
              onSelected:(value) {
                if (value == 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => InfoPage()),
                  );
                }
              }
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
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
          aquariums.length == 0 ?
          Center(
            heightFactor: 15,
            child: const Text("Lege dein erstes Aquarium an!",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ):
          SizedBox(
            height: MediaQuery.of(context).size.height-170,
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
