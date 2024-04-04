import 'package:flutter/material.dart';

import '../../model/aquarium.dart';
import '../../util/datastore.dart';

class GroundCalculator extends StatefulWidget {
  const GroundCalculator({super.key});

  @override
  State<GroundCalculator> createState() => _GroundCalculatorState();
}

class _GroundCalculatorState extends State<GroundCalculator> {
  String? _selectedGround = "Soil";
  final List<String> _groundNames = ["Soil", "Kies", "Sand"];
  Aquarium? _selectedAquarium;
  List<Aquarium> _aquariumNames = [];

  String ergebnis = "";

  final _aquariumHeightController = TextEditingController();
  final _aquariumDepthController = TextEditingController();
  final _startHeightController = TextEditingController();
  final _endHeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAquariums();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      _aquariumNames = dbAquariums;
    });
  }

  double parseTextFieldValue(String value){
    if(value.isEmpty){
      return 0.0;
    }
    return double.parse(value.replaceAll(RegExp(r','), '.'));
  }

  void calculateGround() {
    String result = "";
    double triangleVol = 0.0;
    try {
      double start = parseTextFieldValue(_startHeightController.text);
      double end = parseTextFieldValue(_endHeightController.text);
      double rectVol = 0;
      if (start > 0) {
        rectVol = start *
            parseTextFieldValue(_aquariumDepthController.text) *
            parseTextFieldValue(_aquariumHeightController.text) /
            1000;
        end -= start;
      }
      triangleVol = (end * parseTextFieldValue(_aquariumDepthController.text) /
          2) *
          parseTextFieldValue(_aquariumHeightController.text) /
          1000;
      triangleVol += rectVol;

    } catch (e) {
     triangleVol = 0.0;
     inputFailure();
    }

    if (_selectedGround == "Soil") {
      result = "${triangleVol.round()}l Soil";
    } else if (_selectedGround == "Sand") {
      result = "${(triangleVol * 1.9).round()}kg Sand";
    } else if (_selectedGround == "Kies") {
      result = "${(triangleVol * 1.5).round()}kg Kies";
    }

    setState(() {
      ergebnis = result;
    });
  }

  void inputFailure() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Fehlerhafte Eingabe"),
          content: const SizedBox(
            height: 60,
            child: Column(
              children: [
                Text("Kontrolliere bitte deine Eingaben! Zahlenwerte sind als Komma- oder Ganzzahl einzugeben."),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
              child: const Text("Schließen"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          elevation: 0,
        );
      },
    );
  }

 /*Widget threeDRectangle() {
    return Stack(
      children: [
        // Vorderseite
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(0.0, 50.0)
            ..rotateX(0)
            ..rotateY(0)
            ..rotateZ(0),
          alignment: FractionalOffset.center,
          child: Container(
            height: 100,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
        ),
        // Oberseite
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(0.0, 50.0)
            ..rotateX(0)
            ..rotateY(-3.14 / 3) // -45 Grad Rotation
            ..rotateZ(0),
          alignment: Alignment.centerLeft,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
        ),
        // Seite
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(200.0, 50.0)
            ..rotateX(0)
            ..rotateY(-3.14 / 3) // -45 Grad Rotation
            ..rotateZ(0),
          alignment: Alignment.centerLeft,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(50.0, 50.0 ,100.0)
            ..rotateX(0)
            ..rotateY(0) // -45 Grad Rotation
            ..rotateZ(0),
          alignment: Alignment.centerLeft,
          child: Container(
            height: 100,
            width: 205,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.7),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Bodengrund-Rechner"),
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text("Berechne die benötigte Bodengrund-Menge:",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text("aufsteigender Bodengrund",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/quader.png',
                        height: 110,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButton<Aquarium>(
                  value: _selectedAquarium,
                  hint: const Text('Wähle dein Aquarium',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                      fontWeight: FontWeight.normal)),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAquarium = newValue;
                      _aquariumHeightController.text = _selectedAquarium!.width.toString();
                      _aquariumDepthController.text = _selectedAquarium!.height.toString();
                    });
                  },
                  items: _aquariumNames.map<DropdownMenuItem<Aquarium>>((Aquarium value) {
                    return DropdownMenuItem<Aquarium>(
                      value: value,
                      child: Text(
                          value.name,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black)),
                    );
                  }).toList(),
                ),
                const Text("oder",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Aquarium Länge (in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _aquariumHeightController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Aquarium Tiefe (in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _aquariumDepthController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bodengrund-Höhe (vorn in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _startHeightController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bodengrund-Höhe (hinten in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _endHeightController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Wähle deine Bodengrund-Art:',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
                DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: _selectedGround,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGround = newValue;
                    });
                  },
                  items: _groundNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black)),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width - 80,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Du benötigst ungefähr: $ergebnis",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)),
                      onPressed: () => {calculateGround()},
                      child: const Text("Berechnen")),
                )
              ],
            ),
          ),
        ));
  }
}
