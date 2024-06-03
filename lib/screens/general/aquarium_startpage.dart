import 'package:flutter/material.dart';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/widget/aquarium_item.dart';
import 'package:aquahelper/screens/general/create_or_edit_aquarium.dart';

import '../../util/datastore.dart';


class AquariumStartPage extends StatefulWidget {
  const AquariumStartPage({super.key});

  final String title = 'AquaHelper';

  @override
  State<AquariumStartPage> createState() => _AquariumStartPageState();
}

class _AquariumStartPageState extends State<AquariumStartPage> {
  List<Aquarium> aquariums = [];


  @override
  void initState() {
    super.initState();
    loadAquariums();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      aquariums = dbAquariums;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          aquariums.isEmpty ?
          Center(
            heightFactor: MediaQuery.of(context).size.height < 650 ? 10 : 15,
            child: const Text("Lege dein erstes Aquarium an!",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ):
          SizedBox(
            height: MediaQuery.of(context).size.height-205,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: aquariums.length,
              itemBuilder: (context, index) {
                return AquariumItem(aquarium: aquariums.elementAt(index));
              },
            ),
          )
        ],
      );
  }
}