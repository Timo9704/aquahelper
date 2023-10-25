import 'package:flutter/material.dart';

class CreateOrEditAquarium extends StatefulWidget {
  const CreateOrEditAquarium({Key? key}) : super(key: key);

  @override
  _CreateOrEditAquariumState createState() => _CreateOrEditAquariumState();
}

class _CreateOrEditAquariumState extends State<CreateOrEditAquarium> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _literController = TextEditingController();
  String imageUrl =
      'https://m.media-amazon.com/images/I/81yqxPIhllL.__AC_SX300_SY300_QL70_ML2_.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neues Aquarium'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 150.0,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://aquaristik-kosmos.de/wp-content/uploads/2022/12/Aquarium_weboptimiert_720p_low.jpg'),
                      // Bild von URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: const Text('Erstellen/bearbeiten:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  child: Column(
                    children: [
                      const Text("Wie heißt das Aquarium?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          )),
                      TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                    ),
                ),
                const SizedBox(height:10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  child: Column(
                    children: [
                      const Text("Wie viel Liter hat das Aquarium?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          )),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          fillColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: () => {}, child: const Text("Löschen")),
                    ElevatedButton(onPressed: () => {}, child: const Text("Speichern"))
                  ],
                )
              ],
            ),
          )),
    ));
  }
}
